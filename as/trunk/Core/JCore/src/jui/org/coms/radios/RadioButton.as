package jui.org.coms.radios
{
	import jui.org.DefaultUI;
	import jui.org.Icon;
	import jui.org.coms.buttons.ToggleButton;
	import jui.org.uis.radios.BasicRadioButtonUI;
	
	public class RadioButton extends ToggleButton
	{
		public function RadioButton(text:String="", icon:Icon=null)
		{
			super(text, icon);
			setName("RadioButton");
		}
		
		override public function getDefaultBasicUIClass():Class{
			return BasicRadioButtonUI;
		}
		
		override protected function getDefaultUIClassID():String{
			return DefaultUI.RadioButtonUI;
		}
	}
}