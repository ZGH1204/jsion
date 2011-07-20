package jcore.org.loader
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.utils.ByteArray;

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
		
		override protected function onCompleteHandler(e:Event):void
		{
			var bytes:ByteArray = decrypt(_loader.data as ByteArray);
			
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