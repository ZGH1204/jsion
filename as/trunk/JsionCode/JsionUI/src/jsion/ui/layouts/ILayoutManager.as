package jsion.ui.layouts
{
	import jsion.*;
	import jsion.ui.Component;
	import jsion.ui.Container;

	public interface ILayoutManager extends IDispose
	{
		function addLayoutComponent(comp:Component, constraints:Object):void;
		
		function removeLayoutComponent(comp:Component):void;
		
		function preferredLayoutSize(target:Container):IntDimension;
		
		function minimumLayoutSize(target:Container):IntDimension;
		
		function maximumLayoutSize(target:Container):IntDimension;
		
		function layoutContainer(target:Container):void;
		
		function getLayoutAlignmentX(target:Container):Number;
		
		function getLayoutAlignmentY(target:Container):Number;
		
		function invalidateLayout(target:Container):void;
	}
}