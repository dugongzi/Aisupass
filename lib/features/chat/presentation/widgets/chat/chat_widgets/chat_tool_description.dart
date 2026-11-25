import 'package:Aisupass/l10n/app_localizations.dart';

/// 工具名 → 当前语言的说明文案。
///
/// 工具定义里的 description 固定为英文（要发给模型），
/// 手册展示时必须走本地化文案，避免中文环境下读到英文。
/// 词条键沿用工具名，未收录的工具回退到工具自带的英文说明。
String localizedChatToolDescription(AppLocalizations l10n, String name) {
  return switch (name) {
    'get_device_info' => l10n.chatToolDesc_get_device_info,
    'get_root_status' => l10n.chatToolDesc_get_root_status,
    'get_adb_status' => l10n.chatToolDesc_get_adb_status,
    'adb_shell_exec' => l10n.chatToolDesc_adb_shell_exec,
    'adb_pairing_request' => l10n.chatToolDesc_adb_pairing_request,
    'stellar_service_status' => l10n.chatToolDesc_stellar_service_status,
    'web_search' => l10n.chatToolDesc_web_search,
    'fetch_web_page' => l10n.chatToolDesc_fetch_web_page,
    'open_in_browser' => l10n.chatToolDesc_open_in_browser,
    'escalation_get_device_identity' =>
      l10n.chatToolDesc_escalation_get_device_identity,
    'escalation_list_payloads' => l10n.chatToolDesc_escalation_list_payloads,
    'escalation_resolve_payload' =>
      l10n.chatToolDesc_escalation_resolve_payload,
    'escalation_list_root_managers' =>
      l10n.chatToolDesc_escalation_list_root_managers,
    'escalation_get_selected_root_manager' =>
      l10n.chatToolDesc_escalation_get_selected_root_manager,
    'escalation_run_payload' => l10n.chatToolDesc_escalation_run_payload,
    'escalation_run_payload_by_id' =>
      l10n.chatToolDesc_escalation_run_payload_by_id,
    'escalation_handoff_root' => l10n.chatToolDesc_escalation_handoff_root,
    'escalation_select_root_manager' =>
      l10n.chatToolDesc_escalation_select_root_manager,
    'ghost_key_preflight' => l10n.chatToolDesc_ghost_key_preflight,
    'ghost_key_get_run_defaults' => l10n.chatToolDesc_ghost_key_get_run_defaults,
    'ghost_key_save_run_defaults' =>
      l10n.chatToolDesc_ghost_key_save_run_defaults,
    'ghost_key_start' => l10n.chatToolDesc_ghost_key_start,
    'ghost_key_status' => l10n.chatToolDesc_ghost_key_status,
    'ghost_key_cancel' => l10n.chatToolDesc_ghost_key_cancel,
    'ghost_lock_preflight' => l10n.chatToolDesc_ghost_lock_preflight,
    'ghost_lock_start' => l10n.chatToolDesc_ghost_lock_start,
    'ghost_lock_status' => l10n.chatToolDesc_ghost_lock_status,
    'ghost_lock_cancel' => l10n.chatToolDesc_ghost_lock_cancel,
    'ghost_lock_list_imported_profiles' =>
      l10n.chatToolDesc_ghost_lock_list_imported_profiles,
    'ghost_lock_list_builtin_releases' =>
      l10n.chatToolDesc_ghost_lock_list_builtin_releases,
    'ghost_lock_read_imported_profile' =>
      l10n.chatToolDesc_ghost_lock_read_imported_profile,
    'ghost_lock_get_probe_progress' =>
      l10n.chatToolDesc_ghost_lock_get_probe_progress,
    'ghost_lock_list_extracted_images' =>
      l10n.chatToolDesc_ghost_lock_list_extracted_images,
    'ghost_lock_get_profile_config' =>
      l10n.chatToolDesc_ghost_lock_get_profile_config,
    'ghost_lock_get_active_source' =>
      l10n.chatToolDesc_ghost_lock_get_active_source,
    'ghost_lock_probe_profile' => l10n.chatToolDesc_ghost_lock_probe_profile,
    'ghost_lock_save_profile' => l10n.chatToolDesc_ghost_lock_save_profile,
    'ghost_lock_import_profile_text' =>
      l10n.chatToolDesc_ghost_lock_import_profile_text,
    'ghost_lock_rename_imported_profile' =>
      l10n.chatToolDesc_ghost_lock_rename_imported_profile,
    'ghost_lock_remove_imported_profile' =>
      l10n.chatToolDesc_ghost_lock_remove_imported_profile,
    'ghost_lock_export_imported_profile' =>
      l10n.chatToolDesc_ghost_lock_export_imported_profile,
    'ghost_lock_convert_imported_profile' =>
      l10n.chatToolDesc_ghost_lock_convert_imported_profile,
    'ghost_lock_export_local_file' =>
      l10n.chatToolDesc_ghost_lock_export_local_file,
    'ghost_lock_update_general_fields' =>
      l10n.chatToolDesc_ghost_lock_update_general_fields,
    'ghost_lock_update_advanced_fields' =>
      l10n.chatToolDesc_ghost_lock_update_advanced_fields,
    'ghost_lock_update_route' => l10n.chatToolDesc_ghost_lock_update_route,
    'ghost_lock_update_fallback' =>
      l10n.chatToolDesc_ghost_lock_update_fallback,
    'ghost_lock_reset_profile' => l10n.chatToolDesc_ghost_lock_reset_profile,
    'ghost_lock_select_source' => l10n.chatToolDesc_ghost_lock_select_source,
    'ghost_lock_render_profile' => l10n.chatToolDesc_ghost_lock_render_profile,
    'ghost_lock_export_profile' => l10n.chatToolDesc_ghost_lock_export_profile,
    'ghost_lock_save_modified_profile' =>
      l10n.chatToolDesc_ghost_lock_save_modified_profile,
    'ghost_lock_overwrite_profile' =>
      l10n.chatToolDesc_ghost_lock_overwrite_profile,
    'ghost_lock_begin_edit_session' =>
      l10n.chatToolDesc_ghost_lock_begin_edit_session,
    'ghost_lock_reload_edit_session' =>
      l10n.chatToolDesc_ghost_lock_reload_edit_session,
    'ghost_lock_get_edit_session' =>
      l10n.chatToolDesc_ghost_lock_get_edit_session,
    'ghost_lock_commit_edit_session' =>
      l10n.chatToolDesc_ghost_lock_commit_edit_session,
    'ghost_lock_save_edit_session_in_place' =>
      l10n.chatToolDesc_ghost_lock_save_edit_session_in_place,
    'ghost_lock_save_edit_session_as_new' =>
      l10n.chatToolDesc_ghost_lock_save_edit_session_as_new,
    'ghost_lock_export_edit_session' =>
      l10n.chatToolDesc_ghost_lock_export_edit_session,
    'ghost_lock_end_edit_session' =>
      l10n.chatToolDesc_ghost_lock_end_edit_session,
    'dirty_frag_is_armed' => l10n.chatToolDesc_dirty_frag_is_armed,
    'dirty_frag_get_run_defaults' =>
      l10n.chatToolDesc_dirty_frag_get_run_defaults,
    'dirty_frag_get_expert_mode' => l10n.chatToolDesc_dirty_frag_get_expert_mode,
    'dirty_frag_get_boot_autostart' =>
      l10n.chatToolDesc_dirty_frag_get_boot_autostart,
    'dirty_frag_get_vr_progress' =>
      l10n.chatToolDesc_dirty_frag_get_vr_progress,
    'dirty_frag_save_run_defaults' =>
      l10n.chatToolDesc_dirty_frag_save_run_defaults,
    'dirty_frag_set_expert_mode' =>
      l10n.chatToolDesc_dirty_frag_set_expert_mode,
    'dirty_frag_set_boot_autostart' =>
      l10n.chatToolDesc_dirty_frag_set_boot_autostart,
    'dirty_frag_start' => l10n.chatToolDesc_dirty_frag_start,
    'dirty_frag_status' => l10n.chatToolDesc_dirty_frag_status,
    'dirty_frag_cancel' => l10n.chatToolDesc_dirty_frag_cancel,
    'dirty_frag_derive_vr_offset' =>
      l10n.chatToolDesc_dirty_frag_derive_vr_offset,
    'kernel_profile_list_imported' =>
      l10n.chatToolDesc_kernel_profile_list_imported,
    'kernel_profile_list_builtin' =>
      l10n.chatToolDesc_kernel_profile_list_builtin,
    'kernel_profile_read_content' =>
      l10n.chatToolDesc_kernel_profile_read_content,
    'kernel_profile_read_editor' =>
      l10n.chatToolDesc_kernel_profile_read_editor,
    'kernel_profile_get_active_selection' =>
      l10n.chatToolDesc_kernel_profile_get_active_selection,
    'kernel_profile_import_start' =>
      l10n.chatToolDesc_kernel_profile_import_start,
    'kernel_profile_import_status' =>
      l10n.chatToolDesc_kernel_profile_import_status,
    'kernel_profile_import_cancel' =>
      l10n.chatToolDesc_kernel_profile_import_cancel,
    'kernel_profile_remove' => l10n.chatToolDesc_kernel_profile_remove,
    'kernel_profile_save_editor' =>
      l10n.chatToolDesc_kernel_profile_save_editor,
    'kernel_profile_save_editor_as' =>
      l10n.chatToolDesc_kernel_profile_save_editor_as,
    'kernel_profile_render_editor' =>
      l10n.chatToolDesc_kernel_profile_render_editor,
    'kernel_profile_select_user_profile' =>
      l10n.chatToolDesc_kernel_profile_select_user_profile,
    'kernel_profile_select_builtin_release' =>
      l10n.chatToolDesc_kernel_profile_select_builtin_release,
    'ota_list_catalog' => l10n.chatToolDesc_ota_list_catalog,
    'run_log_list_runs' => l10n.chatToolDesc_run_log_list_runs,
    'run_log_read_body' => l10n.chatToolDesc_run_log_read_body,
    'run_log_export_all' => l10n.chatToolDesc_run_log_export_all,
    'run_log_diagnose' => l10n.chatToolDesc_run_log_diagnose,
    'run_log_delete' => l10n.chatToolDesc_run_log_delete,
    'run_log_clear_all' => l10n.chatToolDesc_run_log_clear_all,
    'local_file_inspect' => l10n.chatToolDesc_local_file_inspect,
    _ => '',
  };
}
