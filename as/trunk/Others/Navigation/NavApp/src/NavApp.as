package
{
	import com.LibSetup;
	import com.interfaces.ILoader;
	import com.loader.LoaderCollection;
	import com.loader.ModuleLoader;
	import com.loader.XmlLoader;
	import com.utils.DisposeHelper;
	import com.utils.StringHelper;
	
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.system.Security;
	
	import jsion.NavConfigMgr;
	import jsion.ProvinceMgr;
	
	[SWF(width="650", height="490", backgroundColor="#000000", frameRate="25")]
	public class NavApp extends Sprite
	{
		private var dragLayer:Sprite = new Sprite();
		private var _loaderList:LoaderCollection;
		
		private var _assetConfig:XML;
		
		public function NavApp()
		{
			scrollRect = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			new XmlLoader("config.xml").loadAsync(configLoadCallback);
		}
		
		private function configLoadCallback(loader:XmlLoader):void
		{
			if(loader.isSuccess == false) return;
			
			LibSetup.setup(stage, dragLayer, true, null, loader.xmlData);
			stage.scaleMode = StageScaleMode.SHOW_ALL;
			stage.align = "";
			
			//加载跨域安全策略文件
			var xl:XMLList = loader.xmlData.POLICY_FILES..file;
			for each(var xml:XML in xl)
			{
				Security.loadPolicyFile(String(xml.@value));
			}
			
			_loaderList = new LoaderCollection();
			
			var assetFilesXL:XMLList = loader.xmlData.AssetFiles;
			
			for each(var assetFileXml:XML in assetFilesXL)
			{
				var configFile:String = String(assetFileXml.@Config);
				var configScale:Number = Number(assetFileXml.@ConfigScale);
				if(StringHelper.isNullOrEmpty(configFile)) return;
				
				var iloader:ILoader = new XmlLoader(configFile);
				iloader.loadAsync(assetConfigLoadCallback);
				
				_loaderList.addLoader(iloader, configScale);
				
				var filesXL:XMLList = assetFileXml.File;
				for each(var fileXml:XML in filesXL)
				{
					var url:String = String(fileXml.@Url);
					if(StringHelper.isNullOrEmpty(configFile)) continue;
					var scale:Number = Number(fileXml.@Scale);
					
					iloader = new ModuleLoader(url, ApplicationDomain.currentDomain);
					_loaderList.addLoader(iloader, scale);
				}
				_loaderList.startLoad(listLoadCallback);
				break;
			}
		}
		
		private function assetConfigLoadCallback(loader:XmlLoader):void
		{
			if(loader.isSuccess)
			{
				_assetConfig = loader.xmlData;
			}
		}
		
		private function listLoadCallback():void
		{
			if(_assetConfig == null) return;
			
			NavConfigMgr.Instance.setup(_assetConfig);
			_assetConfig = null;
			
			DisposeHelper.dispose(_loaderList);
			_loaderList = null;
			
			ProvinceMgr.Instance.setup(this);
			
			ProvinceMgr.Instance.showProvinceView(NavConfigMgr.Instance.current);
		}
	}
}