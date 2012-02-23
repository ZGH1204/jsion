package knightage.loading
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	import jsion.StageRef;
	import jsion.core.Global;
	import jsion.core.events.JLoaderEvent;
	import jsion.core.lang.Local;
	import jsion.core.loaders.ILoader;
	import jsion.core.loaders.ILoaders;
	import jsion.core.loaders.JLoaders;
	import jsion.core.modules.BaseModule;
	import jsion.core.modules.ModuleInfo;
	import jsion.core.modules.ModuleMgr;
	import jsion.utils.AppDomainUtil;
	import jsion.utils.PathUtil;
	import jsion.utils.StringUtil;
	
	import knightage.core.Files;
	import knightage.core.ModuleType;
	
	public class KLoadingModule extends BaseModule
	{
		private static const LoadingBackgroundImageUrl:String = "loadingbg.jpg";
		
		private var displayLoader:Loader;
		
		private var m_resRoot:String;
		
		private var languageFile:String;
		
		
		private var loadingLoaders:ILoaders;
		
		public function KLoadingModule(info:ModuleInfo)
		{
			super(info);
		}
		
		override public function startup():void
		{
			t("startup");
			
			m_resRoot = String(Global.ConfigXml.config.@ResRoot);
			
			languageFile = StringUtil.format(Files.LanguageFile, String(Global.ConfigXml.config.@Language));
			
			displayLoader = new Loader();
			
			var request:URLRequest = new URLRequest(PathUtil.combinPath(m_resRoot, LoadingBackgroundImageUrl));
			displayLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, __backgroundCompleteHandler);
			displayLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, __backgroundErrorHandler);
			displayLoader.load(request);
			StageRef.addChild(displayLoader);
		}
		
		private function __backgroundCompleteHandler(e:Event):void
		{
			displayLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, __backgroundCompleteHandler);
			displayLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, __backgroundErrorHandler);
			
			loadGameLib();
		}
		
		private function __backgroundErrorHandler(e:Event):void
		{
			displayLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, __backgroundCompleteHandler);
			displayLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, __backgroundErrorHandler);
			displayLoader.unloadAndStop();
			displayLoader = null;
			
			throw new Error(e.toString());
		}
		
		private function loadGameLib():void
		{
			loadingLoaders = new JLoaders("KLoadingModuleLoaders");
			
			var loader:ILoader;
			
			loader = ModuleMgr.createModuleLoader(ModuleType.K_COMPS);//"JsionComps");
			loadingLoaders.addLoader(loader);
			
			loader = ModuleMgr.createModuleLoader(ModuleType.K_SOCKET);//"JsionSocket");
			loadingLoaders.addLoader(loader);
			
			loader = ModuleMgr.createModuleLoader(ModuleType.K_CORE);//"KCore");
			loadingLoaders.addLoader(loader);
			
			loader = ModuleMgr.createModuleLoader(ModuleType.K_CITY);//"KCity");
			loadingLoaders.addLoader(loader);
			
			loader = ModuleMgr.createModuleLoader(ModuleType.Debug_Login_Module);//"SLGDebugLogin");
			loadingLoaders.addLoader(loader);
			
			var obj:Object = {root: m_resRoot};
			
			loadingLoaders.add(Files.TemplatesFile, obj);
			loadingLoaders.add(languageFile, obj);
			
			loadingLoaders.addEventListener(JLoaderEvent.EmbedComplete, __loadCompleteHandler);
			
			loadingLoaders.start();
			//loadingLoaders.start(null, loadCallback);
		}
		
		private function __loadCompleteHandler(e:JLoaderEvent):void
		{
			loadingLoaders.removeEventListener(JLoaderEvent.EmbedComplete, __loadCompleteHandler);
			
			//trace("Load complete!");
			
			Local.setup(loadingLoaders.getText(languageFile));
			
			var fn:Function = AppDomainUtil.getDefine(String(Global.ConfigXml.@main)) as Function;
			
			if(fn != null) fn(loadingLoaders);
			
			//if(displayLoader && displayLoader.parent) displayLoader.parent.setChildIndex(displayLoader, displayLoader.parent.numChildren - 1);
		}
		
		private function loadCallback(loader:ILoaders):void
		{
			//trace("Load complete!");
			
			Local.setup(loader.getText(languageFile));
			
			var fn:Function = AppDomainUtil.getDefine(String(Global.ConfigXml.@main)) as Function;
			
			if(fn != null) fn(loader);
			
			//if(displayLoader && displayLoader.parent) displayLoader.parent.setChildIndex(displayLoader, displayLoader.parent.numChildren - 1);
		}
	}
}