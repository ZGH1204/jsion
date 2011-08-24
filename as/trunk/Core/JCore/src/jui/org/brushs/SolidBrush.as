/*
Copyright aswing.org, see the LICENCE.txt.
*/

package jui.org.brushs{
	
	import flash.display.Graphics;
	
	import jui.org.IBrush;
	import jui.org.JColor;
	
	/**
	 * SolidBrush encapsulate fill parameters for flash.display.Graphics.beginFill()
	 * @see http://livedocs.macromedia.com/flex/2/langref/flash/display/Graphics.html#beginFill()
	 * @author iiley
	 */
	public class SolidBrush implements IBrush
	{
		
		private var color:JColor;
		
		public function SolidBrush(color:JColor)
		{
			this.color = color;
		}
		
		public function getColor():JColor
		{
			return color;
		}
		
		public function setColor(color:JColor):void
		{
			this.color = color;	
		}
		
		public function beginFill(target:Graphics):void
		{
			target.beginFill(color.getRGB(), color.getAlpha());
		}
		
		public function endFill(target:Graphics):void
		{
			target.endFill();
		}
		
		public function dispose():void
		{
			color = null;
		}
	}
}
