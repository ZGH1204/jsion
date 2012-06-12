package jsion.core.loader
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import jsion.Cache;

	public class SwfLoader extends BytesLoader
	{
		protected var m_loader:Loader;
		
		public function SwfLoader(file:String, root:String="", managed:Boolean=true)
		{
			super(file, root, managed);
		}
		
		override protected function onLoadCompleted():void
		{
			if(m_loader == null && m_status == LOADING)
			{
				var bytes:ByteArray = m_cryptor.decry(m_urlLoader.data as ByteArray);
				
				if(m_cache) Cache.cacheData(m_urlKey, bytes, m_cacheInMemory);
				
				loadSwfBytes(bytes);
			}
			else if(m_status == COMPLETE)
			{
				super.onLoadCompleted();
			}
		}
		
		private function __embedInDomainHandler(e:Event):void
		{
			m_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, __embedInDomainHandler);
			
			if(m_loadFromCache)
			{
				onLoadCacheComplete();
			}
			else
			{
				super.onLoadCompleted();
			}
		}
		
		override protected function loadCache():void
		{
			if(m_loader == null && m_status == LOADING)
			{
				var bytes:ByteArray = Cache.loadData(m_urlKey, m_cacheInMemory);
				
				loadSwfBytes(bytes);
			}
			else if(m_status == COMPLETE)
			{
				onLoadCacheComplete()
			}
		}
		
		private function loadSwfBytes(bytes:ByteArray):void
		{
			if(m_loader == null && m_status == LOADING)
			{
				m_loader = new Loader();
				m_loader.loadBytes(bytes);
				m_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, __embedInDomainHandler);
				
				m_data = m_loader;
			}
		}
		
		override public function dispose():void
		{
			if(m_loader) m_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, __embedInDomainHandler);
			
			m_loader = null;
			
			super.dispose();
		}
	}
}