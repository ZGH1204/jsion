package jsion.components
{
	import flash.display.DisplayObjectContainer;
	
	public class JVSlider extends JSlider
	{
		public function JVSlider(container:DisplayObjectContainer=null, xPos:Number=0, yPos:Number=0)
		{
			super(VERTICAL, container, xPos, yPos);
		}
	}
}