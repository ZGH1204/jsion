package
{
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;
	
	[SWF(width="1250", height="650", frameRate="30")]
	public class CoreApp extends Sprite
	{
		private var m_startuper:Startuper;
		
		private var loaders:Object;
		
		public function CoreApp()
		{
			m_startuper = new Startuper(stage);
			
			m_startuper.startup("config.xml", "JsionCore.swf", callback);
		}
		
		private function callback():void
		{
			var cls:Class = ApplicationDomain.currentDomain.getDefinition("jsion.core.loader.LoaderQueue2") as Class;
			
			loaders = new cls();
			
			loaders.addFile("Resources.swc");
			loaders.addFile("config.xml");
			
			loaders.setProgressCallback(progressCallback);
			
			loaders.start(loadCallback);
		}
		
		private function loadCallback(queue:Object):void
		{
			trace("Loader queue load complete!");
		}
		
		private function progressCallback(bytesLoaded:int, bytesTotal:int):void
		{
			trace("bytesLoaded：", bytesLoaded, "  bytesLoaded：", bytesTotal);
		}
	}
}