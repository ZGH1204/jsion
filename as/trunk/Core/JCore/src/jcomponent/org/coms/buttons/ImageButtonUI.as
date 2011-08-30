package jcomponent.org.coms.buttons
{
	import jcomponent.org.basic.Component;
	import jcomponent.org.basic.DefaultConfigKeys;

	public class ImageButtonUI extends BasicButtonUI
	{
		public function ImageButtonUI()
		{
			super();
		}
		
		override public function getResourcesPrefix(component:Component):String
		{
			return DefaultConfigKeys.IMAGE_BUTTON_PRE;
		}
	}
}