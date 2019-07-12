module polkit.c.functions;

import std.stdio;
import polkit.c.types;
version (Windows)
	static immutable LIBRARY_POLKIT = ["gobject-1-0.dll;gobject-1-1.0.dll;gobject-1.dll"];
else version (OSX)
	static immutable LIBRARY_POLKIT = ["gobject-1.0.dylib"];
else
	static immutable LIBRARY_POLKIT = ["libpolkit-gobject-1.so.0"];

__gshared extern(C)
{

	// polkit.ActionDescription

	GType polkit_action_description_get_type();
	const(char)* polkit_action_description_get_action_id(PolkitActionDescription* actionDescription);
	const(char)* polkit_action_description_get_annotation(PolkitActionDescription* actionDescription, const(char)* key);
	char** polkit_action_description_get_annotation_keys(PolkitActionDescription* actionDescription);
	const(char)* polkit_action_description_get_description(PolkitActionDescription* actionDescription);
	const(char)* polkit_action_description_get_icon_name(PolkitActionDescription* actionDescription);
	PolkitImplicitAuthorization polkit_action_description_get_implicit_active(PolkitActionDescription* actionDescription);
	PolkitImplicitAuthorization polkit_action_description_get_implicit_any(PolkitActionDescription* actionDescription);
	PolkitImplicitAuthorization polkit_action_description_get_implicit_inactive(PolkitActionDescription* actionDescription);
	const(char)* polkit_action_description_get_message(PolkitActionDescription* actionDescription);
	const(char)* polkit_action_description_get_vendor_name(PolkitActionDescription* actionDescription);
	const(char)* polkit_action_description_get_vendor_url(PolkitActionDescription* actionDescription);

	// polkit.Authority

	GType polkit_authority_get_type();
	PolkitAuthority* polkit_authority_get();
	void polkit_authority_get_async(GCancellable* cancellable, GAsyncReadyCallback callback, void* userData);
	PolkitAuthority* polkit_authority_get_finish(GAsyncResult* res, GError** err);
	PolkitAuthority* polkit_authority_get_sync(GCancellable* cancellable, GError** err);
	void polkit_authority_authentication_agent_response(PolkitAuthority* authority, const(char)* cookie, PolkitIdentity* identity, GCancellable* cancellable, GAsyncReadyCallback callback, void* userData);
	int polkit_authority_authentication_agent_response_finish(PolkitAuthority* authority, GAsyncResult* res, GError** err);
	int polkit_authority_authentication_agent_response_sync(PolkitAuthority* authority, const(char)* cookie, PolkitIdentity* identity, GCancellable* cancellable, GError** err);
	void polkit_authority_check_authorization(PolkitAuthority* authority, PolkitSubject* subject, const(char)* actionId, PolkitDetails* details, PolkitCheckAuthorizationFlags flags, GCancellable* cancellable, GAsyncReadyCallback callback, void* userData);
	PolkitAuthorizationResult* polkit_authority_check_authorization_finish(PolkitAuthority* authority, GAsyncResult* res, GError** err);
	PolkitAuthorizationResult* polkit_authority_check_authorization_sync(PolkitAuthority* authority, PolkitSubject* subject, const(char)* actionId, PolkitDetails* details, PolkitCheckAuthorizationFlags flags, GCancellable* cancellable, GError** err);
	void polkit_authority_enumerate_actions(PolkitAuthority* authority, GCancellable* cancellable, GAsyncReadyCallback callback, void* userData);
	GList* polkit_authority_enumerate_actions_finish(PolkitAuthority* authority, GAsyncResult* res, GError** err);
	GList* polkit_authority_enumerate_actions_sync(PolkitAuthority* authority, GCancellable* cancellable, GError** err);
	void polkit_authority_enumerate_temporary_authorizations(PolkitAuthority* authority, PolkitSubject* subject, GCancellable* cancellable, GAsyncReadyCallback callback, void* userData);
	GList* polkit_authority_enumerate_temporary_authorizations_finish(PolkitAuthority* authority, GAsyncResult* res, GError** err);
	GList* polkit_authority_enumerate_temporary_authorizations_sync(PolkitAuthority* authority, PolkitSubject* subject, GCancellable* cancellable, GError** err);
	PolkitAuthorityFeatures polkit_authority_get_backend_features(PolkitAuthority* authority);
	const(char)* polkit_authority_get_backend_name(PolkitAuthority* authority);
	const(char)* polkit_authority_get_backend_version(PolkitAuthority* authority);
	char* polkit_authority_get_owner(PolkitAuthority* authority);
	void polkit_authority_register_authentication_agent(PolkitAuthority* authority, PolkitSubject* subject, const(char)* locale, const(char)* objectPath, GCancellable* cancellable, GAsyncReadyCallback callback, void* userData);
	int polkit_authority_register_authentication_agent_finish(PolkitAuthority* authority, GAsyncResult* res, GError** err);
	int polkit_authority_register_authentication_agent_sync(PolkitAuthority* authority, PolkitSubject* subject, const(char)* locale, const(char)* objectPath, GCancellable* cancellable, GError** err);
	void polkit_authority_register_authentication_agent_with_options(PolkitAuthority* authority, PolkitSubject* subject, const(char)* locale, const(char)* objectPath, GVariant* options, GCancellable* cancellable, GAsyncReadyCallback callback, void* userData);
	int polkit_authority_register_authentication_agent_with_options_finish(PolkitAuthority* authority, GAsyncResult* res, GError** err);
	int polkit_authority_register_authentication_agent_with_options_sync(PolkitAuthority* authority, PolkitSubject* subject, const(char)* locale, const(char)* objectPath, GVariant* options, GCancellable* cancellable, GError** err);
	void polkit_authority_revoke_temporary_authorization_by_id(PolkitAuthority* authority, const(char)* id, GCancellable* cancellable, GAsyncReadyCallback callback, void* userData);
	int polkit_authority_revoke_temporary_authorization_by_id_finish(PolkitAuthority* authority, GAsyncResult* res, GError** err);
	int polkit_authority_revoke_temporary_authorization_by_id_sync(PolkitAuthority* authority, const(char)* id, GCancellable* cancellable, GError** err);
	void polkit_authority_revoke_temporary_authorizations(PolkitAuthority* authority, PolkitSubject* subject, GCancellable* cancellable, GAsyncReadyCallback callback, void* userData);
	int polkit_authority_revoke_temporary_authorizations_finish(PolkitAuthority* authority, GAsyncResult* res, GError** err);
	int polkit_authority_revoke_temporary_authorizations_sync(PolkitAuthority* authority, PolkitSubject* subject, GCancellable* cancellable, GError** err);
	void polkit_authority_unregister_authentication_agent(PolkitAuthority* authority, PolkitSubject* subject, const(char)* objectPath, GCancellable* cancellable, GAsyncReadyCallback callback, void* userData);
	int polkit_authority_unregister_authentication_agent_finish(PolkitAuthority* authority, GAsyncResult* res, GError** err);
	int polkit_authority_unregister_authentication_agent_sync(PolkitAuthority* authority, PolkitSubject* subject, const(char)* objectPath, GCancellable* cancellable, GError** err);

	// polkit.AuthorizationResult

	GType polkit_authorization_result_get_type();
	PolkitAuthorizationResult* polkit_authorization_result_new(int isAuthorized, int isChallenge, PolkitDetails* details);
	PolkitDetails* polkit_authorization_result_get_details(PolkitAuthorizationResult* result);
	int polkit_authorization_result_get_dismissed(PolkitAuthorizationResult* result);
	int polkit_authorization_result_get_is_authorized(PolkitAuthorizationResult* result);
	int polkit_authorization_result_get_is_challenge(PolkitAuthorizationResult* result);
	int polkit_authorization_result_get_retains_authorization(PolkitAuthorizationResult* result);
	const(char)* polkit_authorization_result_get_temporary_authorization_id(PolkitAuthorizationResult* result);

	// polkit.Details

	GType polkit_details_get_type();
	PolkitDetails* polkit_details_new();
	char** polkit_details_get_keys(PolkitDetails* details);
	void polkit_details_insert(PolkitDetails* details, const(char)* key, const(char)* value);
	const(char)* polkit_details_lookup(PolkitDetails* details, const(char)* key);

	// polkit.Identity

	GType polkit_identity_get_type();
	PolkitIdentity* polkit_identity_from_string(const(char)* str, GError** err);
	int polkit_identity_equal(PolkitIdentity* a, PolkitIdentity* b);
	uint polkit_identity_hash(PolkitIdentity* identity);
	char* polkit_identity_to_string(PolkitIdentity* identity);

	// polkit.Permission

	GType polkit_permission_get_type();
	GPermission* polkit_permission_new_finish(GAsyncResult* res, GError** err);
	GPermission* polkit_permission_new_sync(const(char)* actionId, PolkitSubject* subject, GCancellable* cancellable, GError** err);
	void polkit_permission_new(const(char)* actionId, PolkitSubject* subject, GCancellable* cancellable, GAsyncReadyCallback callback, void* userData);
	const(char)* polkit_permission_get_action_id(PolkitPermission* permission);
	PolkitSubject* polkit_permission_get_subject(PolkitPermission* permission);

	// polkit.Subject

	GType polkit_subject_get_type();
	PolkitSubject* polkit_subject_from_string(const(char)* str, GError** err);
	int polkit_subject_equal(PolkitSubject* a, PolkitSubject* b);
	void polkit_subject_exists(PolkitSubject* subject, GCancellable* cancellable, GAsyncReadyCallback callback, void* userData);
	int polkit_subject_exists_finish(PolkitSubject* subject, GAsyncResult* res, GError** err);
	int polkit_subject_exists_sync(PolkitSubject* subject, GCancellable* cancellable, GError** err);
	uint polkit_subject_hash(PolkitSubject* subject);
	char* polkit_subject_to_string(PolkitSubject* subject);

	// polkit.SystemBusName

	GType polkit_system_bus_name_get_type();
	PolkitSubject* polkit_system_bus_name_new(const(char)* name);
	const(char)* polkit_system_bus_name_get_name(PolkitSystemBusName* systemBusName);
	PolkitSubject* polkit_system_bus_name_get_process_sync(PolkitSystemBusName* systemBusName, GCancellable* cancellable, GError** err);
	PolkitUnixUser* polkit_system_bus_name_get_user_sync(PolkitSystemBusName* systemBusName, GCancellable* cancellable, GError** err);
	void polkit_system_bus_name_set_name(PolkitSystemBusName* systemBusName, const(char)* name);

	// polkit.TemporaryAuthorization

	GType polkit_temporary_authorization_get_type();
	const(char)* polkit_temporary_authorization_get_action_id(PolkitTemporaryAuthorization* authorization);
	const(char)* polkit_temporary_authorization_get_id(PolkitTemporaryAuthorization* authorization);
	PolkitSubject* polkit_temporary_authorization_get_subject(PolkitTemporaryAuthorization* authorization);
	ulong polkit_temporary_authorization_get_time_expires(PolkitTemporaryAuthorization* authorization);
	ulong polkit_temporary_authorization_get_time_obtained(PolkitTemporaryAuthorization* authorization);

	// polkit.UnixGroup

	GType polkit_unix_group_get_type();
	PolkitIdentity* polkit_unix_group_new(int gid);
	PolkitIdentity* polkit_unix_group_new_for_name(const(char)* name, GError** err);
	int polkit_unix_group_get_gid(PolkitUnixGroup* group);
	void polkit_unix_group_set_gid(PolkitUnixGroup* group, int gid);

	// polkit.UnixNetgroup

	GType polkit_unix_netgroup_get_type();
	PolkitIdentity* polkit_unix_netgroup_new(const(char)* name);
	const(char)* polkit_unix_netgroup_get_name(PolkitUnixNetgroup* group);
	void polkit_unix_netgroup_set_name(PolkitUnixNetgroup* group, const(char)* name);

	// polkit.UnixProcess

	GType polkit_unix_process_get_type();
	PolkitSubject* polkit_unix_process_new(int pid);
	PolkitSubject* polkit_unix_process_new_for_owner(int pid, ulong startTime, int uid);
	PolkitSubject* polkit_unix_process_new_full(int pid, ulong startTime);
	int polkit_unix_process_get_owner(PolkitUnixProcess* process, GError** err);
	int polkit_unix_process_get_pid(PolkitUnixProcess* process);
	ulong polkit_unix_process_get_start_time(PolkitUnixProcess* process);
	int polkit_unix_process_get_uid(PolkitUnixProcess* process);
	void polkit_unix_process_set_pid(PolkitUnixProcess* process, int pid);
	void polkit_unix_process_set_start_time(PolkitUnixProcess* process, ulong startTime);
	void polkit_unix_process_set_uid(PolkitUnixProcess* process, int uid);

	// polkit.UnixSession

	GType polkit_unix_session_get_type();
	PolkitSubject* polkit_unix_session_new(const(char)* sessionId);
	void polkit_unix_session_new_for_process(int pid, GCancellable* cancellable, GAsyncReadyCallback callback, void* userData);
	PolkitSubject* polkit_unix_session_new_for_process_finish(GAsyncResult* res, GError** err);
	PolkitSubject* polkit_unix_session_new_for_process_sync(int pid, GCancellable* cancellable, GError** err);
	const(char)* polkit_unix_session_get_session_id(PolkitUnixSession* session);
	void polkit_unix_session_set_session_id(PolkitUnixSession* session, const(char)* sessionId);

	// polkit.UnixUser

	GType polkit_unix_user_get_type();
	PolkitIdentity* polkit_unix_user_new(int uid);
	PolkitIdentity* polkit_unix_user_new_for_name(const(char)* name, GError** err);
	const(char)* polkit_unix_user_get_name(PolkitUnixUser* user);
	int polkit_unix_user_get_uid(PolkitUnixUser* user);
	void polkit_unix_user_set_uid(PolkitUnixUser* user, int uid);
}