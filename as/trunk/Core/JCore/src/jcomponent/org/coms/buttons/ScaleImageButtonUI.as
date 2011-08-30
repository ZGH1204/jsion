package jcomponent.org.coms.buttons
{
	import jcomponent.org.basic.Component;
	import jcomponent.org.basic.DefaultConfigKeys;

	public class ScaleImageButtonUI extends ImageButtonUI
	{
		public function ScaleImageButtonUI()
		{
			super();
		}
		
		override protected function installBackgroundDecorator(component:Component):void
		{
			backgroundDecorator = new ButtonScaleImageBackground();
			
			backgroundDecorator.setup(this);
			
			component.backgroundDecorator = backgroundDecorator;
		}
		
		override public function getResourcesPrefix():String
		{
			return DefaultConfigKeys.SCALE_IMAGE_BUTTON_PRE;
		}
	}
}