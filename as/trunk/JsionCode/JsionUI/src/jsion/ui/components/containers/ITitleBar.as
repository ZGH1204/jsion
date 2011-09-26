package jsion.ui.components.containers
{
	import jsion.ui.Component;
	import jsion.ui.IComponentUI;
	import jsion.ui.IDecorator;
	
	public interface ITitleBar extends IDecorator
	{
		function setup(component:Component):void;
		
		function getSize():IntDimension;
		
		function setSize(w:int, h:int):void;
		
		function setTitle(title:String):void;
		
		function updateTitleBar(component:Component, x:int, y:int):void;
	}
}