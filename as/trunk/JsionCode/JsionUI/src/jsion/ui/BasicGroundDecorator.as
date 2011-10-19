package jsion.ui
{
	import flash.display.DisplayObject;

	public class BasicGroundDecorator implements IGroundDecorator
	{
		public function BasicGroundDecorator()
		{
		}

		public function updateDecorator(component:Component, bounds:IntRectangle):void
		{
		}

		public function getDisplay(component:Component):DisplayObject
		{
			return null;
		}

		public function dispose():void
		{
			if(this == DefaultRes.DEFAULT_GROUNDDECORATOR) return;
			
			
		}
	}
}

