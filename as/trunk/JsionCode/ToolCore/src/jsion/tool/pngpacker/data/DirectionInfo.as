package jsion.tool.pngpacker.data
{
	import flash.display.BitmapData;
	
	import jsion.utils.ArrayUtil;
	
	import org.aswing.tree.DefaultMutableTreeNode;

	public class DirectionInfo
	{
		public var name:String;
		
		public var dir:int;
		
		public var action:ActionInfo;
		
		private var m_list:Array;
		
		public var node:DefaultMutableTreeNode;
		
		public function DirectionInfo(str:String)
		{
			name = str;
			m_list = [];
			node = new DefaultMutableTreeNode(str);
		}
		
		public function get hasPNG():Boolean
		{
			return m_list.length != 0;
		}
		
		public function getList():Array
		{
			return m_list;
		}
		
		public function addBitmapData(bmd:BitmapData):void
		{
			m_list.push(bmd);
		}
		
		public function insertBitmapData(bmd:BitmapData, index:int):void
		{
			ArrayUtil.insert(m_list, bmd, index);
		}
		
		public function removeBitmapData(bmd:BitmapData):void
		{
			ArrayUtil.remove(m_list, bmd);
		}
		
		public function removeFromAction():void
		{
			if(action)
			{
				action.removeDirInfo(this);
				
				action = null;
				node = null;
				m_list = null;
			}
		}
	}
}