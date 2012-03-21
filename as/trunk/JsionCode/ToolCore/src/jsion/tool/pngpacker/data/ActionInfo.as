package jsion.tool.pngpacker.data
{
	import jsion.HashMap;
	
	import org.aswing.tree.DefaultMutableTreeNode;

	public class ActionInfo
	{
		public var name:String;
		
		public var actionID:int;
		
		public var root:DefaultMutableTreeNode;
		
		private var m_dirs:HashMap;
		
		public var node:DefaultMutableTreeNode;
		
		public function ActionInfo(str:String)
		{
			name = str;
			m_dirs = new HashMap();
			node = new DefaultMutableTreeNode(str);
		}
		
		public function addDirInfo(dir:DirectionInfo):void
		{
			if(dir == null) return;
			
			dir.action = this;
			node.append(dir.node);
			m_dirs.put(dir.dir, dir);
		}
		
		internal function removeDirInfo(dir:DirectionInfo):void
		{
			if(dir)
			{
				m_dirs.remove(dir.dir);
				if(dir.node) node.remove(dir.node);
			}
		}
		
		public function removeFromRoot():void
		{
			if(root)
			{
				var list:Array;
				
				list = m_dirs.getValues();
				for each(var dir:DirectionInfo in list)
				{
					dir.removeFromAction();
				}
				
				root.remove(node);
				
				root = null;
			}
		}
		
		public function get hasDir():Boolean
		{
			return m_dirs.size != 0;
		}
		
		public function getDirInfo(dir:int):DirectionInfo
		{
			return m_dirs.get(dir);
		}
		
		public function getAllDirInfos():Array
		{
			return m_dirs.getValues();
		}
	}
}