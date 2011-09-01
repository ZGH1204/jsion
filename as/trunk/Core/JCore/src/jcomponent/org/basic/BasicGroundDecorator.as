package jcomponent.org.basic
{
	import flash.display.DisplayObject;

	public class BasicGroundDecorator implements IGroundDecorator
	{
		public function BasicGroundDecorator()
		{
		}
		
//		public function setup(component:Component, ui:IComponentUI):void
//		{
//			
//		}
//		
//		public function getSize():IntDimension
//		{
//			return new IntDimension();
//		}
//		
//		public function setLocation(x:int, y:int):void
//		{
//			
//		}

		public function updateDecorator(component:Component, bounds:IntRectangle):void
		{
		}

		public function getDisplay(component:Component):DisplayObject
		{
			return null;
		}
		
//		public function getPreferredSize(component:Component):IntDimension
//		{
//			return component.getSize();
//		}
//		
//		public function getMinimumSize(component:Component):IntDimension
//		{
//			return new IntDimension();
//		}
//		
//		public function getMaximumSize(component:Component):IntDimension
//		{
//			return IntDimension.createBigDimension();
//		}

		public function dispose():void
		{
			if(this == DefaultRes.DEFAULT_GROUNDDECORATOR) return;
			
			
		}
	}
}

