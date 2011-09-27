package jsion.core.modules
{
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import jsion.core.cryptor.ICryption;
	import jsion.core.cryptor.ModuleCrytor;
	import jsion.core.events.JLoaderEvent;
	import jsion.core.events.JLoaderProgressEvent;
	import jsion.core.loaders.ILoader;
	import jsion.core.loaders.ILoaders;
	import jsion.core.loaders.JLoaders;
	import jsion.core.loaders.LoaderGlobal;
	import jsion.core.loaders.SwcLoader;
	import jsion.core.reflection.Assembly;
	import jsion.utils.AppDomainUtil;
	import jsion.utils.ArrayUtil;
	import jsion.utils.DictionaryUtil;
	import jsion.utils.DisposeUtil;
	import jsion.utils.JUtil;
	import jsion.utils.NameUtil;
	import jsion.utils.StringUtil;
	import jsion.utils.XmlUtil;

	public class ModuleMgr
	{
		private static var Module_Cryptor:ICryption = new ModuleCrytor();
		private static var Module_Loader_Cfg:Object = {type: LoaderGlobal.TYPE_SWC, context: null};
		
		private static var m_modules:Dictionary = new Dictionary();
		
		private static var m_loadingModule:Dictionary = new Dictionary();
		
		private static var m_autoLoadList:Array = [];
		
		private static var m_loadViewController:IModuleLoading;
		
		public static function setup(config:XML):void
		{
			var moduleXL:XMLList = config.Modules.Module;
			
			for each(var moduleXml:XML in moduleXL)
			{
				var moduleInfo:ModuleInfo = new ModuleInfo();
				XmlUtil.decodeWithProperty(moduleInfo, moduleXml);
				if(checkModuleInfo(moduleInfo))
				{
					var loadInfo:ModuleLoadInfo = new ModuleLoadInfo();
					
					loadInfo.id = moduleInfo.id;
					loadInfo.cls = moduleInfo.cls;
					loadInfo.moduleInfo = moduleInfo;
					
					if(m_modules[loadInfo.id])
					{
						throw new Error("模块ID不能重复! ID：" + loadInfo.id);
						
						continue;
					}
					
					m_modules[loadInfo.id] = loadInfo;
					
					if(moduleInfo.autoLoad) m_autoLoadList.push(loadInfo);
				}
			}
		}
		
		public static function setLoadingViewController(loadViewController:IModuleLoading):void
		{
			m_loadViewController = loadViewController;
		}
		
		private static function checkModuleInfo(moduleInfo:ModuleInfo):Boolean
		{
			return moduleInfo && StringUtil.isNotNullOrEmpty(moduleInfo.id) && StringUtil.isNotNullOrEmpty(moduleInfo.url);
		}
		
		
		
		
		
		
		internal static function upModuleLoadInfo(module:BaseModule):void
		{
			
		}
		
		
		
		
		
		
		private static function getModuleLoadInfo(id:String):ModuleLoadInfo
		{
			if(m_modules[id]) return ModuleLoadInfo(m_modules[id]);
			
			throw new Error("指定模块不存在! ID：" + id);
			return null;
		}
		
		public static function hasLoaded(id:String):Boolean
		{
			return getModuleLoadInfo(id).loaded;
		}
		
		public static function isErrored(id:String):Boolean
		{
			return getModuleLoadInfo(id).errored;
		}
		
		public static function getClassStr(id:String):String
		{
			return getModuleLoadInfo(id).cls;
		}
		
		public static function getModuleInfo(id:String):ModuleInfo
		{
			return getModuleLoadInfo(id).moduleInfo;
		}
		
		public static function getModule(id:String):BaseModule
		{
			return getModuleLoadInfo(id).module;
		}
		
		public static function getModuleDomain(id:String):ApplicationDomain
		{
			return getModuleLoadInfo(id).domain;
		}
		
		public static function getAssembly(id:String):Assembly
		{
			return getModuleLoadInfo(id).assembly;
		}
		
		
		
		
		
		
		
		
		
		
		public static function createModule(id:String):BaseModule
		{
			var loadInfo:ModuleLoadInfo = getModuleLoadInfo(id);
			
			if(loadInfo == null || loadInfo.loaded == false || 
				loadInfo.loading || loadInfo.errored) return null;
			
			if(loadInfo.module) return loadInfo.module;
			
			var module:BaseModule = AppDomainUtil.create(loadInfo.cls, loadInfo.moduleInfo) as BaseModule;
			
			loadInfo.module = module;
			
			return module;
		}
		
		public static function createAndStartupModule(id:String):void
		{
			var loadInfo:ModuleLoadInfo = getModuleLoadInfo(id);
			
			if(loadInfo == null || loadInfo.loaded == false || 
				loadInfo.loading || loadInfo.errored) return;
			
			if(loadInfo.module) return;
			
			var module:BaseModule = AppDomainUtil.create(loadInfo.cls, loadInfo.moduleInfo) as BaseModule;
			
			loadInfo.module = module;
			
			if(module) module.startup();
		}
		
		public static function removeModule(id:String):BaseModule
		{
			var loadInfo:ModuleLoadInfo = getModuleLoadInfo(id);
			
			if(loadInfo == null || loadInfo.loaded == false || 
				loadInfo.loading || loadInfo.errored) return null;
			
			var module:BaseModule = loadInfo.module;
			
			loadInfo.module = null;
			
			return module;
		}
		
		public static function removeAndFreeModule(id:String):void
		{
			DisposeUtil.free(removeModule(id));
		}
		
		
		
		
		
		
		
		
		
		public static function loadModule(id:String, callback:Function = null):ILoader
		{
			var loadInfo:ModuleLoadInfo = getModuleLoadInfo(id);
			
			if(loadInfo == null)
			{
				throw new Error("指定模块不存在!");
				return null;
			}
			
			if(loadInfo.loaded)
			{
				callback();
				return null;
			}
			
			if(loadInfo.callback.indexOf(callback) == -1)
				loadInfo.callback.push(callback);
			
			if(loadInfo.loading) return loadInfo.loader;
			
			loadInfo.loading = true;
			
			loadInfo.loader = new SwcLoader(loadInfo.moduleInfo.url, Module_Loader_Cfg);
			
			loadInfo.loader.addEventListener(JLoaderEvent.Complete, __moduleLoadCompleteHandler, false, int.MAX_VALUE);
			loadInfo.loader.addEventListener(JLoaderEvent.Error, __moduleLoadErrorHandler, false, int.MAX_VALUE);
			loadInfo.loader.addEventListener(JLoaderProgressEvent.Progress, __progressHandler, false, int.MAX_VALUE);
			loadInfo.loader.addEventListener(JLoaderEvent.Complete, __disposeHandler, false, int.MIN_VALUE);
			loadInfo.loader.addEventListener(JLoaderEvent.Error, __disposeHandler, false, int.MIN_VALUE);
			
			m_loadingModule[loadInfo.loader] = loadInfo;
			
			if(m_loadViewController) m_loadViewController.showLoadingView();
			
			loadInfo.loader.loadAsync();
			
			return loadInfo.loader;
		}
		
		private static function __moduleLoadCompleteHandler(e:JLoaderEvent):void
		{
			var loader:ILoader = e.currentTarget as ILoader;
			
			moduleLoadComplete(loader);
			
			if(m_loadViewController) m_loadViewController.complete();
		}
		
		private static function __moduleLoadErrorHandler(e:JLoaderEvent):void
		{
			var loader:ILoader = e.currentTarget as ILoader;
			
			moduleLoadError(loader);
		}
		
		private static function __progressHandler(e:JLoaderProgressEvent):void
		{
			if(m_loadViewController) m_loadViewController.progress(e.bytesLoaded, e.bytesTotal);
		}
		
		private static function __disposeHandler(e:JLoaderEvent):void
		{
			var loader:ILoader = e.currentTarget as ILoader;
			
			loader.removeEventListener(JLoaderEvent.Complete, __moduleLoadCompleteHandler);
			loader.removeEventListener(JLoaderEvent.Error, __moduleLoadErrorHandler);
			loader.removeEventListener(JLoaderProgressEvent.Progress, __progressHandler);
			loader.removeEventListener(JLoaderEvent.Complete, __disposeHandler);
			loader.removeEventListener(JLoaderEvent.Error, __disposeHandler);
			
			if(m_loadingModule[loader])
			{
				var loadInfo:ModuleLoadInfo = ModuleLoadInfo(m_loadingModule[loader]);
				
				loadInfo.loader = null;
				
				ArrayUtil.removeAll(loadInfo.callback);
				
				DictionaryUtil.delKey(m_loadingModule, loader);
			}
			
			DisposeUtil.free(loader);
			loader = null;
		}
		
		private static function moduleLoadComplete(loader:ILoader):void
		{
			if(m_loadingModule[loader])
			{
				var loadInfo:ModuleLoadInfo = ModuleLoadInfo(m_loadingModule[loader]);
				
				loadInfo.loaded = true;
				loadInfo.errored = false;
				loadInfo.loading = false;
				loadInfo.assembly = loader.content as Assembly;
				AppDomainUtil.registeAppDomain(loadInfo.domain);
				
				
				createAndStartupModule(loadInfo.id);
				
				
//				var cls:Class = AppDomainUtil.getClass(loadInfo.moduleInfo.cls);
//				
//				if(cls)
//				{
//					loadInfo.module = new cls(loadInfo.moduleInfo);
//					
//					loadInfo.module.startup();
//				}
				
				for each(var fn:Function in loadInfo.callback)
				{
					fn();
				}
			}
		}
		
		private static function moduleLoadError(loader:ILoader):void
		{
			if(m_loadingModule[loader])
			{
				var loadInfo:ModuleLoadInfo = ModuleLoadInfo(m_loadingModule[loader]);
				
				loadInfo.loaded = true;
				loadInfo.errored = true;
				loadInfo.loading = false;
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		private static var moduleLoaders:ILoaders;
		private static var loadAutoModuleCallback:Function;
		
		public static function loadAutoLoadModule(callback:Function = null):ILoaders
		{
			if(m_autoLoadList.length > 0)
			{
				var loaders:ILoaders = new JLoaders("AutoLoad");
				
				moduleLoaders = loaders;
				
				for each(var loadInfo:ModuleLoadInfo in m_autoLoadList)
				{
					updateConfig(Module_Loader_Cfg, loadInfo);
					
					var loader:ILoader = loaders.add(loadInfo.moduleInfo.url, Module_Loader_Cfg);
					
					loadInfo.loading = true;
					loadInfo.loader = loader;
					m_loadingModule[loader] = loadInfo;
				}
				
				Module_Loader_Cfg["cryptor"] = null;
				Module_Loader_Cfg["context"] = null;
				
				loadAutoModuleCallback = callback;
				
				loaders.addEventListener(JLoaderEvent.Complete, __modulesLoadCompleteHandler, false, int.MAX_VALUE);
				loaders.addEventListener(JLoaderEvent.Complete, __modulesDisposeHandler, false, int.MIN_VALUE);
				
				loaders.start();
			}
			else
			{
				callback();
			}
			
			return loaders;
		}
		
		private static function __modulesLoadCompleteHandler(e:JLoaderEvent):void
		{
			var loaders:ILoaders = e.currentTarget as ILoaders;
			
			if(loaders.hasError)
			{
				throw new Error("加载出现错误!");
				return;
			}
			
			var loader:ILoader;
			
			for each(var loadInfo:ModuleLoadInfo in m_autoLoadList)
			{
				moduleLoadComplete(loadInfo.loader);
			}
			
			if(loadAutoModuleCallback != null) loadAutoModuleCallback();
			loadAutoModuleCallback = null;
		}
		
		private static function __modulesDisposeHandler(e:JLoaderEvent):void
		{
			var loaders:ILoaders = e.currentTarget as ILoaders;
			
			loaders.removeEventListener(JLoaderEvent.Complete, __modulesLoadCompleteHandler);
			loaders.removeEventListener(JLoaderEvent.Complete, __modulesDisposeHandler);
			
			ArrayUtil.removeAll(m_autoLoadList);
			
			DisposeUtil.free(moduleLoaders);
			moduleLoaders = null;
			loaders = null;
		}
		
		private static function updateConfig(cfg:Object, loadInfo:ModuleLoadInfo):void
		{
			if(loadInfo.moduleInfo.crypted)
			{
				cfg["cryptor"] = Module_Cryptor;
			}
			else
			{
				cfg["cryptor"] = null;
			}
			
			var context:LoaderContext = null;
			var domain:ApplicationDomain = null;
			
			if(loadInfo.moduleInfo.target == ModuleTarget.Blank)
			{
				domain = JUtil.createNewDomain();
				context = JUtil.createContext(domain);
				AppDomainUtil.registeAppDomain(context.applicationDomain);
			}
			else if(loadInfo.moduleInfo.target == ModuleTarget.Child)
			{
				domain = JUtil.createChildDomain();
				context = JUtil.createContext(domain);
				AppDomainUtil.registeAppDomain(context.applicationDomain);
			}
			else
			{
				domain = JUtil.createCurrentDomain();
				context = JUtil.createContext(domain);
			}
			
			loadInfo.domain = domain;
			
			cfg["context"] = context;
		}
	}
}

class ModuleLoadInfo
{
	import flash.system.ApplicationDomain;
	
	import jsion.core.loaders.ILoader;
	import jsion.core.modules.BaseModule;
	import jsion.core.modules.ModuleInfo;
	import jsion.core.reflection.Assembly;
	
	public var id:String;
	
	public var cls:String;
	
	public var moduleInfo:ModuleInfo;
	
	public var loaded:Boolean;
	
	public var errored:Boolean;
	
	public var module:BaseModule;
	
	public var domain:ApplicationDomain;
	
	public var assembly:Assembly;
	
	public var loading:Boolean;
	
	public var loader:ILoader;
	
	public var callback:Array = [];
}