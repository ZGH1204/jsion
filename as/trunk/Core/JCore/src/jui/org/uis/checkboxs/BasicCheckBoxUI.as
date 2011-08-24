package jui.org.uis.checkboxs
{
	import jui.org.DefaultUI;
	import jui.org.uis.radios.BasicRadioButtonUI;
	
	public class BasicCheckBoxUI extends BasicRadioButtonUI
	{
		public function BasicCheckBoxUI()
		{
			super();
		}
		
		override protected function getPrefix():String
		{
			return DefaultUI.CheckBoxPrefix;
		}
	}
}