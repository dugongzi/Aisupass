package org.supass.ai_su_pass.core.adb

import android.content.Context
import android.os.Build
import android.util.Log
import android.sun.security.x509.AlgorithmId
import android.sun.security.x509.CertificateAlgorithmId
import android.sun.security.x509.CertificateIssuerName
import android.sun.security.x509.CertificateSerialNumber
import android.sun.security.x509.CertificateSubjectName
import android.sun.security.x509.CertificateValidity
import android.sun.security.x509.CertificateVersion
import android.sun.security.x509.CertificateX509Key
import android.sun.security.x509.X500Name
import android.sun.security.x509.X509CertImpl
import android.sun.security.x509.X509CertInfo
import java.io.File
import java.io.IOException
import java.math.BigInteger
import java.security.KeyFactory
import java.security.KeyPairGenerator
import java.security.PrivateKey
import java.security.PublicKey
import java.security.SecureRandom
import java.security.cert.Certificate
import java.security.cert.CertificateFactory
import java.security.spec.PKCS8EncodedKeySpec
import java.util.Date
import java.util.concurrent.TimeUnit

/**
 * 一对 ADB 凭据：私钥 + 自签证书。
 *
 * 配对（SPAKE2 交换 PeerInfo）和连接（AUTH 签名）必须使用**同一套**密钥，
 * 否则配对成功也连不上，因此这里把它们绑成一个对象返回。
 */
internal class AdbCredentials(
    val privateKey: PrivateKey,
    val certificate: Certificate,
)

/**
 * ADB 凭据仓库：负责生成、持久化、按需重读自签 RSA 密钥对。
 *
 * 为什么每次都要从磁盘重读，而不是内存里缓存一份：
 * libadb 的 `AbsAdbConnectionManager.close()` 与 `AdbConnection.close()` 收尾时会调用
 * `PrivateKey.destroy()` 把私钥内部参数抹掉（字节码已确认）。一旦缓存同一个对象，
 * 第一次断开之后所有后续连接都会拿到一把「已销毁」的废钥。持久化格式选 PKCS#8（私钥）
 * 与 DER（证书），重读时重新 `KeyFactory.generatePrivate`，天然规避销毁问题。
 *
 * 存放位置：`filesDir/adb/`。应用私有目录，卸载即清理；不需要额外权限。
 *
 * 证书只用于向设备证明「这把公钥属于我」：adbd 只拿它校验 AUTH 签名，
 * 不校验证书链，所以自签即可。生成逻辑依赖 `sun-security-android`
 * （包名已 repackage 为 `android.sun.security.x509.*`）。
 */
internal class AdbKeyStore(context: Context) {

    private val dir = File(context.filesDir, DIR_NAME)
    private val keyFile = File(dir, KEY_FILE)
    private val certFile = File(dir, CERT_FILE)

    /**
     * 上报给设备的 host 名字（`AUTH(3)` 里 `AndroidPubkey.encodeWithName` 的前缀）。
     * 只影响设备「已授权设备」列表里的显示，不参与密钥计算。
     */
    val deviceName: String by lazy { buildDeviceName() }

    /**
     * 确保磁盘上有一对可用的凭据；缺失或损坏时重新生成。
     *
     * @return true 表示调用结束后磁盘上的凭据可读。
     */
    @Synchronized
    fun ensure(): Boolean {
        val ok = runCatching {
            if (!isReadable(keyFile) || !isReadable(certFile) || load() == null) {
                Log.i(TAG, "generating adb credentials into $dir")
                generate()
            }
            load() != null
        }.onFailure {
            // 证书组装依赖 android.sun.security.x509 的强类型 API，任何一步失败都会
            // 被 runCatching 吞成 false；不打堆栈的话上层只能报「凭据不可用」，
            // 完全查不出是哪种失败。
            Log.e(TAG, "ensure credentials threw", it)
        }.getOrDefault(false)
        if (!ok) Log.w(TAG, "adb credentials unavailable (dir=$dir)")
        return ok
    }

    /**
     * 从磁盘重新读出一对全新对象。
     *
     * 不做缓存是刻意的：libadb 会把上一次用过的私钥 destroy 掉。
     * 返回 null 表示磁盘上没有可用凭据（调用方应先 [ensure]）。
     */
    fun load(): AdbCredentials? = runCatching {
        if (!isReadable(keyFile) || !isReadable(certFile)) return@runCatching null
        val privateKey = KeyFactory.getInstance(KEY_ALGORITHM)
            .generatePrivate(PKCS8EncodedKeySpec(keyFile.readBytes()))
        // 必须把 generateCertificate 放进 use 块内部：`use { it }` 会把流原样返回后
        // 立刻关闭，CertificateFactory 再读到的是一个已关闭的流，直接抛
        // CertificateException(IOException: Stream Closed)，导致凭据永远「不可用」。
        val certificate = certFile.inputStream().use { stream ->
            CertificateFactory.getInstance(CERT_TYPE).generateCertificate(stream)
        }
        AdbCredentials(privateKey, certificate)
    }.onFailure {
        Log.e(TAG, "load credentials threw", it)
    }.getOrNull()

    /** 生成 RSA 2048 密钥对与自签证书，并落盘。 */
    private fun generate() {
        if (!dir.isDirectory && !dir.mkdirs()) {
            throw IOException("cannot create $dir")
        }

        val generator = KeyPairGenerator.getInstance(KEY_ALGORITHM)
        generator.initialize(KEY_SIZE_BITS, SecureRandom())
        val keyPair = generator.generateKeyPair()

        val certificate = buildSelfSigned(keyPair.private, keyPair.public)
        writeAtomically(keyFile, keyPair.private.encoded)
        writeAtomically(certFile, certificate.getEncoded())
    }

    /**
     * 用 `sun-security-android` 的 X509CertInfo 组装一张自签证书。
     *
     * 注意 `X509CertInfo.set` 是**强类型**的：`SERIAL_NUMBER` 只接受
     * `CertificateSerialNumber`（不是 `SerialNumber`），其余字段同理各要对应的包装类，
     * 传错类型会抛 `CertificateException("... class type invalid.")`。
     */
    private fun buildSelfSigned(privateKey: PrivateKey, publicKey: PublicKey): X509CertImpl {
        val now = System.currentTimeMillis()
        val notBefore = Date(now - TimeUnit.DAYS.toMillis(1))
        val notAfter = Date(now + TimeUnit.DAYS.toMillis(VALIDITY_DAYS))

        val info = X509CertInfo()
        info.set(X509CertInfo.VERSION, CertificateVersion(CertificateVersion.V3))
        info.set(X509CertInfo.SERIAL_NUMBER, CertificateSerialNumber(newSerial()))
        info.set(X509CertInfo.ALGORITHM_ID, CertificateAlgorithmId(AlgorithmId.get(SIGNATURE_ALGORITHM)))
        info.set(X509CertInfo.ISSUER, CertificateIssuerName(X500Name("CN=$COMMON_NAME")))
        info.set(X509CertInfo.SUBJECT, CertificateSubjectName(X500Name("CN=$COMMON_NAME")))
        info.set(X509CertInfo.VALIDITY, CertificateValidity(notBefore, notAfter))
        info.set(X509CertInfo.KEY, CertificateX509Key(publicKey))

        return X509CertImpl(info).apply { sign(privateKey, SIGNATURE_ALGORITHM) }
    }

    /** 证书序列号：正整数，64 位随机，满足 RFC 5280 对正数的要求。 */
    private fun newSerial(): BigInteger = BigInteger(64, SecureRandom())

    /** 先写临时文件再改名，避免进程被杀时留下半个密钥文件。 */
    private fun writeAtomically(target: File, bytes: ByteArray) {
        val tmp = File(dir, "${target.name}.tmp")
        tmp.writeBytes(bytes)
        if (target.exists() && !target.delete()) {
            throw IOException("cannot replace $target")
        }
        if (!tmp.renameTo(target)) {
            throw IOException("cannot rename $tmp to $target")
        }
    }

    private fun isReadable(file: File): Boolean = file.isFile && file.length() > 0L

    private fun buildDeviceName(): String {
        val model = Build.MODEL.orEmpty()
            .replace(Regex("[^A-Za-z0-9._-]"), "-")
            .trim('-')
            .take(MAX_MODEL_CHARS)
        return if (model.isEmpty()) DEVICE_PREFIX else "$DEVICE_PREFIX-$model"
    }

    private companion object {
        /** 与配对链路其他组件共用标签，便于一次过滤。 */
        const val TAG = "AdbEscalation"

        const val DIR_NAME = "adb"
        const val KEY_FILE = "adbkey.pk8"
        const val CERT_FILE = "adbkey.der"

        const val KEY_ALGORITHM = "RSA"
        const val KEY_SIZE_BITS = 2048
        const val SIGNATURE_ALGORITHM = "SHA256withRSA"
        const val CERT_TYPE = "X.509"

        /** 30 年足够覆盖设备生命周期；adb 不检查有效期。 */
        const val VALIDITY_DAYS = 365L * 30

        /** 证书主题；内容无实际意义，但要保证 X500Name 可解析。 */
        const val COMMON_NAME = "aisupass-adb"

        const val DEVICE_PREFIX = "aisupass"
        const val MAX_MODEL_CHARS = 32
    }
}
