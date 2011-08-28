package jcomponent.org.coms.buttons
{
	import jcomponent.org.basic.Component;
	import jcomponent.org.basic.IGroundDecorator;

	public class ImageButtonUI extends BasicButtonUI
	{
		private var backgroundDecorator:ButtonImageBackground;
		
		public function ImageButtonUI()
		{
			super();
		}
		
		override public function install(component:Component):void
		{
			super.install(component);
			
			backgroundDecorator = new ButtonImageBackground();
			
			component.backgroundDecorator = backgroundDecorator;
		}
		
		override public function uninstall(component:Component):void
		{
			super.uninstall(component);
			
			backgroundDecorator = null;
		}
	}
}