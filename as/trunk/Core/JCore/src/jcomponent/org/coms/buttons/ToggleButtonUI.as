package jcomponent.org.coms.buttons
{
	import jcomponent.org.basic.Component;
	import jcomponent.org.basic.DefaultConfigKeys;
	
	import jutils.org.util.StringUtil;

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