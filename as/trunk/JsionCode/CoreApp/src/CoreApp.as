package
{
	import flash.display.Sprite;
	
	import jsion.components.List;
	import jsion.components.ListItem;
	import jsion.components.ScrollBar;
	import jsion.components.ScrollPane;
	import jsion.components.Slider;
	import jsion.comps.events.UIEvent;
	import jsion.core.ant.generateCompcDemo;
	
	[SWF(width="1250", height="650", frameRate="30")]
	public class CoreApp extends Sprite
	{
		private var launcher:Launcher;
		
		public function CoreApp()
		{
			launcher = new Launcher(stage);
			
			launcher.launch("config.xml");
			
//			var slider:Slider = new Slider(Slider.VERTICAL);
//			
//			slider.move(10, 100);
//			
//			slider.showRule = true;
//			slider.ruleCount = 5;
////			slider.ruleOffset = -8;
////			slider.barOffset = 8;
//			slider.setBarStyle(Slider.UP_IMG, new SliderBarAsset());
//			slider.height = 100;
//			slider.addEventListener(UIEvent.CHANGE, __changeHandler);
//			
//			addChild(slider);
			
//			var bar:ScrollBar = new ScrollBar(ScrollBar.VERTICAL);
//			
//			bar.setUpOrLeftStyle(ScrollBar.UP_IMG, new ScrollBarUpBtnAsset());
//			bar.setDownOrRightStyle(ScrollBar.UP_IMG, new ScrollBarUpBtnAsset());
//			bar.setBarStyle(ScrollBar.UP_IMG, new ScrollBarThumbAsset());
//			
////			bar.viewSize = 1000;
////			bar.scrollSize = 300;
//			
//			bar.addEventListener(UIEvent.CHANGE, __changeHandler);
//			
//			addChild(bar);
			
//			var scrollPanel:ScrollPane = new ScrollPane(this);
//			
//			scrollPanel.setUpOrLeftStyle(ScrollPane.UP_IMG, new ScrollBarUpBtnAsset());
//			scrollPanel.setDownOrRightStyle(ScrollPane.UP_IMG, new ScrollBarUpBtnAsset());
//			scrollPanel.setBarStyle(ScrollPane.UP_IMG, new ScrollBarThumbAsset());
//			
//			scrollPanel.width = 200;
//			scrollPanel.height = 200;
//			
//			var sprite:Sprite = new Sprite();
//			sprite.graphics.clear();
//			sprite.graphics.beginFill(0x0);
//			sprite.graphics.drawRect(0, 0, 183, 150);
//			sprite.graphics.endFill();
//			sprite.graphics.beginFill(0x336699);
//			sprite.graphics.drawRect(0, 150, 183, 350);
//			sprite.graphics.endFill();
//			
//			scrollPanel.view = sprite;
			
			var list:List = new List(this);
			
			list.setUpOrLeftStyle(ScrollPane.UP_IMG, new ScrollBarUpBtnAsset());
			list.setDownOrRightStyle(ScrollPane.UP_IMG, new ScrollBarUpBtnAsset());
			list.setBarStyle(ScrollPane.UP_IMG, new ScrollBarThumbAsset());
			
			list.width = 200;
			list.height = 200;
			
			for(var i:int = 0; i < 10; i++)
			{
				var sprite:Sprite;
				var item:ListItem;
				
				item = new ListItem("未选", "已选");
				
				sprite = new Sprite();
				sprite.graphics.clear();
				sprite.graphics.beginFill(0xFF0000);
				sprite.graphics.drawRect(0, 0, 183, 25);
				sprite.graphics.endFill();
				item.setSelectedStyle(ListItem.UP_IMG, sprite);
				
				sprite = new Sprite();
				sprite.graphics.clear();
				sprite.graphics.beginFill(0x336699);
				sprite.graphics.drawRect(0, 0, 183, 25);
				sprite.graphics.endFill();
				item.setUnSelectedStyle(ListItem.UP_IMG, sprite);
				
				list.addItem(item);
				
				
				
				
				
				item = new ListItem("未选", "已选");
				
				sprite = new Sprite();
				sprite.graphics.clear();
				sprite.graphics.beginFill(0xFF0000);
				sprite.graphics.drawRect(0, 0, 183, 25);
				sprite.graphics.endFill();
				item.setSelectedStyle(ListItem.UP_IMG, sprite);
				
				sprite = new Sprite();
				sprite.graphics.clear();
				sprite.graphics.beginFill(0x996633);
				sprite.graphics.drawRect(0, 0, 183, 25);
				sprite.graphics.endFill();
				item.setUnSelectedStyle(ListItem.UP_IMG, sprite);
				list.addItem(item);
			}
			
			list.selectedIndex = 15;
			list.scrollToSelected();
			
//			trace(generateCompcDemo("ReleaseSLG", 
//				"C:\\Users\\Jsion\\Desktop\\CompilerDir", 
//				"F:\\SourceCode\\SLGClient", 
//				["F:\\SourceCode\\SLGClient\\SLGAssets\\libs", "F:\\SourceCode\\SLGClient\\SLGAssets\\uis"],
//				[{lib: "SLGCore", output: "SLGCore", sources: "F:\\SourceCode\\SLGClient\\SLGCore"}], 
//				"ref", 
//				"out",
//				"D:\\Program Files\\Adobe\\Adobe Flash Builder 4\\sdks\\4.0.0"));
		}
		
//		private function __changeHandler(e:UIEvent):void
//		{
//			trace(Slider(e.currentTarget).sliderValue.toFixed(2));
//		}
		
		private function __changeHandler(e:UIEvent):void
		{
			trace(ScrollBar(e.currentTarget).scrollValue.toFixed(2));
		}
	}
}