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
		
		override public function getResourcesPrefix(component:Component):String
		{
			return DefaultConfigKeys.SCALE_IMAGE_BUTTON_PRE;
		}
	}
}