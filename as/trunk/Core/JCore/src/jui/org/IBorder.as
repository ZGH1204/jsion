package jui.org
{
	public interface IBorder extends IProvider
	{
		function updateBorder(c:Component, g:Graphics2D, b:IntRectangle):void;
		
		function getBorderInsets(c:Component, b:IntRectangle):Insets;
	}
}