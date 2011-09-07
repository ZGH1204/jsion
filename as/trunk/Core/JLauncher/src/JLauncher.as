package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import jcomponent.org.basic.Container;
	import jcomponent.org.coms.buttons.AbstractButton;
	import jcomponent.org.coms.buttons.ButtonGroup;
	import jcomponent.org.coms.buttons.CheckBox;
	import jcomponent.org.coms.buttons.ScaleImageButton;
	import jcomponent.org.coms.containers.Frame;
	import jcomponent.org.coms.containers.VBox;
	import jcomponent.org.coms.containers.Window;
	import jcomponent.org.coms.scrollbars.AbstractScrollBar;
	import jcomponent.org.coms.scrollbars.HScrollBar;
	import jcomponent.org.coms.scrollbars.VScrollBar;
	import jcomponent.org.mgrs.UIMgr;
	
	import jcore.org.loader.BinaryLoader;
	import jcore.org.tweens.TweenMax;
	
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
		
		private var hBox:Container;
		
		private var btn:AbstractButton;
		
		private var bg:ButtonGroup;
		
		private var win:Window;
		
		private var bar:AbstractScrollBar;
		
		private function loadCallback(loader:BinaryLoader):void
		{
			//MessageMonitor.createAndPostMsg(1, "JLauncher", ["Promiscuous"], loader.content);
			
			if(bar) return;
			
			bar = new HScrollBar();
			bar.setLocationXY(100, 50);
			bar.width = 350;
			//bar.height = 350;
			//bar.pack();
			bar.scrollLength = 1000;
			//bar.maximum = 100;
			//bar.value = 100;
			//bar.enabled = false;
			addChild(bar);
			
//			if(win) return;
//			
//			win = new Frame("Frame面板");
//			
//			win.x = win.y = 100;
//			win.setSizeWH(500, 400);
//			//win.pack();
//			
//			win.show();
			
//			win = new Window("窗口面板");
//			
//			win.x = win.y = 100;
//			win.setSizeWH(500, 400);
//			//win.pack();
//			
//			win.show();
			//addChild(win);
			
//			if(hBox == null)
//			{
//				hBox = new VBox(5);
//				addChild(hBox);
//			}
//			
//			if(bg) return;
//			
//			bg = new ButtonGroup();
//			
//			for(var i:int = 0; i < 7; i++)
//			{
//				btn = new CheckBox("是否保存", CheckBox.LEFT);
//				
////				CheckBox(btn).textHGap = 10;
////				CheckBox(btn).boxHGap = 10;
////				btn.horizontalTextAlginment = CheckBox.CENTER;
////				btn.verticalTextAlginment = CheckBox.BOTTOM;
////				btn.setSizeWH(300, 35);
//				
//				btn.pack();
//				
//				bg.append(btn);
//				
//				hBox.addChild(btn);
//			}
//			
//			hBox.x = 100;
//			hBox.y = 40;
//			hBox.alpha = 0;
//			TweenMax.to(hBox, 0.5, {y: 20, alpha: 1});
			
//			if(btn) return;
			
//			btn = new RadioButton("RadioBtn");
//			
//			btn.pack();
//			
//			hBox.addChild(btn);
			
//			btn = new CheckBox("是否保存");
//			
//			CheckBox(btn).textHGap = 0;
////			CheckBox(btn).boxHGap = 5;
////			btn.horizontalTextAlginment = AbstractButton.CENTER;
//			//btn.verticalTextAlginment = AbstractButton.TOP;
//			//btn.setSizeWH(300, 100);
//			btn.pack();
//			
//			hBox.addChild(btn);
			
//			btn = new ScaleToggleButton("缩放状态");
//			
//			btn.setSizeWH(150, 60);
//			//btn.pack();
//			
//			hBox.addChild(btn);
			
//			btn = new ToggleButton("状态按钮");
//			
//			//btn.setSizeWH(150, 50);
//			btn.pack();
//			
//			hBox.addChild(btn);
			
//			btn = new ScaleImageButton("缩放按钮");
//			
//			btn.setSize(new IntDimension(150, 80));
//			//btn.pack();
//			
//			hBox.addChild(btn);
			
//			btn  = new ImageButton("按钮");
//			
//			//btn.setSizeWH(100, 100);
//			btn.pack();
//			btn.x = 100;
//			btn.y = 100;
//			
//			hBox.addChild(btn);
		}
	}
}