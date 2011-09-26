package jsion.ui
{
	public interface IICON extends IDecorator
	{
		function get iconWidth():int;
		
		function get iconHeight():int;
		
		function updateIcon(component:Component, x:int, y:int):void;
	}
}