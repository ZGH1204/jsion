package jsion.tool.respacker
{
	import flash.events.EventDispatcher;
	
	import jsion.IDispose;
	
	import org.aswing.tree.DefaultMutableTreeNode;
	import org.aswing.tree.DefaultTreeModel;
	
	public class PackerModel extends EventDispatcher implements IDispose
	{
		protected var m_treeModel:DefaultTreeModel;
		
		protected var m_treeRoot:DefaultMutableTreeNode;
		
		public function PackerModel()
		{
			m_treeRoot = new DefaultMutableTreeNode("动作列表");
			m_treeModel = new DefaultTreeModel(m_treeRoot);
		}
		
		public function get treeModel():DefaultTreeModel
		{
			return m_treeModel;
		}
		
		public function get treeRoot():DefaultMutableTreeNode
		{
			return m_treeRoot;
		}

		public function dispose():void
		{
		}
	}
}