package
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.system.Security;
	
	import jcore.org.loader.ILoaders;
	import jcore.org.loader.XmlLoader;
	import jcore.org.message.DefaultMsg;
	import jcore.org.message.MessageMonitor;
	import jcore.org.moduls.ModuleDefaultMsg;
	import jcore.org.moduls.ModuleInfo;
	import jcore.org.moduls.ModuleInfoMgr;
	
	import jutils.org.util.DisposeUtil;
	import jutils.org.util.StringUtil;

	public class Launcher
	{
		private var _configFilePath:String;
		private var _configLoader:XmlLoader;
		private var _sprite:Sprite;
		private var _otherInitFn:Function;
		
		public var stage:Stage;
		
		public var config:XML;
		
		public function Launcher(sprite:Sprite, configFilePath:String, otherInitFn:Function)
		{
			_sprite = sprite;
			_configFilePath = configFilePath;
			_otherInitFn = otherInitFn;
			
			if(StringUtil.isNullOrEmpty(configFilePath))
			{
				throw new ArgumentError("The configFilePath argument must be not null or empty!");
				return;
			}
		}
		
		public function launch():void
		{
			if(_sprite.stage)
			{
				loadConfig();
				stage = _sprite.stage;
			}
			else
			{
				_sprite.addEventListener(Event.ADDED_TO_STAGE, __addToStageHandler);
			}
		}
		
		private function __addToStageHandler(e:Event):void
		{
			_sprite.removeEventListener(Event.ADDED_TO_STAGE, __addToStageHandler);
			stage = _sprite.stage;
			loadConfig();
		}
		
		private function loadConfig():void
		{
			_configLoader = new XmlLoader(_configFilePath, {rnd: true});
			_configLoader.loadAsync(configLoadCallback);
		}
			
		
		private function configLoadCallback(loader:XmlLoader):void
		{
			if(loader.content == null)
			{
				throw new Error("[Launcher]: The config load failed!");
				return;
			}
			
			config = loader.content as XML;
			
			//trace("加载跨域文件..");
			loadPolicies(config);
			
			//trace("初始化公共库..");
			JCoreStartup(stage, config);
			
			//trace("初始化其他库");
			if(_otherInitFn != null) _otherInitFn(this);
			//MessageMonitor.createAndSendMsg(DefaultMsg.SetupConfig, "Launcher", null, stage, config);
			
			//trace("注册模块信息..");
			ModuleInfoMgr.setup(config);
			
			//trace("加载启动模块..");
			ModuleInfoMgr.loadModuleFiles(ModuleInfoMgr.startupModuleInfoList).start(loadStartupsCallback);
		}
		
		private function loadStartupsCallback(loaders:ILoaders):void
		{
			//trace("加载完成");
			
			DisposeUtil.free(_configLoader);
			_configLoader = null;
			
			var geters:Array = [];
			
			for each(var moduleInfo:ModuleInfo in ModuleInfoMgr.startupModuleInfoList)
			{
				geters.push(moduleInfo.id);
			}
			
			MessageMonitor.createAndPostMsg(ModuleDefaultMsg.Install, "Launcher", geters);
		}
		
		/**
		 * 加载跨域文件
		 * @param config 包含跨域文件列表的配置文件
		 * 
		 */		
		private function loadPolicies(config:XML):void
		{
			var policys:XMLList = config.Policys..policy;
			
			for each(var xml:XML in policys)
			{
				var file:String = String(xml.@file);
				Security.loadPolicyFile(file);
			}
		}
	}
}