package tool.pngpacker.datas
{
	import flash.display.BitmapData;
	
	import jsion.Global;
	import jsion.events.JsionEventDispatcher;
	import jsion.utils.ArrayUtil;
	import jsion.utils.DisposeUtil;
	
	import tool.pngpacker.events.PackerEvent;
	
	[Event(name="indexChanged", type="tool.pngpacker.events.PackerEvent")]
	[Event(name="addBitmapData", type="tool.pngpacker.events.PackerEvent")]
	[Event(name="removeBitmapData", type="tool.pngpacker.events.PackerEvent")]
	public class DirData extends JsionEventDispatcher
	{
		public var actionData:ActionData;
		
		protected var m_dir:int;
		
		protected var m_name:String;
		
		protected var m_bitmapDatas:Array;
		
		public function DirData(dir:int)
		{
			super();
			
			m_dir = dir;
			
			m_name = Global.DirNames[m_dir];
			
			m_bitmapDatas = [];
		}
		
		public function get dir():int
		{
			return m_dir;
		}
		
		public function get name():String
		{
			return m_name;
		}
		
		public function get bitmapDatas():Array
		{
			return m_bitmapDatas;
		}
		
		public function canPack():Boolean
		{
			return m_bitmapDatas.length != 0;
		}
		
		public function left(index:int):void
		{
			if(index <= 0) return;
			
			var bmd:BitmapData = ArrayUtil.removeAt(m_bitmapDatas, index);
			
			if(bmd == null) return;
			
			ArrayUtil.insert(m_bitmapDatas, bmd, index - 1);
			
			dispatchEvent(new PackerEvent(PackerEvent.INDEX_CHANGED));
		}
		
		public function right(index:int):void
		{
			var bmd:BitmapData = ArrayUtil.removeAt(m_bitmapDatas, index);
			
			if(bmd == null) return;
			
			ArrayUtil.insert(m_bitmapDatas, bmd, index + 1);
			
			dispatchEvent(new PackerEvent(PackerEvent.INDEX_CHANGED));
		}
		
		public function addBitmapDatas(list:Array):void
		{
			for each(var bmd:BitmapData in list)
			{
				addBitmapData(bmd.clone());
			}
		}

		public function addBitmapData(bitmapData:BitmapData):void
		{
			m_bitmapDatas.push(bitmapData);
			
			dispatchEvent(new PackerEvent(PackerEvent.ADD_BITMAP_DATA, bitmapData));
		}
		
		public function removeBitmapData(bitmapData:BitmapData):void
		{
			if(bitmapData == null) return;
			
			ArrayUtil.remove(m_bitmapDatas, bitmapData);
			
			dispatchEvent(new PackerEvent(PackerEvent.REMOVE_BITMAP_DATA, bitmapData));
		}
		
		public function removeBitmapDataAt(index:int):void
		{
			var bitmapData:BitmapData = ArrayUtil.removeAt(m_bitmapDatas, index);
			
			dispatchEvent(new PackerEvent(PackerEvent.REMOVE_BITMAP_DATA, bitmapData));
		}
		
		public function clearBitmapData():void
		{
			while(m_bitmapDatas && m_bitmapDatas.length > 0)
			{
				var bmd:BitmapData = m_bitmapDatas.pop();
				removeBitmapData(bmd);
				DisposeUtil.free(bmd);
			}
		}
		
		override public function dispose():void
		{
			// TODO Auto Generated method stub
			
			actionData = null;
			
			DisposeUtil.free(m_bitmapDatas);
			m_bitmapDatas = null;
			
			super.dispose();
		}
	}
}