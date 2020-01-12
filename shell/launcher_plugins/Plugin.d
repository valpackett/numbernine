module launcher_plugins.Plugin;
import gtk.TreeModelIF;
import gtk.TreePath;
import gtk.TreeView;
import gtk.TreeViewColumn;

interface Plugin {
	TreeModelIF getResultModel();
	pure bool matchesSearch(string);
	void updateResults(string);
	void activateRow(TreePath, TreeViewColumn, TreeView);
}
