package jsion.loaders
{
	import flash.events.ProgressEvent;
	
	import jsion.events.JsionEvent;
	import jsion.utils.DisposeUtil;
	
	
	/**
	 * 整体加载进度变更时派发。
	 * @eventType flash.events.ProgressEvent
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 */	
	[Event(name="progress", type="flash.events.ProgressEvent")]
	/**
	 * 获取所有文件所需加载总字节数后触发。
	 * @eventType jsion.core.events.JsionEvent
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 */	
	[Event(name="totalBytes", type="jsion.events.JsionEvent")]
	/**
	 * 资源队列加载器，支持先取总字节数后加载。默认文件对应加载器如下：
	 * <ul>
	 * 	<li>jpg  : BitmapDataLoader</li>
	 * 	<li>jpeg : BitmapDataLoader</li>
	 * 	<li>png  : BitmapDataLoader</li>
	 * 	<li>txt  : TextLoader</li>
	 * 	<li>xml  : XmlLoader</li>
	 * 	<li>swf  : SwfLoader</li>
	 * 	<li>swc  : SwcLoader</li>
	 * 	<li>swx  : LibLoader</li>
	 * </ul>
	 * @author Jsion
	 * 
	 */	
	public class LoaderQueue2 extends LoaderQueue
	{
		private var m_totalBytesHelper:TotalBytesHelper;
		
		private var m_totalBytes:int;
		
		private var m_bytesLoaded:int;
		
		private var m_bytesComplete:int;
		
		public function LoaderQueue2(maxSyncLoading:int = 1)
		{
			super();
			m_maxSyncLoading = maxSyncLoading;
		}
		
		/**
		 * @private
		 */		
		public function set maxSyncLoading(value:int):void
		{
			m_maxSyncLoading = value;
			
			m_maxSyncLoading = Math.max(m_maxSyncLoading, 1);
		}
		
		/**
		 * 开始队列加载，先取得队列所需加载的总字节数，然后再开始加载。
		 * @param callback 回调函数，其形式为：function callback(queue:LoaderQueue):void { }。
		 * 
		 */		
		override public function start(callback:Function=null):void
		{
			setLoadCallback(callback);
			
			if(m_loaderCount == 0) return;
			
			if(m_totalBytes == 0)
			{
				m_totalBytesHelper = new TotalBytesHelper(m_loaderList.concat(), addErrorLoader);
				
				m_totalBytesHelper.start(loadTotalBytesCallback);
			}
			else
			{
				m_bytesComplete = 0;
				
				tryLoadNext();
			}
		}
		
		private function loadTotalBytesCallback(byteTotal:int):void
		{
			m_totalBytes = byteTotal;
			
			dispatchEvent(new JsionEvent(JsionEvent.TOTAL_BYTES));
			
			m_bytesComplete = 0;
			
			tryLoadNext();
			
			DisposeUtil.free(m_totalBytesHelper);
			m_totalBytesHelper = null;
		}
		
		/**
		 * @private
		 */		
		override protected function __loaderCompleteHandler(e:JsionEvent):void
		{
			var loader:ILoader = e.currentTarget as ILoader;
			
			m_bytesComplete += loader.totalBytes;
			
			removeLoadingLoader(loader);
			
			calcBytesLoaded();
			
			super.__loaderCompleteHandler(e);
		}
		
		/**
		 * @private
		 */		
		override protected function __progressHandler(e:ProgressEvent):void
		{
			calcBytesLoaded();
			
			if(m_progressCallback != null) m_progressCallback(m_bytesLoaded, m_totalBytes);
			
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, m_bytesLoaded, m_totalBytes));
		}
		
		private function calcBytesLoaded():void
		{
			m_bytesLoaded = 0;
			
			for each(var loader:ILoader in m_loadingList)
			{
				m_bytesLoaded += loader.loadedBytes;
			}
			
			m_bytesLoaded += m_bytesComplete;
		}
	}
}