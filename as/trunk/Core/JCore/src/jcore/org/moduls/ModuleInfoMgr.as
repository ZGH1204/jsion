package jcore.org.moduls
{
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	
	import jcore.org.cryptor.ICryption;
	import jcore.org.cryptor.ModuleCrytor;
	import jcore.org.events.JLoaderEvent;
	import jcore.org.loader.ILoader;
	import jcore.org.loader.ILoaders;
	import jcore.org.loader.JLoaders;
	import jcore.org.loader.LoaderGlobal;
	import jcore.org.loader.SwcLoader;
	
	import jutils.org.reflection.Assembly;
	import jutils.org.util.AppDomainUtil;
	import jutils.org.util.ArrayUtil;
	import jutils.org.util.DictionaryUtil;
	import jutils.org.util.DisposeUtil;
	import jutils.org.util.StringUtil;
	import jutils.org.util.XmlUtil;

	public class ModuleInfoMgr
	{
		public static var Current_Domain_Context:LoaderContext = Global.Current_Domain_Context;
		
		private static var Module_Loader_Cfg:Object = {type: LoaderGlobal.TYPE_SWC, context: null};
		private static var Module_Cryptor:ICryption = new ModuleCrytor();
		
		private static var _startupModuleInfoList:Array = [];
		
		private static var _moduleInfoListDic:Dictionary = new Dictionary();
		
		private static var _loadersList:Array = [];
		
		private static var _loadersCount:int = 0;
		
		private static var _loadingModuleInfoList:Array = [];
		
		/**
		 * 启动时需要加载的模块信息列表
		 */		
		public static function get startupModuleInfoList():Array
		{
			return _startupModuleInfoList;
		}
		
		/**
		 * 游戏模块信息列表
		 */
		public static function get moduleInfoListDic():Dictionary
		{
			return _moduleInfoListDic;
		}
		
		/**
		 * 注册模块信息
		 * @param config 包含模块信息的配置文件
		 * 
		 */		
		public static function setup(config:XML):void
		{
			var modulXL:XMLList = config.Modules.Module;
			
			for each(var xml:XML in modulXL)
			{
				var modul:ModuleInfo = new ModuleInfo();
				XmlUtil.decodeWithProperty(modul, xml, true);
				if(StringUtil.isNullOrEmpty(modul.file)) continue;
				if(modul.startup) _startupModuleInfoList.push(modul);
				registeModuleInfo(modul);
			}
		}
		
		/**
		 * 注册模块信息
		 * @param module 模块信息
		 * 
		 */		
		public static function registeModuleInfo(module:ModuleInfo):void
		{
			if(module == null || StringUtil.isNullOrEmpty(module.file) || StringUtil.isNullOrEmpty(module.id)) return;
			
			if(_moduleInfoListDic[module.id])
			{
				throw new Error(module.id + "模块已存在，请更改其他模块ID。");
				return;
			}
			
			_moduleInfoListDic[module.id] = module;
		}
		
		/**
		 * 通过模块ID获取模块信息
		 * @param id 模块ID
		 * @return 模块信息
		 * 
		 */		
		public static function getModuleInfoByID(id:String):ModuleInfo
		{
			return _moduleInfoListDic[id];
		}
		
		/**
		 * 通过模块程序集文件查找模块信息
		 * @param file 模块程序集文件
		 * @return 模块信息
		 * 
		 */		
		public static function getModuleInfoByFile(file:String):ModuleInfo
		{
			for each(var moduleInfo:ModuleInfo in _moduleInfoListDic)
			{
				if(moduleInfo.file == file) return moduleInfo;
			}
			
			return null;
		}
		
		/**
		 * 移除模块信息
		 * @param moduleInfo 要移除的模块信息
		 * 
		 */		
		public static function removeModuleInfo(moduleInfo:ModuleInfo):void
		{
			if(moduleInfo == null)
			{
				//throw new ArgumentError("参数 moduleInfo 不能为空!");
				return;
			}
			
			removeModuleInfoByID(moduleInfo.id);
		}
		
		/**
		 * 通过模块ID移除模块信息
		 * @param id 模块ID
		 * @return 移除的模块信息
		 * 
		 */		
		public static function removeModuleInfoByID(id:String):ModuleInfo
		{
			return DictionaryUtil.delKey(_moduleInfoListDic, id);
		}
		
		/**
		 * 加载模块库
		 * @param moduleInfo 模块信息
		 * @return 加载器(未开始加载)
		 * 
		 */		
		public static function loadModuleFile(moduleInfo:ModuleInfo):ILoader
		{
			if(moduleInfo == null || StringUtil.isNullOrEmpty(moduleInfo.file)) return null;
			
			var domains:ApplicationDomain;
			
			if(moduleInfo.target == ModuleTarget.Blank)
			{
				domains = new ApplicationDomain();
				AppDomainUtil.registeAppDomain(domains);
				Module_Loader_Cfg["context"] = new LoaderContext(false, domains);
			}
			else if(moduleInfo.target == ModuleTarget.Child)
			{
				domains = new ApplicationDomain(ApplicationDomain.currentDomain);
				AppDomainUtil.registeAppDomain(domains);
				Module_Loader_Cfg["context"] = new LoaderContext(false, domains);
			}
			else
			{
				domains = ApplicationDomain.currentDomain;
				Module_Loader_Cfg["context"] = Current_Domain_Context;
			}
			
			if(moduleInfo.crypt)
			{
				Module_Loader_Cfg["cryptor"] = Module_Cryptor;
			}
			else
			{
				Module_Loader_Cfg["cryptor"] = null;
			}
			
			var loader:ILoader = new SwcLoader(moduleInfo.file, Module_Loader_Cfg);
			_loadersList.push(loader);
			
			ArrayUtil.push(_loadingModuleInfoList, moduleInfo);
			
			loader.addEventListener(JLoaderEvent.Complete, __moduleLoadCompleteHandler, false, int.MAX_VALUE);
			loader.addEventListener(JLoaderEvent.Error, __moduleLoadErrorHandler, false, int.MAX_VALUE);
			loader.addEventListener(JLoaderEvent.Complete, __disposeHandler, false, int.MIN_VALUE);
			loader.addEventListener(JLoaderEvent.Error, __disposeHandler, false, int.MIN_VALUE);
			
			moduleInfo.domain = domains;
			domains = null;
			Module_Loader_Cfg["context"] = null;
			
			return loader;
		}
		
		private static function __moduleLoadCompleteHandler(e:JLoaderEvent):void
		{
			var loader:ILoader = e.currentTarget as ILoader;
			
			moduleInfoLoadComplete(loader);
		}
		
		private static function __disposeHandler(e:JLoaderEvent):void
		{
			var loader:ILoader = e.currentTarget as ILoader;
			
			ArrayUtil.remove(_loadersList, loader);
			loader.removeEventListener(JLoaderEvent.Complete, __moduleLoadCompleteHandler);
			loader.removeEventListener(JLoaderEvent.Error, __moduleLoadErrorHandler);
			loader.removeEventListener(JLoaderEvent.Complete, __disposeHandler);
			loader.removeEventListener(JLoaderEvent.Error, __disposeHandler);
			
			DisposeUtil.free(loader);
			loader = null;
		}
		
		private static function __moduleLoadErrorHandler(e:JLoaderEvent):void
		{
			var loader:ILoader = e.currentTarget as ILoader;
			
			moduleInfoLoadError(loader);
		}
		
		private static function moduleInfoLoadComplete(loader:ILoader):void
		{
			for(var i:int = 0; i < _loadingModuleInfoList.length; i++)
			{
				var moduleInfo:ModuleInfo = _loadingModuleInfoList[i];
				if(moduleInfo.file == loader.url && moduleInfo.isLoaded == false)
				{
					moduleInfo.isLoaded = true;
					moduleInfo.isError = false;
					moduleInfo.assembly = loader.content as Assembly;
					AppDomainUtil.registeAppDomain(moduleInfo.domain);
					
					ModuleMonitor.createModule(moduleInfo);
					//var module:DefaultModule = ModuleMonitor.createModule(moduleInfo);
					//MessageMonitor.registeReceiver(module);
					
					_loadingModuleInfoList.splice(i, 1);
					i--;
				}
			}
		}
		
		private static function moduleInfoLoadError(loader:ILoader):void
		{
			for(var i:int = 0; i < _loadingModuleInfoList.length; i++)
			{
				var moduleInfo:ModuleInfo = _loadingModuleInfoList[i];
				if(moduleInfo.file == loader.url && moduleInfo.isError == false)
				{
					moduleInfo.isLoaded = false;
					moduleInfo.isError = true;
					
					_loadingModuleInfoList.splice(i, 1);
					i--;
				}
			}
		}
		
		/**
		 * 批量加载模块库
		 * @param list 模块信息列表
		 * @return 指加载器(未开始加载)
		 * 
		 */		
		public static function loadModuleFiles(list:Array):ILoaders
		{
			_loadersCount++;
			
			var loaders:ILoaders = new JLoaders("ModuleLoader_" + _loadersCount);
			_loadersList.push(loaders);
			
			var domains:ApplicationDomain;
			
			for each(var info:ModuleInfo in list)
			{
				if(info.target == ModuleTarget.Blank)
				{
					domains = new ApplicationDomain();
					AppDomainUtil.registeAppDomain(domains);
					Module_Loader_Cfg["context"] = new LoaderContext(false, domains);
				}
				else if(info.target == ModuleTarget.Child)
				{
					domains = new ApplicationDomain(ApplicationDomain.currentDomain);
					AppDomainUtil.registeAppDomain(domains);
					Module_Loader_Cfg["context"] = new LoaderContext(false, domains);
				}
				else
				{
					domains = ApplicationDomain.currentDomain;
					Module_Loader_Cfg["context"] = Current_Domain_Context;
				}
				
				if(info.crypt)
				{
					Module_Loader_Cfg["cryptor"] = Module_Cryptor;
				}
				else
				{
					Module_Loader_Cfg["cryptor"] = null;
				}
				
				info.domain = domains;
				loaders.add(info.file, Module_Loader_Cfg);
				
				ArrayUtil.push(_loadingModuleInfoList, info);
			}
			
			domains = null;
			Module_Loader_Cfg["context"] = null;
			Module_Loader_Cfg["cryptor"] = null;
			
			loaders.addEventListener(JLoaderEvent.Complete, __modulesLoadCompleteHandler, false, int.MAX_VALUE);
			loaders.addEventListener(JLoaderEvent.Complete, __modulesDisposeHandler, false, int.MIN_VALUE);
			
			return loaders;
		}
		
		private static function __modulesLoadCompleteHandler(e:JLoaderEvent):void
		{
			var loader:ILoader;
			
			var loaders:ILoaders = e.currentTarget as ILoaders;
			
			for each(loader in loaders.completeListDic)
			{
				moduleInfoLoadComplete(loader);
			}
			
			for each(loader in loaders.errorListDic)
			{
				moduleInfoLoadError(loader);
			}
		}
		
		private static function __modulesDisposeHandler(e:JLoaderEvent):void
		{
			var loaders:ILoaders = e.currentTarget as ILoaders;
			
			ArrayUtil.remove(_loadersList, loaders);
			loaders.removeEventListener(JLoaderEvent.Complete, __modulesLoadCompleteHandler);
			loaders.removeEventListener(JLoaderEvent.Complete, __modulesDisposeHandler);
			
			DisposeUtil.free(loaders);
			loaders = null;
		}
	}
}