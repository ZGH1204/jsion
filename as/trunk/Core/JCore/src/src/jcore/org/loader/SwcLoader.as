package jcore.org.loader
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import jutils.org.reflection.Assembly;
	import jutils.org.util.ReflectionUtil;
	import jutils.org.zip.ZipEntry;
	import jutils.org.zip.ZipFile;
	
	/**
	 * <p>未加密类库的加载类(swc格式的类库)</p>
	 * @see JLoader
	 * @author Jsion
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion JUtils 1
	 * 
	 */	
	public class SwcLoader extends BinaryLoader
	{
		protected var _libLoader:Loader;
		protected var _assembly:Assembly;
		
		public function SwcLoader(url:String, cfg:Object = null)
		{
			super(url, cfg);
		}
		
		override protected function onCompleteHandler(e:Event):void
		{
			var bytes:ByteArray = decrypt(_loader.data as ByteArray);
			
			var zip:ZipFile = new ZipFile(bytes);
			
			var entry:ZipEntry;
			
			entry = zip.getEntry("catalog.xml");
			var xmlBytes:ByteArray = zip.getInput(entry);
			
			//TODO 解析Assembly库
			_assembly = ReflectionUtil.parseAssembly(new XML(xmlBytes));
			
			entry = zip.getEntry("library.swf");
			var libBytes:ByteArray = zip.getInput(entry);
			
			_libLoader = new Loader();
			
			_libLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, __completeHandler, false, int.MAX_VALUE);
			
			_libLoader.loadBytes(libBytes, _context as LoaderContext);
		}
		
		protected function __completeHandler(e:Event):void
		{
			_libLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, __completeHandler);
			super.onCompleteHandler(e);
		}
		
		override protected function setContent(data:*):void
		{
			_content = _assembly;
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
			
			_assembly = null;
			
			super.dispose();
		}
	}
}