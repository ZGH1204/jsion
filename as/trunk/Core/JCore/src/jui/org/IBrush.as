package jui.org
{
	import flash.display.Graphics;

	public interface IBrush extends IDispose
	{
		function beginFill(target:Graphics):void;
		
		function endFill(target:Graphics):void;
	}
}