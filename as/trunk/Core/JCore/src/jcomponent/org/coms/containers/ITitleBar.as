package jcomponent.org.coms.containers
{
	import jcomponent.org.basic.Component;
	import jcomponent.org.basic.IComponentUI;
	import jcomponent.org.basic.IDecorator;
	
	public interface ITitleBar extends IDecorator
	{
		function setup(component:Component):void;
		
		function getSize():IntDimension;
		
		function setTitle(title:String):void;
		
		function updateTitleBar(component:Component, x:int, y:int):void;
	}
}