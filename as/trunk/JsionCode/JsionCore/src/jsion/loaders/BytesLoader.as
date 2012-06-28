package jsion.loaders
{
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;
	
	import jsion.Cache;

	/**
	 * 字节流加载器
	 * @author Jsion
	 * 
	 */	
	public class BytesLoader extends JsionLoader
	{
		/** @private */
		protected var m_urlLoader:URLLoader;
		
		public function BytesLoader(file:String, root:String = "", managed:Boolean = true)
		{
			super(file, root, managed);
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function initialize():void
		{
			super.initialize();
			
			m_urlLoader = new URLLoader();
			m_urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function load():void
		{
			listenLoadEvent(m_urlLoader);
			m_urlLoader.load(m_request);
			
			super.load();
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function onLoadCompleted():void
		{
			if(m_data == null && m_status == LOADING)
			{
				m_data = decrypt(m_urlLoader.data as ByteArray);
				
				if(m_cache) Cache.cacheData(m_urlKey, m_data, m_cacheInMemory);
			}
			
			super.onLoadCompleted();
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function loadCache():void
		{
			if(m_data == null && m_status == LOADING)
			{
				m_data = Cache.loadData(m_urlKey, m_cacheInMemory);
			}
			
			onLoadCacheComplete();
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function loadTotalBytes(callback:Function = null):void
		{
			super.loadTotalBytes(callback);
			
			if(m_totalBytes > 0) return;
			
			listenLoadTotalBytesEvent(m_urlLoader);
			m_urlLoader.load(m_request);
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function onLoadTotalBytesComplete():void
		{
			try { m_urlLoader.close(); } catch (err:Error) { }
			
			super.onLoadTotalBytesComplete();
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function cancel():void
		{
			if(m_status == LOADING)
			{
				removeLoadEvent(m_urlLoader);
				
				try { m_urlLoader.close(); } catch (err:Error) { }
			}
			
			super.cancel();
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function dispose():void
		{
			removeLoadEvent(m_urlLoader);
			removeLoadTotalBytesEvent(m_urlLoader);
			
			try { m_urlLoader.close(); } catch (err:Error) { }
			removeLoadEvent(m_urlLoader);
			m_urlLoader = null;
			
			super.dispose();
		}
	}
}