package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import jcomponent.org.coms.buttons.ImageButton;
	import jcomponent.org.coms.buttons.ScaleImageButton;
	import jcomponent.org.mgrs.UIMgr;
	
	import jcore.org.loader.BinaryLoader;
	import jcore.org.message.MessageMonitor;
	
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
			
			UIMgr.setLookAndFeel(new TestLookAndFeel());
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
		
		private function loadCallback(loader:BinaryLoader):void
		{
			//MessageMonitor.createAndPostMsg(1, "JLauncher", ["Promiscuous"], loader.content);
			
//			var si:ScaleImageButton = new ScaleImageButton("缩放按钮");
//			
//			si.setSize(new IntDimension(150, 50));
//			//si.pack();
//			
//			addChild(si);
			
//			var img:ImageButton  = new ImageButton("按钮");
//			
//			img.pack();
//			img.x = 100;
//			img.y = 100;
//			
//			addChild(img);
		}
	}
}