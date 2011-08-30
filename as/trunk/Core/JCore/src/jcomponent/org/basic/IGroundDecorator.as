package jcomponent.org.basic
{
	public interface IGroundDecorator extends IDecorator
	{
		function setup(component:Component, ui:IComponentUI):void;
		
		function getSize():IntDimension;
		
		function setLocation(x:int, y:int):void;
		
		function updateDecorator(component:Component, ui:IComponentUI, bounds:IntRectangle):void;
		
		function getPreferredSize(component:Component):IntDimension;
		
		function getMinimumSize(component:Component):IntDimension;
		
		function getMaximumSize(component:Component):IntDimension;
	}
}

