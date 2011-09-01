package jcomponent.org.basic.layouts
{
	import jcomponent.org.basic.Component;
	import jcomponent.org.basic.Container;
	
	public class EmptyLayout implements ILayoutManager
	{
		public function EmptyLayout()
		{
		}
		
		public function addLayoutComponent(comp:Component, constraints:Object):void
		{
		}
		
		public function removeLayoutComponent(comp:Component):void
		{
		}
		
		public function preferredLayoutSize(target:Container):IntDimension
		{
			return target.getSize();
		}
		
		public function minimumLayoutSize(target:Container):IntDimension
		{
			return new IntDimension(0, 0);
		}
		
		public function maximumLayoutSize(target:Container):IntDimension
		{
			return IntDimension.createBigDimension();
		}
		
		public function layoutContainer(target:Container):void
		{
		}
		
		public function getLayoutAlignmentX(target:Container):Number
		{
			return 0;
		}
		
		public function getLayoutAlignmentY(target:Container):Number
		{
			return 0;
		}
		
		public function invalidateLayout(target:Container):void
		{
		}
		
		public function dispose():void
		{
			
		}
	}
}