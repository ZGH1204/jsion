package jsion.ui.components.buttons
{
	import jsion.ui.Component;
	import jsion.ui.DefaultConfigKeys;
	
	import jsion.utils.StringUtil;

	public class ToggleButtonUI extends ImageButtonUI
	{
		public function ToggleButtonUI()
		{
			super();
		}
		
		override protected function getDefaultPrefix():String
		{
			return DefaultConfigKeys.TOGGLE_BUTTON_PRE;
		}
	}
}