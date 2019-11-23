import gdk.Display;

extern (C):

bool wl_protos_get_for_gdk(GdkDisplay*);

struct zwlr_input_inhibit_manager_v1;
struct zwlr_input_inhibitor_v1;

zwlr_input_inhibitor_v1* zwlr_input_inhibit_manager_v1_get_inhibitor(zwlr_input_inhibit_manager_v1*);
void zwlr_input_inhibitor_v1_destroy(zwlr_input_inhibitor_v1*);

extern __gshared zwlr_input_inhibit_manager_v1* wl_protos_input_inhibit_manager;
