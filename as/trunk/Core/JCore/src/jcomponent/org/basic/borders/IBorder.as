package jcomponent.org.basic.borders
{
	import jcomponent.org.basic.Component;
	import jcomponent.org.basic.IComponentUI;
	import jcomponent.org.basic.IDecorator;

	public interface IBorder extends IDecorator
	{
		function updateBorder(component:Component, ui:IComponentUI, bounds:IntRectangle):void;

		function getBorderInsets(component:Component, bounds:IntRectangle):Insets;
	}
}

