module polkitagent.c.functions;

import std.stdio;
import polkitagent.c.types;
version (Windows)
	static immutable LIBRARY_POLKITAGENT = ["agent-1-0.dll;agent-1-1.0.dll;agent-1.dll"];
else version (OSX)
	static immutable LIBRARY_POLKITAGENT = ["agent-1.0.dylib"];
else
	static immutable LIBRARY_POLKITAGENT = ["libpolkit-agent-1.so.0"];

__gshared extern(C)
{

	// polkitagent.Listener

	GType polkit_agent_listener_get_type();
	void polkit_agent_listener_unregister(void* registrationHandle);
	void polkit_agent_listener_initiate_authentication(PolkitAgentListener* listener, const(char)* actionId, const(char)* message, const(char)* iconName, PolkitDetails* details, const(char)* cookie, GList* identities, GCancellable* cancellable, GAsyncReadyCallback callback, void* userData);
	int polkit_agent_listener_initiate_authentication_finish(PolkitAgentListener* listener, GAsyncResult* res, GError** err);
	void* polkit_agent_listener_register(PolkitAgentListener* listener, PolkitAgentRegisterFlags flags, PolkitSubject* subject, const(char)* objectPath, GCancellable* cancellable, GError** err);
	void* polkit_agent_listener_register_with_options(PolkitAgentListener* listener, PolkitAgentRegisterFlags flags, PolkitSubject* subject, const(char)* objectPath, GVariant* options, GCancellable* cancellable, GError** err);

	// polkitagent.Session

	GType polkit_agent_session_get_type();
	PolkitAgentSession* polkit_agent_session_new(PolkitIdentity* identity, const(char)* cookie);
	void polkit_agent_session_cancel(PolkitAgentSession* session);
	void polkit_agent_session_initiate(PolkitAgentSession* session);
	void polkit_agent_session_response(PolkitAgentSession* session, const(char)* response);

	// polkitagent.TextListener

	GType polkit_agent_text_listener_get_type();
	PolkitAgentListener* polkit_agent_text_listener_new(GCancellable* cancellable, GError** err);
}