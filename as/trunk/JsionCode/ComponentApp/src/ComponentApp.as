package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	
	import jsion.debug.DEBUG;
	import jsion.display.LabelButton;
	
	[SWF(width="1000", height="650", frameRate="30")]
	public class ComponentApp extends Sprite
	{
		[Embed(source="pic.png")]
		private var m_cls:Class;
		
		public function ComponentApp()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			initHelper();
		}
		
		private function initHelper():void
		{
			DEBUG.setup(stage, 300);
			
			DEBUG.loadCSS("debug.css");
		}
		
		private function testLabelButton():void
		{
			var labelBtn:LabelButton = new LabelButton();
			
			labelBtn.beginChanges();
			labelBtn.x = 200;
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