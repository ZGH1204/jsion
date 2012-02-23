package
{
	import flash.display.Loader;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import zip.ZipEntry;
	import zip.ZipFile;
	
	public class Launcher
	{
		protected var m_stage:Stage;
		
		protected var configLoader:URLLoader;
		
		protected var configXML:XML;
		
		protected var startupInfo:StartupInfo;
		
		protected var startupLoader:URLLoader;
		
		protected var version:int;
		
		
		
		protected var embedLoader:Loader;
		
		
		protected var m_callback:Function;
		
		protected var m_resRoot:String;
		
		
		public function Launcher(stage:Stage)
		{
			m_stage = stage;
		}
		
		public function launch(configPath:String, callback:Function = null):void
		{
			configLoader = new URLLoader();
			
			configLoader.dataFormat = URLLoaderDataFormat.BINARY;
			
			configLoader.addEventListener(Event.COMPLETE, __configCompleteHandler);
			configLoader.addEventListener(IOErrorEvent.IO_ERROR, __errorHandler);
			configLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, __errorHandler);
			
			var url:String = configPath + "?rnd=" + Math.random();
			
			configLoader.load(new URLRequest(url));
			
			m_callback = callback;
		}
		
		private function __configCompleteHandler(e:Event):void
		{
			configXML = new XML(configLoader.data);
			
			m_resRoot = String(configXML.config.@ModRoot);
			
			configLoader.removeEventListener(Event.COMPLETE, __configCompleteHandler);
			configLoader.removeEventListener(IOErrorEvent.IO_ERROR, __errorHandler);
			configLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, __errorHandler);
			configLoader = null;
			
			var versionXL:XMLList = configXML.version;
			
			for each(var verXML:XML in versionXL)
			{
				version = Math.max(version, int(verXML.@to));
			}
			
			startupInfo = new StartupInfo();
			
			var startupXL:XMLList = configXML.Startup;
			
			for each(var xml:XML in startupXL)
			{
				startupInfo.id = xml.@id;
				startupInfo.cls = xml.@cls;
				startupInfo.url = xml.@url;
				startupInfo.crypted = String(xml.@crypted) == "false" ? false : true;
				
				break;
			}
			
			if(startupInfo.url == null || startupInfo.url == "")
			{
				throw new Error("未设置启动需要加载的基础库,启动失败!");
				
				return;
			}
			
			loadStartup();
		}
		
		private function __errorHandler(e:Event):void
		{
			throw new Error(e.toString());
		}
		
		private function loadStartup():void
		{
			startupLoader = new URLLoader();
			startupLoader.dataFormat = URLLoaderDataFormat.BINARY;
			
			startupLoader.addEventListener(Event.COMPLETE, __startupCompleteHandler);
			startupLoader.addEventListener(IOErrorEvent.IO_ERROR, __errorHandler);
			startupLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, __errorHandler);
			
			var url:String = combinPath(m_resRoot, startupInfo.url + "?v=" + version);
			
			startupLoader.load(new URLRequest(url));
		}
		
		private function __startupCompleteHandler(e:Event):void
		{
			var bytes:ByteArray = startupLoader.data as ByteArray;
			
			var zipFile:ZipFile = new ZipFile(bytes);
			
			var entry:ZipEntry = zipFile.getEntry("library.swf");
			
			var libBytes:ByteArray = zipFile.getInput(entry);
			
			loadBytes(libBytes);
			
			startupLoader.removeEventListener(Event.COMPLETE, __startupCompleteHandler);
			startupLoader.removeEventListener(IOErrorEvent.IO_ERROR, __errorHandler);
			startupLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, __errorHandler);
			startupLoader = null;
		}
		
		
		private function loadBytes(bytes:ByteArray):void
		{
			embedLoader = new Loader();
			
			embedLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, __embedCompleteHandler);
			
			embedLoader.loadBytes(bytes, new LoaderContext(false, ApplicationDomain.currentDomain));
		}
		
		private function __embedCompleteHandler(e:Event):void
		{
			embedLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, __embedCompleteHandler);
			embedLoader = null;
			
			var fn:Function = ApplicationDomain.currentDomain.getDefinition("jsion.JsionCoreSetup") as Function;
			
			if(fn != null) fn(m_stage, configXML);
			
			var global:Object = ApplicationDomain.currentDomain.getDefinition("jsion.core.Global");
			
			if(global) global.ConfigXml = configXML;
			
			var mgr:Object = ApplicationDomain.currentDomain.getDefinition("jsion.core.modules.ModuleMgr");
			
			if(mgr) mgr.loadAutoLoadModule(loadAutoModuleCallback);
			else if(m_callback != null) m_callback(configXML);
			
			configXML = null;
		}
		
		private function loadAutoModuleCallback():void
		{
			if(m_callback != null) m_callback(configXML);
		}
		
		public static function combinPath(...args):String
		{
			var path:String = "";
			
			if(args.length <= 0) return path;
			else if(args.length == 1) return args[0];
			else path = args.shift();
			
			var splitor:String;
			
			if(path.lastIndexOf("\\") != -1) splitor = "\\";
			else splitor = "/";
			
			for each(var arg:String in args)
			{
				if(path.lastIndexOf("\\") == (path.length - 1) || path.lastIndexOf("/") == (path.length - 1))
				{
					if(arg.indexOf("\\") == 0 || arg.indexOf("/") == 0) path = path + arg.substr(1);
					else path = path + arg;
				}
				else
				{
					if(arg.indexOf("\\") == 0 || arg.indexOf("/") == 0) path = path + arg;
					else path = path + splitor + arg;
				}
			}
			
			return path;
		}
		
		public function dispose():void
		{
			if(configLoader)
			{
				configLoader.removeEventListener(Event.COMPLETE, __configCompleteHandler);
				configLoader.removeEventListener(IOErrorEvent.IO_ERROR, __errorHandler);
				configLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, __errorHandler);
				configLoader = null;
			}
			
			if(startupLoader)
			{
				startupLoader.removeEventListener(Event.COMPLETE, __startupCompleteHandler);
				startupLoader.removeEventListener(IOErrorEvent.IO_ERROR, __errorHandler);
				startupLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, __errorHandler);
				startupLoader = null;
			}
			
			if(embedLoader)
			{
				embedLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, __embedCompleteHandler);
				embedLoader = null;
			}
			
			m_stage = null;
			
			configXML = null;
			
			startupInfo = null;
			
			m_callback = null;
		}
	}
}