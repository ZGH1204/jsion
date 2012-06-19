package jsion.loaders
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import jsion.Cache;
	import jsion.utils.DisposeUtil;

	/**
	 * 图片资源加载器，图片资源被加载为 BitmapData 对象。
	 * @author Jsion
	 * 
	 */	
	public class BitmapDataLoader extends BytesLoader
	{
		/** @private */
		protected var m_loader:Loader;
		
		public function BitmapDataLoader(file:String, root:String = "", managed:Boolean = true)
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
				
				loadBitmap(bytes);
			}
			else if(m_status == COMPLETE)
			{
				super.onLoadCompleted();
			}
		}
		
		private function __embedInDomainHandler(e:Event):void
		{
			m_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, __embedInDomainHandler);
			
			m_data = Bitmap(m_loader.content).bitmapData.clone();
			
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
				
				loadBitmap(bytes);
			}
			else if(m_status == COMPLETE)
			{
				onLoadCacheComplete();
			}
		}
		
		private function loadBitmap(bytes:ByteArray):void
		{
			if(m_loader == null && m_status == LOADING)
			{
				m_loader = new Loader();
				m_loader.loadBytes(bytes);
				m_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, __embedInDomainHandler);
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
				m_loader.unloadAndStop();
				m_loader = null;
			}
			
			super.dispose();
		}
	}
}