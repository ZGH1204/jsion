package jsion.loaders
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import jsion.Cache;

	/**
	 * 显示资源加载器，无法直接添加到舞台，加载完成后通过 data 属性可以将显示对象添加到显示列表上显示。
	 * <p>也可作为 Swf 类库加载器，同 LibLoader 加载器。</p>
	 * @author Jsion
	 * 
	 */	
	public class SwfLoader extends BytesLoader
	{
		/** @private */
		protected var m_loader:Loader;
		
		public function SwfLoader(file:String, root:String="", managed:Boolean=true)
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
		
		/**
		 * @inheritDoc
		 */		
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
				m_loader.loadBytes(bytes, new LoaderContext(false, ApplicationDomain.currentDomain));
				m_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, __embedInDomainHandler);
				
				m_data = m_loader;
			}
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function cancel():void
		{
			if(m_status == LOADING && m_loader)
			{
				try { m_loader.close(); } catch (err:Error) { }
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
				try { m_loader.close(); } catch (err:Error) { }
				m_loader = null;
			}
			
			super.dispose();
		}
	}
}