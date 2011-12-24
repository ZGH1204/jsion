package jsion.components
{
	import flash.display.DisplayObject;

	public interface ITab
	{
		function getTabButton():JToggleButton;
		
		function getTabPane():DisplayObject;
		
		function onShowPane():void;
	}
}