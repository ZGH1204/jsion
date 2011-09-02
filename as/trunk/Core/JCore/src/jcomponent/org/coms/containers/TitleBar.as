package jcomponent.org.coms.containers
{
	import flash.display.DisplayObject;
	
	import jcomponent.org.basic.Component;
	import jcomponent.org.basic.IComponentUI;
	
	public class TitleBar implements ITitleBar
	{
		public function TitleBar()
		{
		}
		
		public function setup(component:Component):void
		{
		}
		
		public function getSize():IntDimension
		{
			return null;
		}
		
		public function setLocation(x:int, y:int):void
		{
		}
		
		public function setTitle(title:String):void
		{
			
		}
		
		public function updateTitleBar(component:Component, ui:IComponentUI, bounds:IntRectangle):void
		{
		}
		
		public function getDisplay(component:Component):DisplayObject
		{
			return null;
		}
		
		public function dispose():void
		{
		}
	}
}