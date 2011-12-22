package jsion.components
{
	import flash.display.DisplayObjectContainer;
	
	public class VSlider extends Slider
	{
		public function VSlider(container:DisplayObjectContainer=null, xPos:Number=0, yPos:Number=0)
		{
			super(VERTICAL, container, xPos, yPos);
		}
	}
}