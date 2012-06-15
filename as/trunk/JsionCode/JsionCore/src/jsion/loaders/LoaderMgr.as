package jsion.loaders
{

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
			return loadingList.indexOf(loader) != -1;
		}
		
		public static function putLoader(loader:ILoader):void
		{
			pushLoader(loader);
			
			tryLoadNext();
		}
		
		public static function removeLoader(loader:ILoader):void
		{
			remvLoader(loader);
			removeLoadingLoader(loader);
			
			tryLoadNext();
		}
		
		public static function tryLoadNext():void
		{
			while(loadingList.length < MaxSyncLoad && loaderList.length > 0)
			{
				var loader:ILoader = loaderList.shift() as ILoader;
				
				pushLoadingLoader(loader);
				
				loader.loadAsync();
			}
		}
		
		private static function pushLoader(loader:ILoader):void
		{
			if(loaderList.indexOf(loader) == -1)
			{
				loaderList.push(loader);
			}
		}
		
		private static function remvLoader(loader:ILoader):void
		{
			var index:int = loaderList.indexOf(loader);
			
			if(index == -1) return;
			
			loaderList.splice(index, 1);
		}
		
		private static function pushLoadingLoader(loader:ILoader):void
		{
			if(loadingList.indexOf(loader) == -1)
			{
				loadingList.push(loader);
			}
		}
		
		private static function removeLoadingLoader(loader:ILoader):void
		{
			var index:int = loadingList.indexOf(loader);
			
			if(index == -1) return;
			
			loadingList.splice(index, 1);
		}
	}
}