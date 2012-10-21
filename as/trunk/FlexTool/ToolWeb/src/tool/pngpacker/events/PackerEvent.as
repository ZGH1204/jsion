package tool.pngpacker.events
{
	import flash.events.Event;
	
	import jsion.IDispose;
	
	public class PackerEvent extends Event implements IDispose
	{
		public static const TEXT_CHANGED:String = "textChanged";
		
		public static const CREATE_ACTION:String = "createAction";
		
		public static const ADD_ACTION_DATA:String = "addActionData";
		
		public static const REMOVE_ACTION_DATA:String = "removeActionData";
		
		public static const ADD_DIR_DATA:String = "addDirData";
		
		public static const REMOVE_DIR_DATA:String = "removeDirData";
		
		public static const SELECTE_CHANGED:String = "selecteChanged";
		
		public static const ADD_BITMAP_DATA:String = "addBitmapData";
		
		public static const REMOVE_BITMAP_DATA:String = "removeBitmapData";
		
		public static const INDEX_CHANGED:String = "indexChanged";
		
		public var data:*;
		
		public function PackerEvent(type:String, data:* = null)
		{
			super(type);
			
			this.data = data;
		}
		
		public function dispose():void
		{
			// TODO Auto Generated method stub
			data = null;
		}
		
	}
}