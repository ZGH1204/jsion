package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	import jsion.Insets;
	import jsion.components.Image;
	import jsion.components.JButton;
	import jsion.components.JComboBox;
	import jsion.components.JFocusMgr;
	import jsion.components.JList;
	import jsion.components.JListItem;
	import jsion.components.JScrollBar;
	import jsion.components.JScrollPane;
	import jsion.components.JSlider;
	import jsion.components.JTabPane;
	import jsion.components.JTitleBar;
	import jsion.components.JWindow;
	import jsion.comps.ASColor;
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
			
//			var list:List = new List(this);
//			
//			list.setUpOrLeftStyle(ScrollPane.UP_IMG, new ScrollBarUpBtnAsset());
//			list.setDownOrRightStyle(ScrollPane.UP_IMG, new ScrollBarUpBtnAsset());
//			list.setBarStyle(ScrollPane.UP_IMG, new ScrollBarThumbAsset());
//			
//			list.width = 200;
//			list.height = 200;
//			
//			for(var i:int = 0; i < 10; i++)
//			{
//				var sprite:Sprite;
//				var item:ListItem;
//				
//				item = new ListItem("未选", "已选");
//				
//				sprite = new Sprite();
//				sprite.graphics.clear();
//				sprite.graphics.beginFill(0xFF0000);
//				sprite.graphics.drawRect(0, 0, 183, 25);
//				sprite.graphics.endFill();
//				item.setSelectedStyle(ListItem.UP_IMG, sprite);
//				
//				sprite = new Sprite();
//				sprite.graphics.clear();
//				sprite.graphics.beginFill(0x336699);
//				sprite.graphics.drawRect(0, 0, 183, 25);
//				sprite.graphics.endFill();
//				item.setUnSelectedStyle(ListItem.UP_IMG, sprite);
//				
//				list.addItem(item);
//				
//				
//				
//				
//				
//				item = new ListItem("未选", "已选");
//				
//				sprite = new Sprite();
//				sprite.graphics.clear();
//				sprite.graphics.beginFill(0xFF0000);
//				sprite.graphics.drawRect(0, 0, 183, 25);
//				sprite.graphics.endFill();
//				item.setSelectedStyle(ListItem.UP_IMG, sprite);
//				
//				sprite = new Sprite();
//				sprite.graphics.clear();
//				sprite.graphics.beginFill(0x996633);
//				sprite.graphics.drawRect(0, 0, 183, 25);
//				sprite.graphics.endFill();
//				item.setUnSelectedStyle(ListItem.UP_IMG, sprite);
//				list.addItem(item);
//			}
//			
//			list.selectedIndex = 15;
//			list.scrollToSelected();
			
			
			
//			var combo:ComboBox = new ComboBox(ComboBox.UP);
//			
//			combo.move(10, 200);
//			combo.height = 25;
//			
//			combo.setListStyle(ComboBox.BACKGROUND, new ComboLabelButtonAsset());
//			combo.setListStyle(ComboBox.OFFSET_X, 2);
//			combo.setListStyle(ComboBox.OFFSET_Y, 2);
//			combo.setLabelButtonStyle(ComboBox.UP_IMG, new ComboLabelButtonAsset());
//			combo.setListUpStyle(ComboBox.UP_IMG, new ScrollBarUpBtnAsset());
//			combo.setListDownStyle(ComboBox.UP_IMG, new ScrollBarUpBtnAsset());
//			combo.setListBarStyle(ComboBox.UP_IMG, new ScrollBarThumbAsset());
//			
//			combo.width = 120;
//			combo.listWidth = 120;
//			
//			for(var i:int = 0; i < 20; i += 1)
//			{
//				var sprite:Sprite;
//				var item:ListItem;
//				
//				item = new ListItem("选择" + (i + 1));
//				
//				sprite = new Sprite();
//				sprite.graphics.clear();
//				sprite.graphics.beginFill(0xFF0000);
//				sprite.graphics.drawRect(0, 0, 105, 25);
//				sprite.graphics.endFill();
//				item.setSelectedStyle(ListItem.UP_IMG, sprite);
//				
//				sprite = new Sprite();
//				sprite.graphics.clear();
//				sprite.graphics.beginFill(0x336699);
//				sprite.graphics.drawRect(0, 0, 105, 25);
//				sprite.graphics.endFill();
//				item.setUnSelectedStyle(ListItem.UP_IMG, sprite);
//				
//				combo.addItem(item);
//				
//				
//				
//				
//				
////				item = new ListItem("选择" + (i + 2));
////				
////				sprite = new Sprite();
////				sprite.graphics.clear();
////				sprite.graphics.beginFill(0xFF0000);
////				sprite.graphics.drawRect(0, 0, 105, 25);
////				sprite.graphics.endFill();
////				item.setSelectedStyle(ListItem.UP_IMG, sprite);
////				
////				sprite = new Sprite();
////				sprite.graphics.clear();
////				sprite.graphics.beginFill(0x996633);
////				sprite.graphics.drawRect(0, 0, 105, 25);
////				sprite.graphics.endFill();
////				item.setUnSelectedStyle(ListItem.UP_IMG, sprite);
////				combo.addItem(item);
//			}
//			
//			addChild(combo);
			
//			var tabPane:TabPane = new TabPane();
//			
//			tabPane.addTab(new TabDemo("Tab1", 0x996600));
//			tabPane.addTab(new TabDemo("Tab2", 0x325891));
//			tabPane.addTab(new TabDemo("Tab3", 0xf0a9dd));
//			tabPane.addTab(new TabDemo("Tab4", 0xa5d833));
//			
//			//tabPane.padding = -2;
//			tabPane.btnSpacing = 5;
//			
//			tabPane.width = 680;
//			tabPane.height = 300;
//			
//			tabPane.setActiveTab(0);
//			
//			addChild(tabPane);
			
			JFocusMgr.Instance.setup(stage);
			
//			var win:JWindow = new JWindow("", this, 0, 50);
//			
//			win.title = "测试窗体";
//			win.setStyle(JWindow.BACKGROUND, new ComboLabelButtonAsset());
//			var sprite:Sprite = new Sprite();
//			sprite.graphics.clear();
//			sprite.graphics.beginFill(0xFF0000);
//			sprite.graphics.drawRect(0, 0, 15, 15);
//			sprite.graphics.endFill();
//			win.setCloseStyle(JButton.UP_IMG, sprite);
//			win.setTitleBarStyle(JTitleBar.BACKGROUND, new ComboLabelButtonAsset());
//			win.setTitleLabelStyle(JTitleBar.COLOR, new ASColor(0xFFFFFF));
//			win.titleOffsetY = -25;
//			win.titleWidth = 350;
//			win.width = 350;
//			win.height = 200;
			
			var img:Image = new Image(new ButtonUpImgAsset(0, 0), this);
			
			img.scale9Grids = new Insets(10, 12, 10, 12);
			img.width = 301;
			img.height = 201;
			
//			var bmp:Bitmap = new Bitmap(new ButtonUpImgAsset(0, 0));
//			bmp.x = 300;
//			
//			addChild(bmp);
			
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
			trace(JScrollBar(e.currentTarget).scrollValue.toFixed(2));
		}
	}
}