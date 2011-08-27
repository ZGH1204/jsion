package jcomponent.org.basic
{
	public interface IICON extends IDecorator
	{
		function get getIconWidth():int;
		
		function get getIconHeight():int;
		
		function updateIcon(component:Component, x:int, y:int):void;
	}
}