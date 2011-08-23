package jui.org.uis
{
	import jui.org.Component;
	import jui.org.Graphics2D;
	import jui.org.IComponentUI;
	import jui.org.errors.ImpMissError;
	
	public class BaseComponentUI implements IComponentUI
	{
		public function BaseComponentUI()
		{
		}
		
		public function installUI(component:Component):void
		{
			throw new ImpMissError();
		}
		
		public function uninstallUI(component:Component):void
		{
			throw new ImpMissError();
		}
		
		public function paint(component:Component, graphics:Graphics2D, bound:IntRectangle):void
		{
		}
		
		public function getPreferredSize(c:Component):IntDimension
		{
			return c.getPreferredSize();
		}
		
		public function getMinimumSize(c:Component):IntDimension
		{
			return c.getInsets().getOutsideSize();
		}
		
		public function getMaximumSize(c:Component):IntDimension
		{
			return IntDimension.createBigDimension();
		}
		
		public function dispose():void
		{
			
		}
	}
}