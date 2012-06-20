package jsion.core.modules
{
	import flash.events.ProgressEvent;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	
	import jsion.Cache;
	import jsion.core.cryptor.ICryption;
	import jsion.core.cryptor.ModuleCrytor;
	import jsion.core.events.JsionEvent;
	import jsion.core.loader.ILoader;
	import jsion.core.loader.LoaderQueue;
	import jsion.core.loader.SwcLoader;
	import jsion.core.reflection.Assembly;
	import jsion.utils.AppDomainUtil;
	import jsion.utils.ArrayUtil;
	import jsion.utils.DictionaryUtil;
	import jsion.utils.DisposeUtil;
	import jsion.utils.JUtil;
	import jsion.utils.ReflectionUtil;
	import jsion.utils.StringUtil;
	import jsion.utils.XmlUtil;

	/**
	 * 模块管理类
	 * @author Jsion
	 * 
	 */	
	public class ModuleMgr
	{
		private static var Module_Cryptor:ICryption = new ModuleCrytor();
		
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
			var ass:Assembly = getModuleLoadInfo(id).assembly;
			
			if(ass == null)
			{
				ass = new Assembly(getModuleLoadInfo(id).clsList);
				
				getModuleLoadInfo(id).assembly = ass;
			}
			
			return ass;
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
			
			loadInfo.loader = new SwcLoader(loadInfo.moduleInfo.url, m_resRoot);
			
			loadInfo.loader.addEventListener(JsionEvent.COMPLETE, __moduleLoadCompleteHandler, false, int.MAX_VALUE);
			loadInfo.loader.addEventListener(JsionEvent.ERROR, __moduleLoadErrorHandler, false, int.MAX_VALUE);
			loadInfo.loader.addEventListener(ProgressEvent.PROGRESS, __progressHandler, false, int.MAX_VALUE);
			loadInfo.loader.addEventListener(JsionEvent.COMPLETE, __disposeHandler, false, int.MIN_VALUE);
			loadInfo.loader.addEventListener(JsionEvent.ERROR, __disposeHandler, false, int.MIN_VALUE);
			
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
		
		private static function __moduleLoadCompleteHandler(e:JsionEvent):void
		{
			var loader:ILoader = e.currentTarget as ILoader;
			
			moduleLoadComplete(loader);
			
			if(m_loadViewController) m_loadViewController.complete();
		}
		
		private static function __moduleLoadErrorHandler(e:JsionEvent):void
		{
			var loader:ILoader = e.currentTarget as ILoader;
			
			moduleLoadError(loader);
		}
		
		private static function __progressHandler(e:ProgressEvent):void
		{
			if(m_loadViewController) m_loadViewController.progress(e.bytesLoaded, e.bytesTotal);
		}
		
		private static function __disposeHandler(e:JsionEvent):void
		{
			var loader:ILoader = e.currentTarget as ILoader;
			
			loader.removeEventListener(JsionEvent.COMPLETE, __moduleLoadCompleteHandler);
			loader.removeEventListener(JsionEvent.ERROR, __moduleLoadErrorHandler);
			loader.removeEventListener(ProgressEvent.PROGRESS, __progressHandler);
			loader.removeEventListener(JsionEvent.COMPLETE, __disposeHandler);
			loader.removeEventListener(JsionEvent.ERROR, __disposeHandler);
			
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
				//loadInfo.assembly = loader.data as Assembly;
				loadInfo.clsList = loader.data as Array;
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
		private static var moduleLoaders:LoaderQueue;
		private static var loadAutoModuleCallback:Function;
		
		private static var tmpQueue:Array = [];
		private static var embedQueue:Array = [];
		private static var embeding:Boolean = false;
		
		/**
		 * 加载自启动加载模块
		 * @param callback 回调函数
		 */		
		public static function loadAutoLoadModule(callback:Function = null):LoaderQueue
		{
			if(m_autoLoadList.length > 0 && autoLoading == false)
			{
				var loaders:LoaderQueue = new LoaderQueue();
				
				moduleLoaders = loaders;
				
				for each(var loadInfo:ModuleLoadInfo in m_autoLoadList)
				{
					var loader:ILoader = loaders.addFile(loadInfo.moduleInfo.url, m_resRoot);
					loadInfo.loading = true;
					loadInfo.loader = loader;
					m_loadingModule[loader] = loadInfo;
				}
				
				loadAutoModuleCallback = callback;
				
				loaders.addEventListener(JsionEvent.COMPLETE, __modulesLoadCompleteHandler, false, int.MAX_VALUE);
				loaders.addEventListener(JsionEvent.COMPLETE, __modulesDisposeHandler, false, int.MIN_VALUE);
				
				loaders.start();
				autoLoading = true;
			}
			else if(autoLoading == false)
			{
				callback();
			}
			
			return loaders;
		}
		
		private static function __modulesLoadCompleteHandler(e:JsionEvent):void
		{
			var loaders:LoaderQueue = e.currentTarget as LoaderQueue;
			
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
		
		private static function __modulesDisposeHandler(e:JsionEvent):void
		{
			var loaders:LoaderQueue = e.currentTarget as LoaderQueue;
			
			loaders.removeEventListener(JsionEvent.COMPLETE, __modulesLoadCompleteHandler);
			loaders.removeEventListener(JsionEvent.COMPLETE, __modulesDisposeHandler);
			
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
	}
}

/**
 * 模块加载信息类
 * @author Jsion
 * 
 */
class ModuleLoadInfo
{
	import flash.system.ApplicationDomain;
	
	import jsion.core.loader.ILoader;
	import jsion.core.modules.BaseModule;
	import jsion.core.modules.ModuleInfo;
	import jsion.core.reflection.Assembly;
	
	/**
	 * 模块ID
	 */	
	public var id:String;
	
	/**
	 * 模块启动类
	 */	
	public var cls:String;
	
	/**
	 * 模块信息对象
	 */	
	public var moduleInfo:ModuleInfo;
	
	/**
	 * 是否已加载
	 */	
	public var loaded:Boolean;
	
	/**
	 * 是否出错
	 */	
	public var errored:Boolean;
	
	/**
	 * 模块启动类对象
	 */	
	public var module:BaseModule;
	
	/**
	 * 模块所在应用程序域
	 */	
	public var domain:ApplicationDomain;
	
	/**
	 * 模块程序集
	 */	
	public var assembly:Assembly;
	
	/**
	 * 类列表
	 */	
	public var clsList:Array;
	
	/**
	 * 是否正在加载
	 */	
	public var loading:Boolean;
	
	/**
	 * 模块加载器
	 */	
	public var loader:ILoader;
	
	/**
	 * 模块加载完成的回调函数列表
	 */	
	public var callback:Array = [];
}