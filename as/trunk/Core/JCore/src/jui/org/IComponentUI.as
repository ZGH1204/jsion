package jui.org
{
	public interface IComponentUI
	{
		function installUI(component:Component):void;
		
		function uninstallUI(component:Component):void;
		
		function paint(component:Component, graphics:Graphics2D, bound:IntRectangle):void;
		
		function getPreferredSize():IntDimension;
		
		function getMinimumSize(c:Component):IntDimension;
		
		function getMaximumSize(c:Component):IntDimension;
	}
}