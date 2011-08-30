package jcomponent.org.coms.buttons
{
	import jcomponent.org.basic.Component;
	import jcomponent.org.basic.DefaultConfigKeys;

	public class ToggleButtonUI extends ImageButtonUI
	{
		public function ToggleButtonUI()
		{
			super();
		}
		
		override public function getResourcesPrefix(component:Component):String
		{
			return DefaultConfigKeys.TOGGLE_BUTTON_PRE;
		}
	}
}