package jcomponent.org.basic
{
	import flash.display.DisplayObject;

	public class BasicGroundDecorator implements IGroundDecorator
	{
		public function BasicGroundDecorator()
		{
		}

		public function updateDecorator(component:Component, ui:IComponentUI, bounds:IntRectangle):void
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

