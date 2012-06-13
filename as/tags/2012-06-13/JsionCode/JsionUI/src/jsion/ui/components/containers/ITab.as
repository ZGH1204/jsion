package jsion.ui.components.containers
{
	import flash.display.DisplayObject;
	
	import jsion.ui.components.buttons.AbstractButton;

	public interface ITab
	{
		function getTabButton():AbstractButton;
		
		function getTabContent():DisplayObject;
		
		function onShowContent():void;
	}
}