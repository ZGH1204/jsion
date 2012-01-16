package jsion.tool.pngpacker.data
{
	import jsion.HashMap;
	
	import org.aswing.tree.DefaultMutableTreeNode;
	import org.aswing.tree.DefaultTreeModel;

	public class PackerModel
	{
		public var name:String;
		
		private var m_actions:HashMap;
		
		public var model:DefaultTreeModel;
		public var root:DefaultMutableTreeNode;
		
		public function PackerModel(name:String = "资源")
		{
			this.name = name;
			m_actions = new HashMap();
			root = new DefaultMutableTreeNode(this.name);
			model = new DefaultTreeModel(root);
		}
		
		public function addAction(actionName:String, actionID:int, dirName:String, dir:int):DirectionInfo
		{
			var action:ActionInfo = m_actions.get(actionID) as ActionInfo;
			
			var dirInfo:DirectionInfo;
			
			if(action == null)
			{
				action = new ActionInfo(actionName);
				action.actionID = actionID;
				m_actions.put(actionID, action);
				
				root.append(action.node);
			}
			else
			{
				dirInfo = action.getDirInfo(dir);
				if(dirInfo != null) return dirInfo;
			}
			
			dirInfo = new DirectionInfo(dirName)
			dirInfo.dir = dir;
			action.addDirInfo(dirInfo);
			
			return dirInfo;
		}
		
		public function getAction(actionID:int):ActionInfo
		{
			return m_actions.get(actionID) as ActionInfo;
		}
		
		public function getPath(node:DefaultMutableTreeNode):Array
		{
			var action:ActionInfo;
			
			var dirInfo:DirectionInfo;
			
			
			var isFinded:Boolean = false;
			
			var aList:Array = getAllActions();
			
			for each(var aItem:ActionInfo in aList)
			{
				var dList:Array = aItem.getAllDirInfos();
				
				for each(var dItem:DirectionInfo in dList)
				{
					if(dItem.node == node)
					{
						dirInfo = dItem;
						isFinded = true;
						break;
					}
				}
				
				if(isFinded)
				{
					action = aItem;
					break;
				}
			}
			
			if(isFinded)
			{
				return [action, dirInfo];
			}
			
			return null;
		}
		
		public function getAllActions():Array
		{
			return m_actions.getValues();;
		}
	}
}