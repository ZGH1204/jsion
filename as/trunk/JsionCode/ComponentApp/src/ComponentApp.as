package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import jsion.JsionFPS;
	import jsion.debug.DEBUG;
	
	[SWF(width="1000", height="650", frameRate="30")]
	public class ComponentApp extends Sprite
	{
		public function ComponentApp()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			initHelper();
		}
		
		private function initHelper():void
		{
			stage.addChild(new JsionFPS);
			
			DEBUG.setup(stage, 300);
			
			DEBUG.loadCSS("debug.css");
		}
	}
}