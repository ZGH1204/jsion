package jcomponent.org.coms.buttons
{
	import jcomponent.org.basic.DefaultConfigKeys;

	public class ScaleToggleButtonUI extends ScaleImageButtonUI
	{
		public function ScaleToggleButtonUI()
		{
			super();
		}
		
		override protected function getDefaultPrefix():String
		{
			return DefaultConfigKeys.SCALE_TOGGLE_BUTTON_PRE;
		}
	}
}