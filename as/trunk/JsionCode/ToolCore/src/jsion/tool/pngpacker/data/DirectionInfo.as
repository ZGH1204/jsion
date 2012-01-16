package jsion.tool.pngpacker.data
{
	import org.aswing.tree.DefaultMutableTreeNode;

	public class DirectionInfo
	{
		public var name:String;
		
		public var dir:int;
		
		private var m_list:Array;
		
		public var node:DefaultMutableTreeNode;
		
		public function DirectionInfo(str:String)
		{
			name = str;
			m_list = [];
			node = new DefaultMutableTreeNode(str);
		}
	}
}