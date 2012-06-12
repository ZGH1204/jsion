package jsion.core.loader
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import jsion.core.reflection.Assembly;
	import jsion.core.zip.ZipEntry;
	import jsion.core.zip.ZipFile;
	import jsion.utils.ReflectionUtil;

	public class SwcLoader extends BytesLoader
	{
		protected var m_loader:Loader;
		
		protected var m_assembly:Assembly;
		
		public function SwcLoader(file:String, root:String = "", managed:Boolean = true)
		{
			super(file, root, managed);
		}
		
		override protected function onCompleted():void
		{
			if(m_loader == null)
			{
				var bytes:ByteArray = m_urlLoader.data as ByteArray;
				
				var oldPos:uint = bytes.position;
				
				var zip:ZipFile = new ZipFile(bytes);
				
				var entry:ZipEntry;
				
				entry = zip.getEntry("catalog.xml");
				var xmlBytes:ByteArray = zip.getInput(entry);
				
				m_assembly = ReflectionUtil.parseAssembly(new XML(xmlBytes));
				
				entry = zip.getEntry("library.swf");
				var libBytes:ByteArray = zip.getInput(entry);
				
				m_loader = new Loader();
				m_loader.loadBytes(libBytes, new LoaderContext(false, ApplicationDomain.currentDomain));
				m_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, __embedInDomainHandler);
				
				m_data = m_assembly;
			}
			else
			{
				super.onCompleted();
			}
		}
		
		private function __embedInDomainHandler(e:Event):void
		{
			m_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, __embedInDomainHandler);
			
			super.onCompleted();
		}
		
		override public function dispose():void
		{
			if(m_loader) m_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, __embedInDomainHandler);
			
			m_loader = null;
			
			super.dispose();
		}
	}
}