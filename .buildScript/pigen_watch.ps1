# Pigeon codegen (Dart <-> Kotlin contract).
#
# Usage:
#   .\.buildScript\pigen_watch.ps1          generate once, then watch lib/pigeons
#   .\.buildScript\pigen_watch.ps1 -Once    generate once and exit
#
# Layout:
#   lib/pigeons/<sub>/<module>.dart
#     -> lib/generated/<module>.g.dart
#     -> android/app/src/main/kotlin/<BASE_PACKAGE>/<sub>/<Module>Native.g.kt
#
# NOTE: keep this file ASCII-only. PowerShell 5.1 decodes BOM-less UTF-8 as ANSI,
# so non-ASCII comments corrupt the parser.

param(
    [switch]$Once
)

$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding = [System.Text.Encoding]::UTF8

$PIGEON_DIR = "lib/pigeons"
$DART_OUT_DIR = "lib/generated"
$KOTLIN_SRC_ROOT = "android/app/src/main/kotlin"
$BASE_PACKAGE = "org.supass.ai_su_pass"

if (-not (Test-Path $PIGEON_DIR -PathType Container)) {
    Write-Host ">>> Contract dir not found: $PIGEON_DIR" -ForegroundColor Red
    exit 1
}

# Case-insensitive lookup that preserves the developer's original casing.
# Windows FS is case-insensitive, Linux is not; without this guard we would
# create a duplicate file on the other side.
function Get-PreservedCaseName {
    param($dir, $expectedName)
    if (-not (Test-Path $dir -PathType Container)) { return $expectedName }
    $existing = Get-ChildItem -Path $dir -File -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -ieq $expectedName } |
        Select-Object -First 1
    if ($existing) { return $existing.Name }
    return $expectedName
}

# Set-Content -Encoding UTF8 emits a BOM on PowerShell 5 and the Kotlin
# compiler is picky about it, so write raw UTF-8 without BOM.
function Write-Utf8NoBom {
    param($path, $content)
    [System.IO.File]::WriteAllText($path, $content, (New-Object System.Text.UTF8Encoding($false)))
}

function Run-Pigeon {
    param($file)

    $baseFull = (Get-Item $PIGEON_DIR).FullName
    $fileFull = (Get-Item $file).FullName
    $relativePath = $fileFull.Replace($baseFull, "").TrimStart("\").TrimStart("/")
    $relativeDir = [System.IO.Path]::GetDirectoryName($relativePath)

    $fileName = [System.IO.Path]::GetFileNameWithoutExtension($file)
    $dart_out = "$DART_OUT_DIR/$($fileName).g.dart"

    if ($relativeDir -eq "." -or [string]::IsNullOrEmpty($relativeDir)) {
        $kotlin_pkg = $BASE_PACKAGE
    } else {
        $subPkg = $relativeDir.Replace('\', '.').Replace('/', '.')
        $kotlin_pkg = "$BASE_PACKAGE.$subPkg"
    }
    $kotlin_out_dir = "$KOTLIN_SRC_ROOT/$($kotlin_pkg.Replace('.', '/'))"

    $className = ""
    $fileName.Split('_') | ForEach-Object {
        if ($_) { $className += "$([char]::ToUpper($_[0]))$($_.Substring(1))" }
    }

    $kotlinFileName = Get-PreservedCaseName $kotlin_out_dir "${className}Native.g.kt"
    $implFileName   = Get-PreservedCaseName $kotlin_out_dir "${className}NativeImpl.kt"
    $kotlin_file = "$kotlin_out_dir/$kotlinFileName"
    $impl_file = "$kotlin_out_dir/$implFileName"

    Write-Host "`n>>> [Generating] $fileName" -ForegroundColor Cyan

    if (!(Test-Path $DART_OUT_DIR)) { New-Item -ItemType Directory -Path $DART_OUT_DIR | Out-Null }
    if (!(Test-Path $kotlin_out_dir)) { New-Item -ItemType Directory -Path $kotlin_out_dir | Out-Null }

    # Create the Impl skeleton only when it does not exist yet.
    if (!(Test-Path $impl_file)) {
        $impl_content = @"
package $kotlin_pkg

import android.content.Context

class ${className}NativeImpl(private val context: Context) : ${className}Native {
    // TODO: implement ${className}Native
}
"@
        Write-Utf8NoBom $impl_file $impl_content
        Write-Host ">>> Created Impl template: $impl_file" -ForegroundColor Yellow
    }

    dart run pigeon `
        --input "$file" `
        --dart_out "$dart_out" `
        --kotlin_out "$kotlin_file" `
        --kotlin_package "$kotlin_pkg"

    if ($LASTEXITCODE -ne 0) {
        Write-Host ">>> FAILED: $fileName (exit $LASTEXITCODE)" -ForegroundColor Red
    } else {
        Write-Host ">>> OK: $dart_out + $kotlin_file" -ForegroundColor Green
    }
}

Get-ChildItem -Path $PIGEON_DIR -Filter *.dart -Recurse | ForEach-Object { Run-Pigeon $_.FullName }

if ($Once) {
    Write-Host "`n>>> [Once] codegen done." -ForegroundColor Green
    return
}

Write-Host "`n>>> [Watcher] watching $PIGEON_DIR ..." -ForegroundColor Yellow
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = (Get-Item $PIGEON_DIR).FullName
$watcher.Filter = "*.dart"
$watcher.IncludeSubdirectories = $true
$watcher.EnableRaisingEvents = $true

$action = {
    # Editors fire several events per save; wait for the handle to settle.
    Start-Sleep -Milliseconds 300
    $path = $Event.SourceEventArgs.FullPath
    if (-not (Test-Path $path)) { return }
    Write-Host "`nChanged: $($Event.SourceEventArgs.Name)" -ForegroundColor Magenta
    Run-Pigeon $path
}

Register-ObjectEvent $watcher "Changed" -Action $action | Out-Null
Register-ObjectEvent $watcher "Created" -Action $action | Out-Null

while ($true) { Start-Sleep -Seconds 5 }
