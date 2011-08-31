package jcomponent.org.coms.buttons
{
	import jcomponent.org.basic.DefaultConfigKeys;

	public class ImageButtonUI extends BasicButtonUI
	{
		public function ImageButtonUI()
		{
			super();
		}
		
		override protected function getDefaultPrefix():String
		{
			return DefaultConfigKeys.IMAGE_BUTTON_PRE;
		}
	}
}