package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	
	import jsion.debug.DEBUG;
	import jsion.display.CheckBox;
	import jsion.display.LabelButton;
	import jsion.display.ToggleButton;
	
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
		
		public function ComponentApp()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			initHelper();
			
//			testLabelButton();
//			
//			testToggleButton();
//			
//			testCheckBox();
		}
		
		private function initHelper():void
		{
			DEBUG.setup(stage, 300);
			
			DEBUG.loadCSS("debug.css");
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
			var toggleBtn:ToggleButton = new ToggleButton();
			
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
	}
}