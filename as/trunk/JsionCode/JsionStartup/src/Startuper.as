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
	import flash.system.Security;

	/**
	 * 游戏启动器，加载的 xml 配置文件内容保存在 jsion.Cache.ConfigXml 属性上。
	 * <p>核心库加载完成后加载指定的 大 Loading 界面所在的类库，其中的 mainFn 属性指定的开始加载函数形式应该为：</p>
	 * <p><b>function StartLoading(stage:Stage, config:XML):void { }</b></p>
	 * <p>
	 * Xml 配置项必需是根节点的直接子节点，其格式为：
	 * <b>&lt;Loading lib="必须是 swf 类型的类库文件，扩展名可任意。" mainFn="StartLoading" /&gt;</b>
	 * </p>
	 * @author Jsion
	 * 
	 */	
	public class Startuper
	{
		private var m_corePath:String;
		
		private var m_configXml:XML;

		private var m_callback:Function;
		
		private var m_configLoader:URLLoader;
		
		private var m_version:int;
		
		private var m_coreLoader:Loader;
		
		private var m_loadingLoader:Loader;
		
		private var m_stage:Stage;
		
		public function Startuper(stage:Stage)
		{
			m_stage = stage;
		}
		
		/**
		 * 运行启动器。
		 * @param configPath xml 配置文件路径
		 * @param corePath swf类型的核心库文件路径
		 * @param callback 在加载完成后的回调函数，如果配置文件中配置了正确的 Loading 节点则在加载并启动 Loading 函数后执行回调函数，否则直接执行此回调函数
		 */		
		public function startup(configPath:String, corePath:String, callback:Function = null):void
		{
			m_callback = callback;
			
			m_corePath = corePath;
			
			Security.allowDomain("*");
			
			m_configLoader = new URLLoader();
			m_configLoader.dataFormat = URLLoaderDataFormat.TEXT;
			
			addConfigLoaderEvent();
			
			var url:String = configPath + "?rnd=" + Math.random();
			
			m_configLoader.load(new URLRequest(url));
		}
		
		
		
		
		
		
		
		private function addConfigLoaderEvent():void
		{
			m_configLoader.addEventListener(Event.COMPLETE, __configCompleteHandler);
			m_configLoader.addEventListener(IOErrorEvent.IO_ERROR, __configIOErrorHandler);
			m_configLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, __configSecurityErrorHandler);
		}
		
		private function removeConfigLoaderEvent():void
		{
			if(m_configLoader)
			{
				m_configLoader.removeEventListener(Event.COMPLETE, __configCompleteHandler);
				m_configLoader.removeEventListener(IOErrorEvent.IO_ERROR, __configIOErrorHandler);
				m_configLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, __configSecurityErrorHandler);
			}
		}
		
		private function __configCompleteHandler(e:Event):void
		{
			m_configXml = new XML(m_configLoader.data);
			
			
			
			
			var policys:XMLList = m_configXml.Policys..policy;
			
			for each(var xml:XML in policys)
			{
				var file:String = String(xml.@file);
				
				if(file != null && file != "")
				{
					Security.loadPolicyFile(file);
				}
			}
			
			
			
			
			
			var versionXL:XMLList = m_configXml.version;
			
			for each(var verXML:XML in versionXL)
			{
				m_version = Math.max(m_version, int(verXML.@to));
			}
			
			
			
			removeConfigLoaderEvent();
			
			
			m_coreLoader = new Loader();
			addCoreLoaderEvent();
			
			var url:String = m_corePath + "?v=" + m_version.toString();
			m_coreLoader.load(new URLRequest(url), new LoaderContext(false, ApplicationDomain.currentDomain));
		}
		
		private function __configIOErrorHandler(e:IOErrorEvent):void
		{
			throw new Error(e.text);
		}
		
		private function __configSecurityErrorHandler(e:SecurityErrorEvent):void
		{
			throw new Error(e.text);
		}
		
		
		
		
		
		
		
		
		
		
		private function addCoreLoaderEvent():void
		{
			m_coreLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, __coreCompleteHandler);
			m_coreLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, __coreErrorHandler);
		}
		
		private function removeCoreLoaderEvent():void
		{
			if(m_coreLoader)
			{
				m_coreLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, __coreCompleteHandler);
				m_coreLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, __coreErrorHandler);
			}
		}
		
		private function __coreCompleteHandler(e:Event):void
		{
			var cache:Object = ApplicationDomain.currentDomain.getDefinition("jsion.Cache");
			
			if(cache) cache.ConfigXml = m_configXml;
			
			var fn:Function = ApplicationDomain.currentDomain.getDefinition("jsion.JsionCoreSetup") as Function;
			
			if(fn != null) fn(m_configXml);
			
			removeCoreLoaderEvent();
			
			
			m_loadingLoader = new Loader();
			addLoadingLoaderEvent();
			
			var loadingLib:String = String(m_configXml.Loading.@lib);
			
			if(loadingLib != null && loadingLib != "")
			{
				var url:String = loadingLib + "?v=" + m_version.toString();
				m_loadingLoader.load(new URLRequest(url), new LoaderContext(false, ApplicationDomain.currentDomain));
			}
			else if(m_callback != null)
			{
				m_callback();
			}
		}
		
		private function __coreErrorHandler(e:IOErrorEvent):void
		{
			throw new Error(e.text);
		}
		
		
		
		
		
		
		private function addLoadingLoaderEvent():void
		{
			m_loadingLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, __loadingCompleteHandler);
			m_loadingLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, __loadingErrorHandler);
		}
		
		private function removeLoadingLoaderEvent():void
		{
			if(m_loadingLoader == null) return;
			
			m_loadingLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, __loadingCompleteHandler);
			m_loadingLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, __loadingErrorHandler);
		}
		
		private function __loadingCompleteHandler(e:Event):void
		{
			var mainFn:String = String(m_configXml.Loading.@mainFn);
			
			var fn:Function = ApplicationDomain.currentDomain.getDefinition(mainFn) as Function;
			
			if(fn != null) fn(m_stage, m_configXml);
			
			removeLoadingLoaderEvent();
			
			if(m_callback != null) m_callback();
		}
		
		private function __loadingErrorHandler(e:IOErrorEvent):void
		{
			throw new Error(e.text);
		}
		
		
		
		
		
		public function get stage():Stage
		{
			return m_stage;
		}
		
		public function get configXml():XML
		{
			return m_configXml;
		}
		
		public function get version():int
		{
			return m_version;
		}
		
		
		
		
		
		public function dispose():void
		{
			removeConfigLoaderEvent();
			
			removeCoreLoaderEvent();
			
			removeLoadingLoaderEvent();
			
			if(m_configLoader)
			{
				m_configLoader.close();
				m_configLoader = null;
			}
			
			m_callback = null;
			
			m_configXml = null;
			
			m_coreLoader = null;
			
			m_loadingLoader = null;
		}
	}
}