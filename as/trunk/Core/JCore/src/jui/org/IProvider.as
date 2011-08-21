package jui.org
{
	import flash.display.DisplayObject;

	public interface IProvider
	{
		function getDisplay(component:Component):DisplayObject;
	}
}