package jsion
{
	import com.datatypes.HashMap;
	import com.managers.CacheManager;
	import com.managers.InstanceManager;
	import com.utils.DisposeHelper;
	import com.utils.StringHelper;
	
	import flash.display.BitmapData;

	public class BitmapDataMgr
	{
		private var _list:HashMap;
		
		public function BitmapDataMgr()
		{
			_list = new HashMap();
		}
		
		public function hasBitmapData(key:String):Boolean
		{
			key = StringHelper.getPathKey(key);
			return _list.containsKey(key);
		}
		
		public function getBitmapData(key:String):BitmapData
		{
			key = StringHelper.getPathKey(key);
			
			return _list.get(key) as BitmapData;
		}
		
		public function putBitmapData(key:String, bmd:BitmapData):void
		{
			if(bmd == null) return;
			key = StringHelper.getPathKey(key);
			if(_list.containsKey(key)) return;
			_list.put(key, bmd);
		}
		
		public function remove(key:String):BitmapData
		{
			return _list.remove(key) as BitmapData;
		}
		
		public function clear():void
		{
			var keys:Array = _list.getKeys();
			for each(var key:* in keys)
			{
				var obj:* = _list.remove(key);
				DisposeHelper.dispose(obj);
			}
			CacheManager.getInstance().clearMemoryCache();
		}
		
		public static function get Instance():BitmapDataMgr
		{
			return InstanceManager.createSingletonInstance(BitmapDataMgr) as BitmapDataMgr;
		}
	}
}