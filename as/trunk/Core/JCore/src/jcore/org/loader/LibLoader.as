package jcore.org.loader
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	/**
	 * <p>未加密类库的加载类(swf格式的类库)</p>
	 * @see JLoader
	 * @author Jsion
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion JCore 1
	 * 
	 */	
	public class LibLoader extends BinaryLoader
	{
		protected var _libLoader:Loader;
		
		public function LibLoader(url:String, cfg:Object = null)
		{
			super(url, cfg);
		}
		
		override protected function onCompleteHandler(e:Event):void
		{
			_content = decrypt(_loader.data as ByteArray);
			
			_libLoader = new Loader();
			
			_libLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, __completeHandler, false, int.MAX_VALUE);
			
			_libLoader.loadBytes(_content as ByteArray, _context as LoaderContext);
		}
		
		private function __completeHandler(e:Event):void
		{
			_libLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, __completeHandler);
			super.onCompleteHandler(e);
		}
		
		override protected function setContent(data:*):void
		{
			
		}
		
		override public function dispose():void
		{
			if(_libLoader)
			{
				if(_libLoader.contentLoaderInfo)
					_libLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, __completeHandler);
				//_libLoader.unloadAndStop();
			}
			_libLoader = null;
			
			super.dispose();
		}
	}
}