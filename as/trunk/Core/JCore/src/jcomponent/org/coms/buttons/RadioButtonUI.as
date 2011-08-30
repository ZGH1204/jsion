package jcomponent.org.coms.buttons
{
	import jcomponent.org.basic.Component;
	import jcomponent.org.basic.DefaultConfigKeys;

	public class RadioButtonUI extends CheckBoxUI
	{
		public function RadioButtonUI()
		{
			super();
		}
		
		override public function getResourcesPrefix(component:Component):String
		{
			return DefaultConfigKeys.RADIO_BUTTON_PRE;
		}
	}
}