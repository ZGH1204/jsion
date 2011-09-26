package jsion.ui.components.buttons
{
	import jsion.ui.DefaultConfigKeys;

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