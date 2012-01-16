package jsion.tool.pngpacker.data
{
	import jsion.HashMap;
	
	import org.aswing.tree.DefaultMutableTreeNode;

	public class ActionInfo
	{
		public var name:String;
		
		public var actionID:int;
		
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
			node.append(dir.node);
			m_dirs.put(dir.dir, dir);
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