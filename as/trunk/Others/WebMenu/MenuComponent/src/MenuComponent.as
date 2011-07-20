package
{
	import com.loader.BytesLoader;
	import com.managers.CacheManager;
	import com.managers.ModuleManager;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.system.ApplicationDomain;
	
	import vo.ConfigManager;
	import vo.MenuContaint;
	import vo.loader.ConfigLoader;
	
	[SWF(width="1000", height="600",backgroundColor="#000000")]
	public class MenuComponent extends Sprite
	{
		private var menu:MenuContaint;
		private var configList:Array;
		private var configId:String;
		
		public function MenuComponent()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			menu = new MenuContaint();
			addChild(menu);
			
			if(root && root.loaderInfo && root.loaderInfo.parameters)
			{
				var parameters:Object = root.loaderInfo.parameters;
				if(parameters["cid"]) configId = String(parameters["cid"]);
			}
			
			new ConfigLoader("config.xml").loadAsync(configLoadComplete);
		}
		
		private function configLoadComplete(loader:ConfigLoader):void
		{
			ConfigManager.Instance.setup(loader.configList);
			ConfigManager.Instance.select(configId);
			CacheManager.getInstance().setup();
			ModuleManager.getInstance().setup(null, ApplicationDomain.currentDomain);
			
			loadResource();
		}
		
		private function loadResource():void
		{
			ModuleManager.getInstance().loadModuleFile(ConfigManager.Instance.current.file, moduleLoadComplete);
		}
		
		private function moduleLoadComplete(loader:BytesLoader):void
		{
			trace("hasDefinition(assets.menu.BgAsset):" + ModuleManager.getInstance().hasDefinition("assets.menu.BgAsset"));
			
			menu.buildMenu(ConfigManager.Instance.current);
		}
	}
}