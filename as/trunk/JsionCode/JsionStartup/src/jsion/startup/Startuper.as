package jsion.startup
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
	 * 游戏启动器。启动时加载指定的 xml 配置文件。
	 * <p>配置文件加载完成后首先解析并加载配置在 Root.Policys 下的所有跨域安全策略文件，然后加载核心库以及 Loading 界面库。</p>
	 * <p>跨域安全策略文件的 xml 配置在根节点下可以有多个，其格式为：</p>
	 * <p><b>&lt;policy file="http://127.0.0.1/crossdomain.xml" /&gt;</b></p>
	 * <p>加载核心库以及 Loading 界面库的 xml 配置在根节点下有且仅有一个，其格式为：</p>
	 * <p><b>&lt;Startup CoreLib="JsionCore.swf" CoreStartFn="jsion.JsionCoreSetup" LoadingLib="Loading.swf" LoadingStartFn="StartLoading" /&gt;</b></p>
	 * <p>其中各配置属性的作用为：</p>
	 * <ul>
	 * 	<li>CoreLib 表示核心库文件路径，此路径为根节点 LibRoot 属性指定的目录的相对路径。</li>
	 * 	<li>CoreStartFn 表示核心库加载完成后执行的函数(需包含完整包路径)。其函数原形为：<b>function JsionCoreSetup(config:XML):void { }</b></li>
	 * 	<li>LoadingLib 表示外部 Loading 界面所在的类库文件路径，此路径为根节点 LibRoot 属性指定的目录的相对路径。</li>
	 * 	<li>LoadingStartFn 表示Loading 类库加载完成后执行的函数(需包含完整包路径)。其函数原形为：<b>function StartLoading(stage:Stage, config:XML):void { }</b></li>
	 * </ul>
	 * @author Jsion
	 * 
	 */	
	public class Startuper
	{
		private var m_version:int;
		
		private var m_libRoot:String;
		
		private var m_stage:Stage;
		
		private var m_configXml:XML;

		private var m_callback:Function;
		
		private var m_configLoader:URLLoader;
		
		private var m_coreLoader:Loader;
		
		private var m_loadingLoader:Loader;
		
		public function Startuper(stage:Stage)
		{
			m_stage = stage;
		}
		
		/**
		 * 运行启动器。
		 * @param configPath xml 配置文件路径
		 * @param callback 在加载完成后的回调函数，如果配置文件中配置了正确的 Loading 数据，则在加载并启动 Loading 函数后执行回调函数，否则直接执行此回调函数
		 */		
		public function startup(configPath:String, callback:Function = null):void
		{
			m_callback = callback;
			
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
			
			
			
			
			var versionXL:XMLList = m_configXml.version;
			
			for each(var verXML:XML in versionXL)
			{
				m_version = Math.max(m_version, int(verXML.@to));
			}
			
			
			
			
			
			//加载跨域文件
			var policys:XMLList = m_configXml..policy;
			
			for each(var xml:XML in policys)
			{
				var file:String = String(xml.@file);
				
				if(file != null && file != "")
				{
					Security.loadPolicyFile(file);
				}
			}
			
			
			
			//获取类库根目录
			m_libRoot = String(m_configXml.@LibRoot);
			
			if(m_libRoot != null && m_libRoot != "")
			{
				var ind:int = m_libRoot.lastIndexOf("\\");
				
				if(ind != (m_libRoot.length - 1))
				{
					ind = m_libRoot.lastIndexOf("\/");
					
					if(ind != (m_libRoot.length - 1))
					{
						m_libRoot += "\/";
					}
				}
			}
			
			
			
			
			
			
			removeConfigLoaderEvent();
			
			
			m_coreLoader = new Loader();
			addCoreLoaderEvent();
			
			var url:String = m_libRoot + String(m_configXml.Startup.@CoreLib) + "?v=" + m_version.toString();
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
			try
			{
				var fn:Function = ApplicationDomain.currentDomain.getDefinition(String(m_configXml.Startup.@CoreStartFn)) as Function;
				
				if(fn != null) fn(m_configXml);
			}
			catch(err:Error)
			{
				throw err;
			}
			
			removeCoreLoaderEvent();
			
			
			m_loadingLoader = new Loader();
			addLoadingLoaderEvent();
			
			var loadingLib:String = String(m_configXml.Startup.@LoadingLib);
			
			if(loadingLib != null && loadingLib != "")
			{
				var url:String = m_libRoot + loadingLib + "?v=" + m_version.toString();
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
			var mainFn:String = String(m_configXml.Startup.@LoadingStartFn);
			
			try
			{
				var fn:Function = ApplicationDomain.currentDomain.getDefinition(mainFn) as Function;
				
				if(fn != null) fn(m_stage, m_configXml);
			}
			catch(err:Error)
			{
				throw err;
			}
			
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