package jcomponent.org.coms.buttons
{
	import jcomponent.org.basic.Component;
	import jcomponent.org.basic.DefaultConfigKeys;

	public class ImageButtonUI extends BasicButtonUI
	{
		protected var backgroundDecorator:ButtonImageBackground;
		
		public function ImageButtonUI()
		{
			super();
		}
		
		override public function install(component:Component):void
		{
			super.install(component);
			
			installBackgroundDecorator(component);
		}
		
		protected function installBackgroundDecorator(component:Component):void
		{
			backgroundDecorator = new ButtonImageBackground();
			
			backgroundDecorator.setup(component, this);
			
			component.backgroundDecorator = backgroundDecorator;
		}
		
		override public function uninstall(component:Component):void
		{
			super.uninstall(component);
			
			backgroundDecorator = null;
		}
		
		override public function getResourcesPrefix(component:Component):String
		{
			return DefaultConfigKeys.IMAGE_BUTTON_PRE;
		}
		
		override public function getPreferredSize(component:Component):IntDimension
		{
			var textSize:IntDimension = getTextSize(component);
			var backSize:IntDimension = backgroundDecorator.getPreferredSize(component);
			
			return new IntDimension(Math.max(textSize.width, backSize.width), Math.max(textSize.height, backSize.height));
		}
		
		override public function getMinimumSize(component:Component):IntDimension
		{
			//return backgroundDecorator.
			var textSize:IntDimension = getTextSize(component);
			var backSize:IntDimension = backgroundDecorator.getMinimumSize(component);
			
			return new IntDimension(Math.max(textSize.width, backSize.width), Math.max(textSize.height, backSize.height));
		}
		
		override public function getMaximumSize(component:Component):IntDimension
		{
			var textSize:IntDimension = getTextSize(component);
			var backMax:IntDimension = backgroundDecorator.getMaximumSize(component);
			
			return new IntDimension(Math.max(textSize.width, backMax.width), Math.max(textSize.height, backMax.height));
		}
	}
}