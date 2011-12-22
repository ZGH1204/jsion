package jsion.components
{
	import flash.display.DisplayObjectContainer;
	
	public class HSlider extends Slider
	{
		public function HSlider(container:DisplayObjectContainer=null, xPos:Number=0, yPos:Number=0)
		{
			super(HORIZONTAL, container, xPos, yPos);
		}
	}
}