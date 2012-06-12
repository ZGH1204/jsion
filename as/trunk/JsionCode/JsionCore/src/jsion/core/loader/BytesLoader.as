package jsion.core.loader
{
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;
	
	import jsion.Cache;

	public class BytesLoader extends JsionLoader
	{
		protected var m_urlLoader:URLLoader;
		
		public function BytesLoader(file:String, root:String = "", managed:Boolean = true)
		{
			super(file, root, managed);
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			m_urlLoader = new URLLoader();
			m_urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
		}
		
		override protected function load():void
		{
			listenLoadEvent(m_urlLoader);
			m_urlLoader.load(m_request);
			
			super.load();
		}
		
		override protected function onLoadCompleted():void
		{
			if(m_data == null && m_status == LOADING)
			{
				m_data = decrypt(m_urlLoader.data as ByteArray);
				
				if(m_cache) Cache.cacheData(m_urlKey, m_data, m_cacheInMemory);
			}
			
			super.onLoadCompleted();
		}
		
		override protected function loadCache():void
		{
			if(m_data == null && m_status == LOADING)
			{
				m_data = Cache.loadData(m_urlKey, m_cacheInMemory);
			}
			
			onLoadCacheComplete();
		}
		
		override public function cancel():void
		{
			if(m_status == LOADING)
			{
				removeLoadEvent(m_urlLoader);
				
				if(m_urlLoader) m_urlLoader.close();
			}
			
			super.cancel();
		}
		
		override public function dispose():void
		{
			LoaderMgr.removeLoader(this);
			
			if(m_urlLoader) m_urlLoader.close();
			removeLoadEvent(m_urlLoader);
			m_urlLoader = null;
			
			super.dispose();
		}
	}
}