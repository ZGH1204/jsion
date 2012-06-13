package
{
	import flash.events.*; 
	import flash.display.*; 
	import flash.utils.*; 
	import flash.text.*; 
	public class FPSState extends Sprite
	{
		private var numFrames:Number = 0; 
		private var interval:Number = 10 
		private var startTime:Number; 
		private var my_fmt:TextFormat;
		private var fpsText:TextField;
		public function FPSState()
		{
			super();
			startTime = getTimer(); 
			
			// 文本实例的样式 
			my_fmt = new TextFormat(); 
			my_fmt.bold = true; 
			my_fmt.font = "Arial"; 
			my_fmt.size = 12; 
			my_fmt.color = 0xFF0000; 
			
			fpsText = new TextField(); 
			fpsText.autoSize = "left"; 
			fpsText.text = "loading"; 
			addChild(fpsText); 
			
			fpsText.defaultTextFormat = my_fmt; 
			fpsText.selectable = false       
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded); 
		}
		
		private function onAdded(event:Event):void
		{ 
			stage.addEventListener(Event.ENTER_FRAME, update, false, 0); 
		} 
		
		private function update(event:Event):void
		{ 
			if (++numFrames == interval) { 
				var now:Number = getTimer(); 
				var elapsedSeconds:Number = (now - startTime) / 1000; 
				var actualFPS:Number = numFrames / elapsedSeconds;         
				fpsText.text = (actualFPS.toFixed(2)); 
				startTime = now; 
				numFrames = 0; 
			} 
		} 
	}
}
