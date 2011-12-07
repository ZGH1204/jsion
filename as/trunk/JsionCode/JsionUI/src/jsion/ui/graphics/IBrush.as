/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package jsion.ui.graphics{

	import flash.display.Graphics;
	
	import jsion.*;
	
	/**
	 * Brush to fill a closed area.<br>
	 * Use it with a org.aswing.graphics.Graphics2D instance
	 * @author iiley
	 */
	public interface IBrush extends IDispose
	{

		/**
		 *
		 * This method will be called by Graphics2D autumaticlly.<br>
		 * It applys the fill paramters to the instance of flash.display.Graphics
		 *
		 * @param target the instance of a flash.display.Graphics
		 */
		function beginFill(target:Graphics):void;

		/**
		 *
		 * This method will be called by Graphics2D autumaticlly.<br>
		 * It marks the end of filling
		 *
		 * @param target the instance of a flash.display.Graphics
		 */
		function endFill(target:Graphics):void;
	}

}


