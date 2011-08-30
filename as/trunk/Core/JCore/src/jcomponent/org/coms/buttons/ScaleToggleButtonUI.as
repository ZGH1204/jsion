package jcomponent.org.coms.buttons
{
	import jcomponent.org.basic.Component;
	import jcomponent.org.basic.DefaultConfigKeys;

	public class ScaleToggleButtonUI extends ScaleImageButtonUI
	{
		public function ScaleToggleButtonUI()
		{
			super();
		}
		
		override public function getResourcesPrefix(component:Component):String
		{
			return DefaultConfigKeys.SCALE_TOGGLE_BUTTON_PRE;
		}
	}
}