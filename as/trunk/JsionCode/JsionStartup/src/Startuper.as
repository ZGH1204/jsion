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
	import flash.net.URLVariables;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;

	/**
	 * 游戏启动器
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
		
		private var m_stage:Stage;
		
		public function Startuper(stage:Stage)
		{
			m_stage = stage;
		}
		
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
				Security.loadPolicyFile(file);
			}
			
			var versionXL:XMLList = m_configXml.version;
			
			for each(var verXML:XML in versionXL)
			{
				m_version = Math.max(m_version, int(verXML.@to));
			}
			
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
			var global:Object = ApplicationDomain.currentDomain.getDefinition("jsion.core.Global");
			
			if(global) global.ConfigXml = m_configXml;
			
			var fn:Function = ApplicationDomain.currentDomain.getDefinition("jsion.JsionCoreSetup") as Function;
			
			if(fn != null) fn(m_stage, m_configXml);
			
			
			
			if(m_callback != null) m_callback();
		}
		
		private function __coreErrorHandler(e:IOErrorEvent):void
		{
			throw new Error(e.text);
		}
		
		public function dispose():void
		{
			removeConfigLoaderEvent();
			
			if(m_configLoader)
			{
				m_configLoader.close();
				m_configLoader = null;
			}
			
			m_callback = null;
			
			m_configXml = null;
		}

		public function get configXml():XML
		{
			return m_configXml;
		}

		public function get version():int
		{
			return m_version;
		}


	}
}