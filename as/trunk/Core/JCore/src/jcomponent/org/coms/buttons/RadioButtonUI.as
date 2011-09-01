package jcomponent.org.coms.buttons
{
	import jcomponent.org.basic.DefaultConfigKeys;

	public class RadioButtonUI extends BasicButtonUI
	{
		public function RadioButtonUI()
		{
			super();
		}
		
		override protected function getDefaultPrefix():String
		{
			return DefaultConfigKeys.RADIO_BUTTON_PRE;
		}
	}
}