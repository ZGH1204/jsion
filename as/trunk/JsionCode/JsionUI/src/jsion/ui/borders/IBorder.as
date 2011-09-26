package jsion.ui.borders
{
	import jsion.ui.Component;
	import jsion.ui.IComponentUI;
	import jsion.ui.IDecorator;

	public interface IBorder extends IDecorator
	{
		function updateBorder(component:Component, ui:IComponentUI, bounds:IntRectangle):void;

		function getBorderInsets(component:Component, bounds:IntRectangle):Insets;
	}
}

