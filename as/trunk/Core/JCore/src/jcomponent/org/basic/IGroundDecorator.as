package jcomponent.org.basic
{
	public interface IGroundDecorator extends IDecorator
	{
		function updateDecorator(component:Component, ui:IComponentUI, bounds:IntRectangle):void;
	}
}

