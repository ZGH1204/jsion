package jsion.tool.pngpacker.panes
{
	import jsion.tool.pngpacker.PNGPackerFrame;
	import jsion.tool.pngpacker.data.ActionInfo;
	import jsion.tool.pngpacker.data.DirectionInfo;
	import jsion.tool.pngpacker.data.PackerModel;
	
	import org.aswing.JScrollPane;
	import org.aswing.JTree;
	import org.aswing.border.TitledBorder;
	import org.aswing.event.TreeSelectionEvent;
	import org.aswing.tree.DefaultMutableTreeNode;
	import org.aswing.tree.TreePath;
	
	public class LeftPane extends JScrollPane
	{
		private var m_tree:JTree;
		
		private var m_packerData:PackerModel;
		
		private var m_frame:PNGPackerFrame;
		
		private var m_currentDirInfo:DirectionInfo;
		
		private var m_path:TreePath;
		
		public function LeftPane(frame:PNGPackerFrame)
		{
			m_frame = frame;
			m_packerData = frame.packerData;
			
			super();
			
			setPreferredWidth(200);
			
			setBorder(new TitledBorder(null, "动作列表", TitledBorder.TOP, TitledBorder.LEFT, 10));
			
			m_tree = new JTree();
			
			m_tree.setModel(m_packerData.model);
			
			append(m_tree);
			
			m_tree.addEventListener(TreeSelectionEvent.TREE_SELECTION_CHANGED, __treeSelectionHandler);
		}
		
		private function __treeSelectionHandler(e:TreeSelectionEvent):void
		{
			var path:TreePath = e.getPath();
			
			if(path == null || path.getLastPathComponent() == null) return;
			
			var treeNode:DefaultMutableTreeNode = path.getLastPathComponent();
			
			if(treeNode == m_packerData.root || treeNode.isLeaf() == false)
			{
				if(m_path) m_tree.setSelectionPath(m_path);
				
				return;
			}
			
			var dir:DirectionInfo = m_packerData.getPath(treeNode);
			
			if(dir) m_frame.setCurrent(dir, path);
		}
		
		public function get currentPath():TreePath
		{
			return m_path;
		}
		
		public function get currentDirInfo():DirectionInfo
		{
			return m_currentDirInfo;
		}
		
		public function setSelected(dirInfo:DirectionInfo):void
		{
			m_tree.collapsePath(new TreePath([m_packerData.root]));
			m_tree.expandPath(new TreePath([m_packerData.root]));
			
			m_tree.collapsePath(new TreePath([m_packerData.root, dirInfo.action.node]));
			m_tree.expandPath(new TreePath([m_packerData.root, dirInfo.action.node]));
			m_tree.setSelectionPath(new TreePath([dirInfo.node]));
			
			setCurrent(dirInfo.action, dirInfo, new TreePath([m_packerData.root, dirInfo.action.node, dirInfo.node]));
		}
		
		public function delSelected():void
		{
			if(m_currentDirInfo)
			{
				var action:ActionInfo = m_currentDirInfo.action;
				m_currentDirInfo.removeFromAction();
				
				if(action.hasDir == false)
				{
					action.removeFromRoot();
				}
				
				m_tree.updateUI();
				
				clearCurrent();
			}
		}
		
		public function setCurrent(actionInfo:ActionInfo, dirInfo:DirectionInfo, path:TreePath):void
		{
			m_path = path;
			
			m_currentDirInfo = dirInfo;
		}
		
		public function clearCurrent():void
		{
			m_path = null;
			
			m_currentDirInfo = null;
		}
		
		public function refreshTree():void
		{
			var list:Array = m_packerData.getAllActions();
			
			for each(var aInfo:ActionInfo in list)
			{
				if(m_tree.isExpanded(new TreePath([m_packerData.root, aInfo.node])))
				{
					m_tree.collapsePath(new TreePath([m_packerData.root, aInfo.node]));
					m_tree.expandPath(new TreePath([m_packerData.root, aInfo.node]));
				}
				else
				{
					m_tree.expandPath(new TreePath([m_packerData.root, aInfo.node]));
					m_tree.collapsePath(new TreePath([m_packerData.root, aInfo.node]));
				}
			}
		}
	}
}