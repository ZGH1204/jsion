package jsion.core.modules
{
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import jsion.Cache;
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
	import jsion.utils.PathUtil;
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
		
		private static var m_resRoot:String;
		
		/**
		 * 初始化安装
		 * @param config 配置
		 */		
		public static function setup(config:XML):void
		{
			m_resRoot = String(config.config.@ModRoot);
			Module_Loader_Cfg["root"] = m_resRoot;
			Module_Loader_Cfg["urlVariables"] = { v: Cache.version };
			
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
		
		/**
		 * 设置模块加载时的等待界面
		 * @param loadViewController
		 */		
		public static function setLoadingViewController(loadViewController:IModuleLoading):void
		{
			m_loadViewController = loadViewController;
		}
		
		private static function checkModuleInfo(moduleInfo:ModuleInfo):Boolean
		{
			return moduleInfo && StringUtil.isNotNullOrEmpty(moduleInfo.id) && StringUtil.isNotNullOrEmpty(moduleInfo.url);
		}
		
		
		
		
		
		
		
		
		
		
		
		private static function getModuleLoadInfo(id:String):ModuleLoadInfo
		{
			if(m_modules[id]) return ModuleLoadInfo(m_modules[id]);
			
			throw new Error("指定模块不存在! ID：" + id);
			return null;
		}
		
		/**
		 * 指示指定ID的模块是否已加载
		 * @param id 模块ID
		 */		
		public static function hasLoaded(id:String):Boolean
		{
			return getModuleLoadInfo(id).loaded;
		}
		
		/**
		 * 指示指定ID的模块是否加载出错
		 * @param id 模块ID
		 */		
		public static function isErrored(id:String):Boolean
		{
			return getModuleLoadInfo(id).errored;
		}
		
		/**
		 * 获取指定ID的模块启动类的完整类路径
		 * @param id 模块ID
		 */		
		public static function getClassStr(id:String):String
		{
			return getModuleLoadInfo(id).cls;
		}
		
		/**
		 * 获取指定ID的模块信息
		 * @param id 模块ID
		 */		
		public static function getModuleInfo(id:String):ModuleInfo
		{
			return getModuleLoadInfo(id).moduleInfo;
		}
		
		/**
		 * 获取指定ID的模块
		 * @param id 模块ID
		 */		
		public static function getModule(id:String):BaseModule
		{
			return getModuleLoadInfo(id).module;
		}
		
		/**
		 * 获取指定ID的模块的应用程序域
		 * @param id 模块ID
		 */		
		public static function getModuleDomain(id:String):ApplicationDomain
		{
			return getModuleLoadInfo(id).domain;
		}
		
		/**
		 * 获取指定ID的模块的程序集信息
		 * @param id 模块ID
		 */		
		public static function getAssembly(id:String):Assembly
		{
			return getModuleLoadInfo(id).assembly;
		}
		
		
		
		
		
		
		
		
		
		/**
		 * 创建指定ID的模块，并返回该模块。
		 * @param id 模块ID
		 */		
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
		
		/**
		 * 创建并启动指定ID的模块
		 * @param id 模块ID
		 */		
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
		
		/**
		 * 移除指定ID的模块，并返回该模块。
		 * @param id 模块ID
		 */		
		public static function removeModule(id:String):BaseModule
		{
			var loadInfo:ModuleLoadInfo = getModuleLoadInfo(id);
			
			if(loadInfo == null || loadInfo.loaded == false || 
				loadInfo.loading || loadInfo.errored) return null;
			
			var module:BaseModule = loadInfo.module;
			
			loadInfo.module = null;
			
			return module;
		}
		
		/**
		 * 移除并释放指定ID的模块
		 * @param id 模块ID
		 */		
		public static function removeAndFreeModule(id:String):void
		{
			DisposeUtil.free(removeModule(id));
		}
		
		
		
		
		
		
		
		
		/**
		 * 创建指定ID的模块加载器，不会立即进行加载。
		 * @param id 模块ID
		 * @param callback 回调函数
		 */		
		public static function createModuleLoader(id:String, callback:Function = null):ILoader
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
			
			if(callback != null && loadInfo.callback.indexOf(callback) == -1)
				loadInfo.callback.push(callback);
			
			if(loadInfo.loading) return loadInfo.loader;
			
			loadInfo.loading = true;
			
			updateConfig(Module_Loader_Cfg, loadInfo);
			
			loadInfo.loader = new SwcLoader(loadInfo.moduleInfo.url, Module_Loader_Cfg);
			
			Module_Loader_Cfg["cryptor"] = null;
			Module_Loader_Cfg["context"] = null;
			
			loadInfo.loader.addEventListener(JLoaderEvent.EmbedComplete, __moduleLoadCompleteHandler, false, int.MAX_VALUE);
			loadInfo.loader.addEventListener(JLoaderEvent.Error, __moduleLoadErrorHandler, false, int.MAX_VALUE);
			loadInfo.loader.addEventListener(JLoaderProgressEvent.PROGRESS, __progressHandler, false, int.MAX_VALUE);
			loadInfo.loader.addEventListener(JLoaderEvent.EmbedComplete, __disposeHandler, false, int.MIN_VALUE);
			loadInfo.loader.addEventListener(JLoaderEvent.Error, __disposeHandler, false, int.MIN_VALUE);
			
			m_loadingModule[loadInfo.loader] = loadInfo;
			
			return loadInfo.loader;
		}
		
		/**
		 * 加载指定ID的模块，并返回模块加载器，立即开始加载。
		 * @param id 模块ID
		 * @param callback 回调函数
		 */		
		public static function loadModule(id:String, callback:Function = null):ILoader
		{
			var loader:ILoader = createModuleLoader(id, callback);
			
			if(m_loadViewController) m_loadViewController.showLoadingView();
			
			if(loader) loader.loadAsync();
			
			return loader;
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
			
			loader.removeEventListener(JLoaderEvent.EmbedComplete, __moduleLoadCompleteHandler);
			loader.removeEventListener(JLoaderEvent.Error, __moduleLoadErrorHandler);
			loader.removeEventListener(JLoaderProgressEvent.PROGRESS, __progressHandler);
			loader.removeEventListener(JLoaderEvent.EmbedComplete, __disposeHandler);
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
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		private static var autoLoading:Boolean;
		private static var moduleLoaders:ILoaders;
		private static var loadAutoModuleCallback:Function;
		
		private static var tmpQueue:Array = [];
		private static var embedQueue:Array = [];
		private static var embeding:Boolean = false;
		
		/**
		 * 加载自启动加载模块
		 * @param callback 回调函数
		 */		
		public static function loadAutoLoadModule(callback:Function = null):ILoaders
		{
			if(m_autoLoadList.length > 0 && autoLoading == false)
			{
				var loaders:ILoaders = new JLoaders("AutoLoad");
				
				moduleLoaders = loaders;
				
				for each(var loadInfo:ModuleLoadInfo in m_autoLoadList)
				{
					updateConfig(Module_Loader_Cfg, loadInfo);
					
					var loader:ILoader = loaders.add(loadInfo.moduleInfo.url, Module_Loader_Cfg);
					loader.autoEmbed = false;
					loadInfo.loading = true;
					loadInfo.loader = loader;
					m_loadingModule[loader] = loadInfo;
				}
				
				Module_Loader_Cfg["cryptor"] = null;
				Module_Loader_Cfg["context"] = null;
				
				loadAutoModuleCallback = callback;
				
				loaders.addEventListener(JLoaderEvent.EmbedComplete, __modulesLoadCompleteHandler, false, int.MAX_VALUE);
				loaders.addEventListener(JLoaderEvent.EmbedComplete, __modulesDisposeHandler, false, int.MIN_VALUE);
				
				loaders.start();
				autoLoading = true;
			}
			else if(autoLoading == false)
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
			
			for each(var loadInfo:ModuleLoadInfo in m_autoLoadList)
			{
				moduleLoadComplete(loadInfo.loader);
			}
			
//			for each(var loadInfo:ModuleLoadInfo in m_autoLoadList)
//			{
//				if(loadInfo.loader.type == LoaderGlobal.TYPE_SWC || 
//					loadInfo.loader.type == LoaderGlobal.TYPE_LIB)
//				{
//					embedQueue.push(loadInfo);
//				}
//				else
//				{
//					moduleLoadComplete(loadInfo.loader);
//				}
//			}
			
//			startEmbedQueue();
		}
		
		private static function __modulesDisposeHandler(e:JLoaderEvent):void
		{
			var loaders:ILoaders = e.currentTarget as ILoaders;
			
			loaders.removeEventListener(JLoaderEvent.EmbedComplete, __modulesLoadCompleteHandler);
			loaders.removeEventListener(JLoaderEvent.EmbedComplete, __modulesDisposeHandler);
			
//			if(embeding) return;
			
			ArrayUtil.removeAll(m_autoLoadList);
			
			DisposeUtil.free(moduleLoaders);
			moduleLoaders = null;
		}
		
//		private static function startEmbedQueue(l:ILoader = null):void
//		{
//			if(l) tmpQueue.push(l);
//			
//			if(embedQueue.length == 0)
//			{
//				embedComplete();
//				
//				return;
//			}
//			
//			while(embedQueue.length > 0)
//			{
//				var loadInfo:ModuleLoadInfo = embedQueue.shift() as ModuleLoadInfo;
//				
//				if(loadInfo == null || loadInfo.loader == null)
//				{
//					if(embedQueue.length == 0) embedComplete();
//					
//					continue;
//				}
//				
//				embeding = true;
//				
//				loadInfo.loader.embedInDomain(startEmbedQueue);
//				
//				break;
//			}
//		}
//		
//		private static function embedComplete():void
//		{
//			if(embedQueue.length == 0)
//			{
//				autoLoading = false;
//				
//				if(loadAutoModuleCallback != null) loadAutoModuleCallback();
//				
//				loadAutoModuleCallback = null;
//				
//				if(embeding)
//				{
//					embeding = false;
//					
//					ArrayUtil.removeAll(m_autoLoadList);
//					
//					DisposeUtil.free(moduleLoaders);
//					moduleLoaders = null;
//				}
//				
//				while(tmpQueue.length > 0)
//				{
//					var loader:ILoader = tmpQueue.shift() as ILoader;
//					
//					moduleLoadComplete(loader);
//				}
//			}
//		}
		
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