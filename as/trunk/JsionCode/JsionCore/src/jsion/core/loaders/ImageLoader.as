package jsion.core.loaders
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import jsion.core.events.JLoaderProgressEvent;

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
		protected var _imgLoader:Loader;
		
		public function ImageLoader(url:String, cfg:Object = null)
		{
			super(url, cfg);
		}
		
		override protected function load():void
		{
			var bytes:ByteArray = Cache.loadData(url, _cacheInMemory);
			
			if(bytes)
			{
				onOpenHandler(null);
				onProgressHandler(new JLoaderProgressEvent(JLoaderProgressEvent.Progress, bytes.length / 2, bytes.length));
				loadInDomain(bytes);
			}
			else
			{
				super.load();
			}
		}
		
		override protected function onCompleteHandler(e:Event):void
		{
			removeLoadEvent(_loader);
			removeBytesTotalEvent(_loader);
			
			var bytes:ByteArray = decrypt(_loader.data as ByteArray);
			
			Cache.cacheData(url, bytes, _cacheInMemory);
			
			loadInDomain(bytes);
		}
		
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
		
		override protected function setContent(data:*):void
		{
			_content = _imgLoader.content;
			_imgLoader.unload();
		}
		
		override public function dispose():void
		{
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