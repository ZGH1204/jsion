package jsion.rpg.engine
{
	import flash.display.BitmapData;
	
	import jsion.core.loaders.ImageLoader;
	import jsion.utils.DisposeUtil;

	public class EngineGlobal
	{
		public static var MapsList:HashMap = new HashMap();
		
		public static var GlobalPool:ResourcePool = new ResourcePool();
		
		private static var GraphicLoadings:HashMap = new HashMap();
		
		private static var LoadCallbacks:HashMap = new HashMap();
		
		public static var Timer:int;
		
		public static function isLoading(resourceName:String):Boolean
		{
			return GraphicLoadings.containsKey(resourceName);
		}
		
		public static function addCallback(resourceName:String, callback:IGraphicCallback):void
		{
			if(LoadCallbacks.containsKey(resourceName) == false)
				LoadCallbacks.put(resourceName, []);
			
			var list:Array = LoadCallbacks.get(resourceName);
			if(list.indexOf(callback) != -1) return;
			list.push(callback);
		}
		
		public static function addLoading(resourceName:String, path:String):void
		{
			if(isLoading(resourceName)) return;
			
			var loader:ImageLoader = new ImageLoader(path);
			loader.tag = resourceName;
			loader.loadAsync(loadCallback);
			
			GraphicLoadings.put(resourceName, loader);
		}
		
		private static function loadCallback(loader:ImageLoader):void
		{
			var res:String = loader.tag as String;
			
			GraphicLoadings.remove(res);
			
			var bmd:BitmapData = loader.content.bitmapData;
			
			DisposeUtil.free(loader);
			
			var list:Array = LoadCallbacks.get(res);
			
			for each(var callback:IGraphicCallback in list)
			{
				callback.callback(bmd);
			}
		}
		
		public static function t(...args):void
		{
			trace.apply(null, args);
		}
		
		public function EngineGlobal()
		{
		}
	}
}