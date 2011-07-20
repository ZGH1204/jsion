package jcore.org.loader
{
	import flash.display.Loader;
	import flash.utils.Dictionary;
	
	import jutils.org.util.ArrayUtil;
	import jutils.org.util.DictionaryUtil;

	/**
	 * 加载管理类
	 * @author Jsion
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion JUtils 1
	 * 
	 */	
	public class LoaderMonitor
	{
		/**
		 * 允许同时最大加载数，默认为5。
		 */		
		public static var syncLoaders:int = 5;
		
		/**
		 * 当前正在进行加载数
		 */		
		private static var numLoadings:int = 0;
		
		/**
		 * 当前正在加载列表
		 */		
		private static var loadingList:Dictionary = new Dictionary();
		
		/**
		 * 正在等待的加载队列
		 */		
		private static var waitingLoader:Array = [];
		
		/**
		 * 当前正在进行加载数
		 * @return 加载个数
		 * 
		 */		
		public static function get loadingCount():int
		{
			return numLoadings;
		}
		
		/**
		 * 加入管理，进入等待加载队列。
		 * @param loader 要加入队列的加载
		 * 
		 */		
		public static function joinManaged(loader:ILoader):void
		{
			if(loader && waitingLoader.indexOf(loader) == -1)
				waitingLoader.push(loader);
			
			tryLoadNext();
		}
		
		/**
		 * 取消加载，无论是否正在加载。
		 * @param loader 要取消的加载
		 * 
		 */		
		public static function exitManaged(loader:ILoader):void
		{
			if(loader == null) return;
			
			if(DictionaryUtil.containsKey(loadingList, loader))
			{
				DictionaryUtil.delKey(loadingList, loader);
				
				numLoadings--;
				
				tryLoadNext();
			}
			else if(waitingLoader.indexOf(loader) != -1)
			{
				ArrayUtil.remove(waitingLoader, loader);
			}
		}
		
		/**
		 * 指示被管理的加载是否可以开始加载
		 * @param loader 被管理的加载
		 * @return 是否可以进行加载
		 * 
		 */		
		public static function getCanLoad(loader:ILoader):Boolean
		{
			return loadingList[loader] == true;
		}
		
		/**
		 * 加载完成，继续下一个加载。
		 * @param loader 完成的加载
		 * 
		 */		
		public static function completeLoad(loader:ILoader):void
		{
			if(DictionaryUtil.containsKey(loadingList, loader))
			{
				DictionaryUtil.delKey(loadingList, loader);
				
				numLoadings--;
				
				tryLoadNext();
			}
		}
		
		/**
		 * 尝试加载下一个，直到最大允许加载数或等待队列为空。
		 * 
		 */		
		private static function tryLoadNext():void
		{
			while(waitingLoader.length > 0 && numLoadings < syncLoaders)
			{
				var loader:ILoader = waitingLoader.shift() as ILoader;
				
				if(loader == null || loader.isLoading) continue;
				
				numLoadings++;
				loadingList[loader] = true;
				loader.loadAsync();
			}
		}
	}
}