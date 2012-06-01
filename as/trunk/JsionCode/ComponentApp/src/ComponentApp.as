package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	
	import jsion.Insets;
	import jsion.comps.ToggleGroup;
	import jsion.debug.DEBUG;
	import jsion.display.CheckBox;
	import jsion.display.ComboBox;
	import jsion.display.Image;
	import jsion.display.LabelButton;
	import jsion.display.List;
	import jsion.display.ProgressBar;
	import jsion.display.ScrollBar;
	import jsion.display.ScrollPanel;
	import jsion.display.Slider;
	import jsion.display.TabPanel;
	import jsion.display.ToggleButton;
	import jsion.events.DisplayEvent;
	
	[SWF(width="1000", height="650", frameRate="30")]
	public class ComponentApp extends Sprite
	{
		[Embed(source="pic.png")]
		private var m_cls:Class;
		[Embed(source="pic2.png")]
		private var m_cls2:Class;
		
		[Embed(source="checkbox.png")]
		private var m_checkCls:Class;
		[Embed(source="checkbox2.png")]
		private var m_checkCls2:Class;
		
		
		[Embed(source="ScrollUpUpImage.jpg")]
		private var m_scrollUpBtnUpAssetCLS:Class;
		[Embed(source="ScrollUpOverImage.jpg")]
		private var m_scrollUpBtnOverAssetCLS:Class;
		
		[Embed(source="ScrollDownUpImage.jpg")]
		private var m_scrollDownBtnUpAssetCLS:Class;
		[Embed(source="ScrollDownOverImage.jpg")]
		private var m_scrollDownBtnOverAssetCLS:Class;
		
		[Embed(source="ScrollBarImage.jpg")]
		private var m_scrollBarUpAssetCLS:Class;
		
		[Embed(source="ScrollBackgroundImage.jpg")]
		private var m_backgroundAssetCLS:Class;
		
		[Embed(source="progressbg.png")]
		private var m_progressBGCLS:Class;
		
		[Embed(source="progressbar.png")]
		private var m_progressBarCLS:Class;
		
		[Embed(source="progressbg2.png")]
		private var m_progressBGCLS2:Class;
		
		[Embed(source="progressbar2.png")]
		private var m_progressBarCLS2:Class;
		
		[Embed(source="sliderbar.png")]
		private var m_sliderBarCLS:Class;
		
		public function ComponentApp()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			initHelper();
			
//			testImage();
//			
//			testLabelButton();
//			
//			testToggleButton();
//			
//			testCheckBox();
//			
//			testScrollBar();
//			
//			testScrollPanel();
//			
//			testList();
//			
//			testComboBox();
//			
//			testProgressBar();
//			
//			testSliderBar();
			
			testTabPanel();
		}
		
		private function initHelper():void
		{
			DEBUG.setup(stage, 300);
			
			DEBUG.loadCSS("debug.css");
		}
		
		private function testTabPanel():void
		{
			// TODO Auto Generated method stub
			var tab:TabPanel;
			
			tab = new TabPanel();
			tab.beginChanges();
			tab.x = 150;
			tab.y = 30;
			tab.tabGap = -8;
			tab.tabOffset = -5;
			//tab.paneAutoFree = true;
			for(var i:int = 0; i < 5; i++)
			{
				var toggleBtn:ToggleButton = new ToggleButton();
				toggleBtn.beginChanges();
				toggleBtn.x = 80;
				toggleBtn.y = 100;
				
				toggleBtn.upImage = new m_cls();
				toggleBtn.overFilters = [new BlurFilter(2, 2, 1)];
				
				toggleBtn.selectedUpImage = new m_cls2();
				toggleBtn.selectedOverFilters = [new BlurFilter(2, 2, 1)];
				
				toggleBtn.parseCSS("j{display: inline; color: #FFFFFF;} s{display: inline; color: #FFFF00;}");
				toggleBtn.label = "To<j>gg</j><s>le" + i + "</s>";
				toggleBtn.labelColor = 0xFF8040;
				toggleBtn.selectedLabelColor = 0x01;
				toggleBtn.labelOverFilters = [new BlurFilter(2, 2, 1)];
				toggleBtn.selectedLabelOverFilters = [new BlurFilter(2, 2, 1)];
				toggleBtn.commitChanges();
				
				tab.addTab(toggleBtn, TestPanel);
			}
			tab.commitChanges();
			
//			tab = new TabPanel(TabPanel.DOWN);
//			tab.beginChanges();
//			tab.x = 150;
//			tab.y = 30;
//			tab.tabGap = -8;
//			tab.tabOffset = -5;
//			//tab.paneAutoFree = true;
//			tab.width = 700;
//			tab.height = 541;
//			for(var i:int = 0; i < 5; i++)
//			{
//				var toggleBtn:ToggleButton = new ToggleButton();
//				toggleBtn.beginChanges();
//				toggleBtn.x = 80;
//				toggleBtn.y = 100;
//				
//				toggleBtn.upImage = new m_cls();
//				toggleBtn.overFilters = [new BlurFilter(2, 2, 1)];
//				
//				toggleBtn.selectedUpImage = new m_cls2();
//				toggleBtn.selectedOverFilters = [new BlurFilter(2, 2, 1)];
//				
//				toggleBtn.parseCSS("j{display: inline; color: #FFFFFF;} s{display: inline; color: #FFFF00;}");
//				toggleBtn.label = "To<j>gg</j><s>le" + i + "</s>";
//				toggleBtn.labelColor = 0xFF8040;
//				toggleBtn.selectedLabelColor = 0x01;
//				toggleBtn.labelOverFilters = [new BlurFilter(2, 2, 1)];
//				toggleBtn.selectedLabelOverFilters = [new BlurFilter(2, 2, 1)];
//				toggleBtn.commitChanges();
//				
//				tab.addTab(toggleBtn, TestPanel);
//			}
//			tab.commitChanges();
			
//			tab = new TabPanel(TabPanel.LEFT);
//			tab.beginChanges();
//			tab.x = 150;
//			tab.y = 30;
//			tab.tabAlign = TabPanel.BOTTOM;
//			//tab.tabGap = 0;
//			tab.tabOffset = -3;
//			tab.paneOffset = -3;
//			//tab.paneAutoFree = true;
//			tab.width = 765;
//			tab.height = 500;
//			for(var i:int = 0; i < 5; i++)
//			{
//				var toggleBtn:ToggleButton = new ToggleButton();
//				toggleBtn.beginChanges();
//				toggleBtn.x = 80;
//				toggleBtn.y = 100;
//				
//				toggleBtn.upImage = new m_cls();
//				toggleBtn.overFilters = [new BlurFilter(2, 2, 1)];
//				
//				toggleBtn.selectedUpImage = new m_cls2();
//				toggleBtn.selectedOverFilters = [new BlurFilter(2, 2, 1)];
//				
//				toggleBtn.parseCSS("j{display: inline; color: #FFFFFF;} s{display: inline; color: #FFFF00;}");
//				toggleBtn.label = "To<j>gg</j><s>le" + i + "</s>";
//				toggleBtn.labelColor = 0xFF8040;
//				toggleBtn.selectedLabelColor = 0x01;
//				toggleBtn.labelOverFilters = [new BlurFilter(2, 2, 1)];
//				toggleBtn.selectedLabelOverFilters = [new BlurFilter(2, 2, 1)];
//				toggleBtn.commitChanges();
//				
//				tab.addTab(toggleBtn, TestPanel);
//			}
//			tab.commitChanges();
			
//			tab = new TabPanel(TabPanel.RIGHT);
//			tab.beginChanges();
//			tab.x = 150;
//			tab.y = 30;
//			tab.tabAlign = TabPanel.BOTTOM;
//			//tab.tabGap = 0;
//			tab.tabOffset = -3;
//			tab.paneOffset = 3;
//			//tab.paneAutoFree = true;
//			tab.width = 765;
//			tab.height = 500;
//			for(var i:int = 0; i < 5; i++)
//			{
//				var toggleBtn:ToggleButton = new ToggleButton();
//				toggleBtn.beginChanges();
//				toggleBtn.x = 80;
//				toggleBtn.y = 100;
//				
//				toggleBtn.upImage = new m_cls();
//				toggleBtn.overFilters = [new BlurFilter(2, 2, 1)];
//				
//				toggleBtn.selectedUpImage = new m_cls2();
//				toggleBtn.selectedOverFilters = [new BlurFilter(2, 2, 1)];
//				
//				toggleBtn.parseCSS("j{display: inline; color: #FFFFFF;} s{display: inline; color: #FFFF00;}");
//				toggleBtn.label = "To<j>gg</j><s>le" + i + "</s>";
//				toggleBtn.labelColor = 0xFF8040;
//				toggleBtn.selectedLabelColor = 0x01;
//				toggleBtn.labelOverFilters = [new BlurFilter(2, 2, 1)];
//				toggleBtn.selectedLabelOverFilters = [new BlurFilter(2, 2, 1)];
//				toggleBtn.commitChanges();
//				
//				tab.addTab(toggleBtn, TestPanel);
//			}
//			tab.commitChanges();
			
			addChild(tab);
		}
		
		private function testSliderBar():void
		{
			var slider:Slider;
			
			slider = new Slider();
			slider.beginChanges();
			slider.x = 700;
			slider.y = 100;
			slider.barOffsetX = 5;
			slider.barOffsetY = -1
			slider.background = new m_progressBGCLS();
			slider.upImage = new m_sliderBarCLS();
			slider.filler = new m_progressBarCLS();
			slider.value = 50;
			slider.commitChanges();
			slider.addEventListener(DisplayEvent.CHANGED, __sliderValueChangedHandler);
			addChild(slider);
			
			
//			slider = new Slider(Slider.VERTICAL);
//			slider.beginChanges();
//			slider.x = 700;
//			slider.y = 100;
//			slider.barOffsetX = 0;
//			slider.barOffsetY = 5;
//			slider.background = new m_progressBGCLS2();
//			slider.upImage = new m_sliderBarCLS();
//			slider.filler = new m_progressBarCLS2();
//			slider.value = 50;
//			slider.commitChanges();
//			slider.addEventListener(DisplayEvent.CHANGED, __sliderValueChangedHandler);
//			addChild(slider);
		}
		
		private function __sliderValueChangedHandler(e:DisplayEvent):void
		{
			trace(e.currentTarget.value);
		}
		
		private function testProgressBar():void
		{
			var progress:ProgressBar;
			
			progress = new ProgressBar();
			progress.beginChanges();
			progress.x = 580;
			progress.y = 100;
			progress.background = new m_progressBGCLS();
			progress.progressBar = new m_progressBarCLS();
			progress.commitChanges();
			progress.addEventListener(Event.ENTER_FRAME, __progressEnterFrameHandler);
			addChild(progress);
			
			
			
//			progress = new ProgressBar(ProgressBar.VERTICAL);
//			progress.beginChanges();
//			progress.x = 580;
//			progress.y = 100;
//			progress.background = new m_progressBGCLS2();
//			progress.progressBar = new m_progressBarCLS2();
//			progress.commitChanges();
//			progress.addEventListener(Event.ENTER_FRAME, __progressEnterFrameHandler);
//			addChild(progress);
			
		}
		
		private function __progressEnterFrameHandler(e:Event):void
		{
			var progress:ProgressBar = e.currentTarget as ProgressBar;
			
			if(progress.value >= progress.maxValue)
			{
				progress.removeEventListener(Event.ENTER_FRAME, __progressEnterFrameHandler);
			}
			
			progress.value += 0.5;
		}
		
		private function testComboBox():void
		{
			var bmp:Bitmap = new m_scrollBarUpAssetCLS();
			
			
			var img:Image = new Image();
			
			img.beginChanges();
			img.source = bmp.bitmapData;
			img.scale9Insets = new Insets(5, 0, 5, 0);
			img.commitChanges();
			
			var img2:Image = new Image();
			
			img2.beginChanges();
			img2.source = Bitmap(new m_cls()).bitmapData;
			img2.scale9Insets = new Insets(10, 10, 10, 10);
			img2.commitChanges();
			
			var cssTest:String = "j{display: inline; color: #FFFFFF;} s{display: inline; color: #FFFF00;}";
			
			var combo:ComboBox = new ComboBox();
			
			combo.beginChanges();
			combo.x = 500;
			combo.y = 100;
			combo.upImage = new m_cls();
			combo.scrollBarBackground = Bitmap(new m_backgroundAssetCLS()).bitmapData;
			combo.UpOrLeftBtnUpAsset = new m_scrollUpBtnUpAssetCLS();
			combo.UpOrLeftBtnOverAsset = new m_scrollUpBtnOverAssetCLS();
			combo.DownOrRightBtnUpAsset = new m_scrollDownBtnUpAssetCLS();
			combo.DownOrRightBtnOverAsset = new m_scrollDownBtnOverAssetCLS();
			combo.BarUpAsset = img;
			combo.listItemGap = -5;
			combo.listWidth = 80;
			combo.parseCSS(cssTest);
			combo.listBackground = img2;
			combo.listBackgroundHGap = 10;
			combo.listBackgroundVGap = 10;
			combo.overFilters = [new ColorMatrixFilter([1, 0, 0, 0, 25,   0, 1, 0, 0, 25,   0, 0, 1, 0, 25,   0, 0, 0, 1, 0])];
			for(var i:int = 0; i < 100; i++)
			{
				var toggleBtn:ToggleButton;
				
				toggleBtn = new ToggleButton();
				toggleBtn.beginChanges();
				
				toggleBtn.upImage = new m_cls();
				toggleBtn.overFilters = [new BlurFilter(2, 2, 1)];
//				toggleBtn.overOffsetX = 1;
//				toggleBtn.overOffsetY = 1;
//				toggleBtn.downOffsetX = 1;
//				toggleBtn.downOffsetY = 1;
				
				toggleBtn.selectedUpImage = new m_cls2();
				toggleBtn.selectedOverFilters = [new BlurFilter(2, 2, 1)];
//				toggleBtn.selectedOverOffsetX = 1;
//				toggleBtn.selectedOverOffsetY = 1;
//				toggleBtn.selectedDownOffsetX = 1;
//				toggleBtn.selectedDownOffsetY = 1;
				
				toggleBtn.parseCSS(cssTest);
				toggleBtn.label = "To<j>gg</j><s>le" + (i + 1).toString() + "</s>";
				toggleBtn.labelColor = 0xFF8040;
				toggleBtn.selectedLabelColor = 0x01;
				toggleBtn.labelOverFilters = [new BlurFilter(2, 2, 1)];
				toggleBtn.selectedLabelOverFilters = [new BlurFilter(2, 2, 1)];
				
				//toggleBtn.width = 85;
				
				toggleBtn.commitChanges();
				
				combo.addItem(toggleBtn);
			}
			combo.commitChanges();
			
			addChild(combo);
		}
		
		private function testList():void
		{
			var bmp:Bitmap = new m_scrollBarUpAssetCLS();
			
			
			var img:Image = new Image();
			
			img.beginChanges();
			img.source = bmp.bitmapData;
			img.scale9Insets = new Insets(5, 0, 5, 0);
			img.commitChanges();
			
			var group:ToggleGroup = new ToggleGroup();
			
			
			var list:List = new List();
			
			list.beginChanges();
			list.x = 430;
			list.y = 100;
			list.scrollBarBackground = Bitmap(new m_backgroundAssetCLS()).bitmapData;
			list.UpOrLeftBtnUpAsset = new m_scrollUpBtnUpAssetCLS();
			list.UpOrLeftBtnOverAsset = new m_scrollUpBtnOverAssetCLS();
			list.DownOrRightBtnUpAsset = new m_scrollDownBtnUpAssetCLS();
			list.DownOrRightBtnOverAsset = new m_scrollDownBtnOverAssetCLS();
			list.BarUpAsset = img;
			list.width = 100;
			list.height = 300;
			list.itemGap = -5;
			for(var i:int = 0; i < 100; i++)
			{
				var toggleBtn:ToggleButton;
				
				toggleBtn = new ToggleButton();
				toggleBtn.beginChanges();
				
				toggleBtn.upImage = new m_cls();
				toggleBtn.overFilters = [new BlurFilter(2, 2, 1)];
//				toggleBtn.overOffsetX = 1;
//				toggleBtn.overOffsetY = 1;
//				toggleBtn.downOffsetX = 1;
//				toggleBtn.downOffsetY = 1;
				
				toggleBtn.selectedUpImage = new m_cls2();
				toggleBtn.selectedOverFilters = [new BlurFilter(2, 2, 1)];
//				toggleBtn.selectedOverOffsetX = 1;
//				toggleBtn.selectedOverOffsetY = 1;
//				toggleBtn.selectedDownOffsetX = 1;
//				toggleBtn.selectedDownOffsetY = 1;
				
				toggleBtn.parseCSS("j{display: inline; color: #FFFFFF;} s{display: inline; color: #FFFF00;}");
				toggleBtn.label = "To<j>gg</j><s>le" + (i + 1).toString() + "</s>";
				toggleBtn.labelColor = 0xFF8040;
				toggleBtn.selectedLabelColor = 0x01;
				toggleBtn.labelOverFilters = [new BlurFilter(2, 2, 1)];
				toggleBtn.selectedLabelOverFilters = [new BlurFilter(2, 2, 1)];
				
				toggleBtn.width = 85;
				
				toggleBtn.commitChanges();
				
				list.addItem(toggleBtn);
				
				group.addItem(toggleBtn);
			}
			list.commitChanges();
			
			addChild(list);
		}
		
		private function testScrollPanel():void
		{
			var bmp:Bitmap = new m_scrollBarUpAssetCLS();
			
			
			
			var sprite:Sprite = new Sprite();
			sprite.graphics.clear();
			
			sprite.graphics.beginFill(0x336699);
			sprite.graphics.drawRect(0, 0, 100, 50);
			sprite.graphics.endFill();
			
			sprite.graphics.beginFill(0x4080FF);
			sprite.graphics.drawRect(0, 50, 100, 100);
			sprite.graphics.endFill();
			
			sprite.graphics.beginFill(0xFF8040);
			sprite.graphics.drawRect(0, 150, 100, 200);
			sprite.graphics.endFill();
			
			sprite.graphics.beginFill(0);
			sprite.graphics.drawRect(0, 350, 100, 50);
			sprite.graphics.endFill();
			
			
			
			var img:Image = new Image();
			
			img.beginChanges();
			img.source = bmp.bitmapData;
			img.scale9Insets = new Insets(5, 0, 5, 0);
			img.commitChanges();
			
			var scroll:ScrollPanel = new ScrollPanel();
			
			scroll.beginChanges();
			scroll.x = 300;
			scroll.y = 100;
			scroll.scrollBarBackground = Bitmap(new m_backgroundAssetCLS()).bitmapData;
			scroll.UpOrLeftBtnUpAsset = new m_scrollUpBtnUpAssetCLS();
			scroll.UpOrLeftBtnOverAsset = new m_scrollUpBtnOverAssetCLS();
			scroll.DownOrRightBtnUpAsset = new m_scrollDownBtnUpAssetCLS();
			scroll.DownOrRightBtnOverAsset = new m_scrollDownBtnOverAssetCLS();
			scroll.BarUpAsset = img;
			scroll.width = 100;
			scroll.height = 100;
			scroll.scrollView = sprite;
			scroll.scrollPos = ScrollPanel.OUTSIDE;
			scroll.commitChanges();
			
			
			addChild(scroll);
		}
		
		private function testScrollBar():void
		{
			var bmp:Bitmap = new m_scrollBarUpAssetCLS();
			
			
			
			
			
			var img:Image = new Image();
			
			img.beginChanges();
			img.source = bmp.bitmapData;
			img.scale9Insets = new Insets(5, 0, 5, 0);
			img.commitChanges();
			
			var scroll:ScrollBar = new ScrollBar();
			
			scroll.beginChanges();
			scroll.x = 200;
			scroll.y = 100;
			scroll.height = 200;
			scroll.background = Bitmap(new m_backgroundAssetCLS()).bitmapData;
			scroll.UpOrLeftBtnUpAsset = new m_scrollUpBtnUpAssetCLS();
			scroll.UpOrLeftBtnOverAsset = new m_scrollUpBtnOverAssetCLS();
			scroll.DownOrRightBtnUpAsset = new m_scrollDownBtnUpAssetCLS();
			scroll.DownOrRightBtnOverAsset = new m_scrollDownBtnOverAssetCLS();
			scroll.BarUpAsset = img;
			scroll.viewSize = 1000;
			scroll.scrollValueOffset = -15;
			scroll.commitChanges();
			
			
			
			
			
//			var img:Image = new Image();
//			
//			img.beginChanges();
//			img.source = bmp.bitmapData;
//			img.scale9Insets = new Insets(0, 5, 0, 5);
//			img.commitChanges();
//			
//			var scroll:ScrollBar = new ScrollBar(1);
//			
//			scroll.beginChanges();
//			scroll.x = 200;
//			scroll.y = 100;
//			scroll.width = 200;
//			scroll.background = Bitmap(new m_backgroundAssetCLS()).bitmapData;
//			scroll.UpOrLeftBtnUpAsset = new m_scrollUpBtnUpAssetCLS();
//			scroll.UpOrLeftBtnOverAsset = new m_scrollUpBtnOverAssetCLS();
//			scroll.DownOrRightBtnUpAsset = new m_scrollDownBtnUpAssetCLS();
//			scroll.DownOrRightBtnOverAsset = new m_scrollDownBtnOverAssetCLS();
//			scroll.BarUpAsset = img;
//			scroll.viewSize = 1000;
//			scroll.commitChanges();
			
			addChild(scroll);
		}
		
		private function testCheckBox():void
		{
			var check:CheckBox = new CheckBox();
			
			check.beginChanges();
			check.x = 160;
			check.y = 100;
			check.upImage = new m_checkCls();
			check.overFilters = [new ColorMatrixFilter([1, 0, 0, 0, 25,   0, 1, 0, 0, 25,   0, 0, 1, 0, 25,   0, 0, 0, 1, 0])];
			check.selectedUpImage = new m_checkCls2();
			check.selectedOverFilters = [new ColorMatrixFilter([1, 0, 0, 0, 25,   0, 1, 0, 0, 25,   0, 0, 1, 0, 25,   0, 0, 0, 1, 0])];
			
			check.parseCSS("j{display: inline; color: #FFFFFF;} s{display: inline; color: #FFFF00;}");
			check.label = "CheckBox";
			check.labelColor = 0xFF8040;
			check.height = 41;
			
			DEBUG.info("CheckBox   width: {0}, height: {1}", check.width, check.height);
			check.commitChanges();
			
			addChild(check);
		}
		
		private function testToggleButton():void
		{
			var group:ToggleGroup = new ToggleGroup();
			
			var toggleBtn:ToggleButton;
			
			toggleBtn = new ToggleButton();
			toggleBtn.beginChanges();
			toggleBtn.x = 80;
			toggleBtn.y = 100;
			
			toggleBtn.upImage = new m_cls();
			toggleBtn.overFilters = [new BlurFilter(2, 2, 1)];
//			toggleBtn.overOffsetX = 1;
//			toggleBtn.overOffsetY = 1;
//			toggleBtn.downOffsetX = 1;
//			toggleBtn.downOffsetY = 1;
			
			toggleBtn.selectedUpImage = new m_cls2();
			toggleBtn.selectedOverFilters = [new BlurFilter(2, 2, 1)];
//			toggleBtn.selectedOverOffsetX = 1;
//			toggleBtn.selectedOverOffsetY = 1;
//			toggleBtn.selectedDownOffsetX = 1;
//			toggleBtn.selectedDownOffsetY = 1;
			
			toggleBtn.parseCSS("j{display: inline; color: #FFFFFF;} s{display: inline; color: #FFFF00;}");
			toggleBtn.label = "To<j>gg</j><s>le</s>";
			toggleBtn.labelColor = 0xFF8040;
			toggleBtn.selectedLabelColor = 0x01;
			toggleBtn.labelOverFilters = [new BlurFilter(2, 2, 1)];
			toggleBtn.selectedLabelOverFilters = [new BlurFilter(2, 2, 1)];
			toggleBtn.commitChanges();
			
			group.addItem(toggleBtn);
			
			addChild(toggleBtn);
			
			
			
			
			
			
			
			toggleBtn = new ToggleButton();
			toggleBtn.beginChanges();
			toggleBtn.x = 80;
			toggleBtn.y = 160;
			
			toggleBtn.upImage = new m_cls();
			toggleBtn.overFilters = [new BlurFilter(2, 2, 1)];
//			toggleBtn.overOffsetX = 1;
//			toggleBtn.overOffsetY = 1;
//			toggleBtn.downOffsetX = 1;
//			toggleBtn.downOffsetY = 1;
			
			toggleBtn.selectedUpImage = new m_cls2();
			toggleBtn.selectedOverFilters = [new BlurFilter(2, 2, 1)];
//			toggleBtn.selectedOverOffsetX = 1;
//			toggleBtn.selectedOverOffsetY = 1;
//			toggleBtn.selectedDownOffsetX = 1;
//			toggleBtn.selectedDownOffsetY = 1;
			
			toggleBtn.parseCSS("j{display: inline; color: #FFFFFF;} s{display: inline; color: #FFFF00;}");
			toggleBtn.label = "To<j>gg</j><s>le</s>";
			toggleBtn.labelColor = 0xFF8040;
			toggleBtn.selectedLabelColor = 0x01;
			toggleBtn.labelOverFilters = [new BlurFilter(2, 2, 1)];
			toggleBtn.selectedLabelOverFilters = [new BlurFilter(2, 2, 1)];
			toggleBtn.commitChanges();
			
			group.addItem(toggleBtn);
			
			addChild(toggleBtn);
			
			
			
			
			
			
			
			toggleBtn = new ToggleButton();
			toggleBtn.beginChanges();
			toggleBtn.x = 80;
			toggleBtn.y = 220;
			
			toggleBtn.upImage = new m_cls();
			toggleBtn.overFilters = [new BlurFilter(2, 2, 1)];
//			toggleBtn.overOffsetX = 1;
//			toggleBtn.overOffsetY = 1;
//			toggleBtn.downOffsetX = 1;
//			toggleBtn.downOffsetY = 1;
			
			toggleBtn.selectedUpImage = new m_cls2();
			toggleBtn.selectedOverFilters = [new BlurFilter(2, 2, 1)];
//			toggleBtn.selectedOverOffsetX = 1;
//			toggleBtn.selectedOverOffsetY = 1;
//			toggleBtn.selectedDownOffsetX = 1;
//			toggleBtn.selectedDownOffsetY = 1;
			
			toggleBtn.parseCSS("j{display: inline; color: #FFFFFF;} s{display: inline; color: #FFFF00;}");
			toggleBtn.label = "To<j>gg</j><s>le</s>";
			toggleBtn.labelColor = 0xFF8040;
			toggleBtn.selectedLabelColor = 0x01;
			toggleBtn.labelOverFilters = [new BlurFilter(2, 2, 1)];
			toggleBtn.selectedLabelOverFilters = [new BlurFilter(2, 2, 1)];
			toggleBtn.commitChanges();
			
			group.addItem(toggleBtn);
			
			addChild(toggleBtn);
		}
		
		private function testLabelButton():void
		{
			var labelBtn:LabelButton = new LabelButton();
			
			labelBtn.beginChanges();
			labelBtn.x = 0;
			labelBtn.y = 100;
			labelBtn.parseCSS("j{display: inline; color: #FFFFFF;} s{display: inline; color: #FFFF00;}");
			labelBtn.label = "Bu<j>tt</j><s>on</s>";
			labelBtn.labelColor = 0xFF8040;
			labelBtn.upImage = new m_cls();
			labelBtn.freeBMD = true;
//			labelBtn.overFilters = [new BlurFilter()];
//			labelBtn.labelOverFilters = [new BlurFilter(2,2,1)];
//			labelBtn.labelOffsetX = -1;
//			labelBtn.labelOffsetY = -1;
//			labelBtn.overOffsetX = 1;
//			labelBtn.overOffsetY = 1;
//			labelBtn.downOffsetX = 1;
//			labelBtn.downOffsetY = 1;
//			labelBtn.labelOverOffsetX = 1;
//			labelBtn.labelOverOffsetY = 1;
//			labelBtn.labelDownOffsetX = 1;
//			labelBtn.labelDownOffsetY = 1;
			labelBtn.commitChanges();
			
			addChild(labelBtn);
		}
		
		private function testImage():void
		{
			var img:Image = new Image();
			
			var bmp:Bitmap = new m_cls();
			
			img.beginChanges();
			img.x = 230;
			img.y = 100;
			img.source = bmp.bitmapData;
			img.scale9Insets = new Insets(15, 15, 15, 15);
			img.width = 200;
			img.height = 200;
			img.commitChanges();
			
			addChild(img);
		}
	}
}