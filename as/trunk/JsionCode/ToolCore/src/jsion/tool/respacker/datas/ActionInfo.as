package jsion.tool.respacker.datas
{
	import jsion.HashMap;
	import jsion.IDispose;
	
	import org.aswing.tree.DefaultMutableTreeNode;
	
	public class ActionInfo implements IDispose
	{
		public var id:int;
		public var name:String;
		public var node:DefaultMutableTreeNode;
		
		public var root:DefaultMutableTreeNode;
		
		private var m_dirs:HashMap;
		
		
		public function ActionInfo(id:int, name:String)
		{
			this.id = id;
			this.name = name;
			m_dirs = new HashMap();
			node = new DefaultMutableTreeNode(name);
		}
		
		public function addDirInfo(dir:DirInfo):void
		{
			if(m_dirs.containsKey(dir.id) == false)
			{
				m_dirs.put(dir.id, dir);
				dir.action = this;
				node.append(dir.node);
			}
		}
		
		public function getDirInfo(dirID:int):DirInfo
		{
			return m_dirs.get(dirID);
		}
		
		public function dispose():void
		{
		}
	}
}