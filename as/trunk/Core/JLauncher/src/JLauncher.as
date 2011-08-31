package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import jcomponent.org.basic.UIConstants;
	import jcomponent.org.coms.buttons.AbstractButton;
	import jcomponent.org.coms.buttons.ButtonGroup;
	import jcomponent.org.coms.buttons.CheckBox;
	import jcomponent.org.coms.buttons.ImageButton;
	import jcomponent.org.coms.buttons.RadioButton;
	import jcomponent.org.coms.buttons.ScaleImageButton;
	import jcomponent.org.coms.buttons.ScaleToggleButton;
	import jcomponent.org.coms.buttons.ToggleButton;
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
		
		private var btn:AbstractButton;
		
		private var bg:ButtonGroup;
		
		private function loadCallback(loader:BinaryLoader):void
		{
			//MessageMonitor.createAndPostMsg(1, "JLauncher", ["Promiscuous"], loader.content);
			
//			if(bg) return;
//			
//			bg = new ButtonGroup();
//			
//			var yy:int = 0;
//			
//			for(var i:int = 0; i < 7; i++)
//			{
//				btn = new CheckBox("是否保存", CheckBox.BOTTOM);
//				
////				CheckBox(btn).textHGap = 10;
////				CheckBox(btn).boxHGap = 10;
//				btn.horizontalTextAlginment = CheckBox.CENTER;
//				btn.verticalTextAlginment = CheckBox.BOTTOM;
////				btn.setSizeWH(300, 35);
//				btn.pack();
//				btn.y = yy;
//				
//				yy += btn.height + 10;
//				
//				bg.append(btn);
//				
//				addChild(btn);
//			}
			
			if(btn) return;
			
			btn = new RadioButton("RadioBtn");
			
			btn.pack();
			
			addChild(btn);
			
//			btn = new CheckBox("是否保存");
//			
//			CheckBox(btn).textHGap = 0;
////			CheckBox(btn).boxHGap = 5;
////			btn.horizontalTextAlginment = AbstractButton.CENTER;
//			//btn.verticalTextAlginment = AbstractButton.TOP;
//			//btn.setSizeWH(300, 100);
//			btn.pack();
//			
//			addChild(btn);
			
//			btn = new ScaleToggleButton("缩放状态");
//			
//			btn.setSizeWH(150, 60);
//			//btn.pack();
//			
//			addChild(btn);
			
//			btn = new ToggleButton("状态按钮");
//			
//			//btn.setSizeWH(150, 50);
//			btn.pack();
//			
//			addChild(btn);
			
//			btn = new ScaleImageButton("缩放按钮");
//			
//			btn.setSize(new IntDimension(150, 50));
//			//btn.pack();
//			
//			addChild(btn);
			
//			btn  = new ImageButton("按钮");
//			
//			btn.pack();
//			btn.x = 100;
//			btn.y = 100;
//			
//			addChild(btn);
		}
	}
}