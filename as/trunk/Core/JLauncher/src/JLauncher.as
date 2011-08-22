package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	
	import jcore.org.loader.BinaryLoader;
	import jcore.org.message.MessageMonitor;
	
	import jui.org.coms.img.Scale9Image;
	
	[SWF(width="900", height="600", frameRate="30")]
	public class JLauncher extends Sprite
	{
		private var _launcher:Launcher;
		
		private var _loader:BinaryLoader;
		
		public function JLauncher()
		{
			_launcher = new Launcher(this, "config.xml", JStartup);
			
			_launcher.launch();
			
			stage.addEventListener(MouseEvent.CLICK, onClickHandler);
		}
		
		private function onClickHandler(e:MouseEvent):void
		{
			loadTest();
		}
		
		private function loadTest():void
		{
			_loader = new BinaryLoader("../../JCore/bin/JCore.swc", {rnd: true});
			//_loader = new BinaryLoader("JLauncher.swf", {rnd: true});
			
			_loader.loadAsync(loadCallback);
		}
		
		private var comp:Scale9Image;
		
		private var size:int = 50;
		
		private function loadCallback(loader:BinaryLoader):void
		{
			//MessageMonitor.createAndPostMsg(1, "JLauncher", ["Promiscuous"], loader.content);
			
			if(comp == null)
			{
				comp = new Scale9Image(new TV_ViewAsset(0, 0), new Insets(10, 3, 15, 3));
				addChild(comp);
			}
			else
			{
				comp.setSizeWH(size += 50, size);
			}
			
		}
	}
}