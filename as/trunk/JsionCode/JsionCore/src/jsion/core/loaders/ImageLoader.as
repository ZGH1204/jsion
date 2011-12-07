package jsion.core.loaders
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import jsion.Cache;
	import jsion.core.events.JLoaderProgressEvent;
	import jsion.utils.JUtil;

	/**
	 * <p>图片资源加载类</p>
	 * @see JLoader
	 * @author Jsion
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion JUtils 1
	 * 
	 */	
	public class ImageLoader extends BinaryLoader
	{
		/** @private */
		protected var _imgLoader:Loader;
		
		private var cacheBytes:ByteArray;
		
		public function ImageLoader(url:String, cfg:Object = null)
		{
			super(url, cfg);
		}
		
		/** @private */
		override protected function load():void
		{
			if(_isComplete || _isLoading) return;
			
			cacheBytes = Cache.loadData(url, _cacheInMemory);
			
			if(cacheBytes)
			{
				JUtil.addEnterFrame(__loadCompletedAsyncHandler);
			}
			else
			{
				super.load();
			}
		}
		
		private function __loadCompletedAsyncHandler(e:Event):void
		{
			JUtil.removeEnterFrame(__loadCompletedAsyncHandler);
			
			onOpenHandler(null);
			onProgressHandler(new JLoaderProgressEvent(JLoaderProgressEvent.PROGRESS, cacheBytes.length * 0.999, cacheBytes.length));
			loadInDomain(cacheBytes);
			cacheBytes = null;
		}
		
		/** @private */
		override protected function onCompleteHandler(e:Event):void
		{
			removeLoadEvent(_loader);
			removeBytesTotalEvent(_loader);
			
			var bytes:ByteArray = decrypt(_loader.data as ByteArray);
			
			Cache.cacheData(url, bytes, _cacheInMemory);
			
			loadInDomain(bytes);
		}
		
		/** @private */
		protected function loadInDomain(bytes:ByteArray):void
		{
			_imgLoader = new Loader();
			
			_imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, __completeHandler, false, int.MAX_VALUE);
			
			_imgLoader.loadBytes(bytes);
		}
		
		private function __completeHandler(e:Event):void
		{
			_imgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, __completeHandler);
			
			super.onCompleteHandler(e);
		}
		
		/** @private */
		override protected function setContent(data:*):void
		{
			_content = _imgLoader.content;
			_imgLoader.unload();
		}
		
		override public function dispose():void
		{
			cacheBytes = null;
			
			if(_imgLoader)
			{
				if(_imgLoader.contentLoaderInfo)
					_imgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, __completeHandler);
				_imgLoader.unloadAndStop();
			}
			_imgLoader = null;
			
			super.dispose();
		}
	}
}