package jsion.core.loader
{
	import jsion.utils.ArrayUtil;

	public class LoaderMgr
	{
		public static var ErrorHandler:ILoaderError = new DefaultLoaderError();
		
		public static var MaxSyncLoad:int = 3;
		
		private static var loaderList:Array = [];
		
		private static var loadingList:Array = [];
		
		public function LoaderMgr()
		{
		}
		
		public static function canLoad(loader:ILoader):Boolean
		{
			return ArrayUtil.containsValue(loadingList, loader);
		}
		
		public static function putLoader(loader:ILoader):void
		{
			ArrayUtil.push(loaderList, loader);
			
			tryLoadNext();
		}
		
		public static function removeLoader(loader:ILoader):void
		{
			ArrayUtil.remove(loaderList, loader);
			ArrayUtil.remove(loadingList, loader);
			
			tryLoadNext();
		}
		
		private static function tryLoadNext():void
		{
			while(loadingList.length < MaxSyncLoad && loaderList.length > 0)
			{
				var loader:ILoader = loaderList.shift() as ILoader;
				
				ArrayUtil.push(loadingList, loader);
				
				loader.loadAsync();
			}
		}
	}
}