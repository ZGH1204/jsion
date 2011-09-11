package jcomponent.org.coms.containers
{
	import flash.display.DisplayObject;
	
	import jcomponent.org.coms.buttons.AbstractButton;

	public interface ITab
	{
		function getTabButton():AbstractButton;
		
		function getTabContent():DisplayObject;
	}
}