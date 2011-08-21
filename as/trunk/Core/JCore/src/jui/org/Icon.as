package jui.org
{
	public interface Icon extends IProvider
	{
		function getIconWidth(c:Component):int;
		
		function getIconHeight(c:Component):int;
		
		function updateIcon(c:Component, g:Graphics2D, x:int, y:int):void;
	}
}