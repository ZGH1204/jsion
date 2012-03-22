package jsion.tool.respacker.datas
{
	import jsion.IDispose;
	
	import org.aswing.tree.DefaultMutableTreeNode;
	
	public class DirInfo implements IDispose
	{
		public var id:int;
		
		public var name:String;
		
		public var node:DefaultMutableTreeNode;
		
		public var action:ActionInfo;
		
		private var m_bitmapDatas:Array;
		
		public function DirInfo(id:int, name:String)
		{
			this.id = id;
			this.name = name;
			
			node = new DefaultMutableTreeNode(name);
			
			m_bitmapDatas = [];
		}
		
		public function dispose():void
		{
		}
	}
}