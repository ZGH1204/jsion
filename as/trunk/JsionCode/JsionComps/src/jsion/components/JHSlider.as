package jsion.components
{
	import flash.display.DisplayObjectContainer;
	
	public class JHSlider extends JSlider
	{
		public function JHSlider(container:DisplayObjectContainer=null, xPos:Number=0, yPos:Number=0)
		{
			super(HORIZONTAL, container, xPos, yPos);
		}
	}
}