package jsion.tool.respacker
{
	import flash.events.EventDispatcher;
	
	import jsion.HashMap;
	import jsion.IDispose;
	import jsion.tool.respacker.datas.ActionInfo;
	import jsion.tool.respacker.datas.DirInfo;
	
	import org.aswing.tree.DefaultMutableTreeNode;
	import org.aswing.tree.DefaultTreeModel;
	
	public class PackerModel extends EventDispatcher implements IDispose
	{
		protected var m_treeModel:DefaultTreeModel;
		
		protected var m_treeRoot:DefaultMutableTreeNode;
		
		private var m_actions:HashMap;
		
		public function PackerModel()
		{
			m_actions = new HashMap();
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
		
		public function addAction(actionID:int, actionName:String, dirID:int, dirName:String):DirInfo
		{
			var action:ActionInfo = m_actions.get(actionID) as ActionInfo;
			
			var dirInfo:DirInfo;
			
			if(action == null)
			{
				action = new ActionInfo(actionID, actionName);
				action.root = m_treeRoot;
				m_actions.put(actionID, action);
				
				m_treeRoot.append(action.node);
			}
			else
			{
				dirInfo = action.getDirInfo(dirID);
				
				if(dirInfo != null) return dirInfo;
			}
			
			dirInfo = new DirInfo(dirID, dirName);
			
			action.addDirInfo(dirInfo);
			
			return dirInfo;
		}

		public function dispose():void
		{
		}
	}
}