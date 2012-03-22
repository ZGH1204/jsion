package jsion.tool.respacker.areas
{
	import jsion.IDispose;
	import jsion.tool.respacker.datas.DirInfo;
	import jsion.tool.respacker.events.PackerEvent;
	
	import org.aswing.JPanel;
	import org.aswing.JTree;
	import org.aswing.LayoutManager;
	import org.aswing.border.TitledBorder;
	import org.aswing.event.TreeSelectionEvent;
	import org.aswing.tree.DefaultMutableTreeNode;
	import org.aswing.tree.DefaultTreeModel;
	import org.aswing.tree.TreePath;
	
	public class LeftPane extends JPanel implements IDispose
	{
		private var m_tree:JTree;
		
		public function LeftPane()
		{
			super();
			
			setPreferredWidth(200);
			
			setBorder(new TitledBorder(null, "动作列表", TitledBorder.TOP, TitledBorder.LEFT, 10));
			
			m_tree = new JTree();
			
			append(m_tree);
			
			m_tree.addEventListener(TreeSelectionEvent.TREE_SELECTION_CHANGED, __treeSelectionHandler);
		}
		
		private function __treeSelectionHandler(e:TreeSelectionEvent):void
		{
			var path:TreePath = e.getPath();
			
			dispatchEvent(new PackerEvent(PackerEvent.SELECTED, path));
		}
		
		public function setTreeModel(model:DefaultTreeModel):void
		{
			m_tree.setModel(model);
		}
		
		public function setSelected(root:DefaultMutableTreeNode, dir:DirInfo):void
		{
			m_tree.collapsePath(new TreePath([root]));
			m_tree.expandPath(new TreePath([root]));
			
			m_tree.collapsePath(new TreePath([root, dir.action.node]));
			m_tree.expandPath(new TreePath([root, dir.action.node]));
			
			m_tree.setSelectionPath(new TreePath([dir.node]));
		}
		
		public function updateTree():void
		{
			m_tree.updateUI();
		}
		
		public function dispose():void
		{
		}
	}
}