package jui.org
{
	public interface ICanUpdateProvider extends IProvider
	{
		function update(component:Component, graphics:Graphics2D, bound:IntRectangle):void;
	}
}