package jcomponent.org.basic
{
	public interface IComponentUI extends IUIResources
	{
		function install(component:Component):void;

		function uninstall(component:Component):void;
		
		function getResourcesPrefix(component:Component):String;
		
		function getPreferredSize(component:Component):IntDimension;
		
		function getMinimumSize(component:Component):IntDimension;
		
		function getMaximumSize(component:Component):IntDimension;

		function paint(component:Component, bounds:IntRectangle):void;
	}
}

