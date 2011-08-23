package jui.org
{
	import flash.display.DisplayObject;

	public interface IProvider extends IDispose
	{
		function getDisplay(component:Component):DisplayObject;
	}
}