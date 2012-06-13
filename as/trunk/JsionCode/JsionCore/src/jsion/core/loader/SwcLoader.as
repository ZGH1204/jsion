package jsion.core.loader
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import jsion.Cache;
	import jsion.core.zip.ZipEntry;
	import jsion.core.zip.ZipFile;
	import jsion.utils.ReflectionUtil;

	/**
	 * Swc 类库加载器，自动嵌入到当前应用程序域。
	 * @author Jsion
	 * 
	 */	
	public class SwcLoader extends BytesLoader
	{
		/** @private */
		protected var m_loader:Loader;
		
		public function SwcLoader(file:String, root:String = "", managed:Boolean = true)
		{
			super(file, root, managed);
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function onLoadCompleted():void
		{
			if(m_loader == null && m_status == LOADING)
			{
				var bytes:ByteArray = decrypt(m_urlLoader.data as ByteArray);
				
				if(m_cache) Cache.cacheData(m_urlKey, bytes, m_cacheInMemory);

				loadInDomain(bytes);
			}
			else if(m_status == COMPLETE)
			{
				super.onLoadCompleted();
			}
		}
		
		private function loadInDomain(bytes:ByteArray):void
		{
			if(m_loader == null)
			{
				bytes.position = 0;
				
				var zip:ZipFile = new ZipFile(bytes);
				
				var entry:ZipEntry;
				
				entry = zip.getEntry("catalog.xml");
				var xmlBytes:ByteArray = zip.getInput(entry);
				
				m_data = ReflectionUtil.parseAssembly(new XML(xmlBytes));
				
				
				
				
				entry = zip.getEntry("library.swf");
				var libBytes:ByteArray = zip.getInput(entry);
				
				m_loader = new Loader();
				m_loader.loadBytes(libBytes, new LoaderContext(false, ApplicationDomain.currentDomain));
				m_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, __embedInDomainHandler);
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
		
		/**
		 * @inheritDoc
		 */		
		override protected function loadCache():void
		{
			if(m_loader == null && m_status == LOADING)
			{
				var bytes:ByteArray = Cache.loadData(m_urlKey, m_cacheInMemory) as ByteArray;
				
				loadInDomain(bytes);
			}
			else  if(m_status == COMPLETE)
			{
				onLoadCacheComplete();
			}
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function cancel():void
		{
			if(m_status == LOADING && m_loader)
			{
				m_loader.close();
				m_loader.unload();
			}
			
			super.cancel();
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function dispose():void
		{
			if(m_loader)
			{
				m_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, __embedInDomainHandler);
				m_loader.close();
				m_loader = null;
			}
			
			super.dispose();
		}
	}
}