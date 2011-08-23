package jui.org.brushs
{
	import flash.display.Graphics;
	import jui.org.IBrush;
	
	public class TransparentBrush implements IBrush
	{
		public function TransparentBrush()
		{
		}
		
		public function beginFill(target:Graphics):void
		{
			target.beginFill(0x0, 0);
		}
		
		public function endFill(target:Graphics):void
		{
			target.endFill();
		}
		
		public function dispose():void
		{
			
		}
	}
}