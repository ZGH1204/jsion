package jcomponent.org.coms.buttons
{
	import jcomponent.org.basic.DefaultConfigKeys;

	public class ScaleImageButtonUI extends ImageButtonUI
	{
		public function ScaleImageButtonUI()
		{
			super();
		}
		
		override protected function getDefaultPrefix():String
		{
			return DefaultConfigKeys.SCALE_IMAGE_BUTTON_PRE;
		}
	}
}