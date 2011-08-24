package jui.org.coms.checkboxs
{
	import jui.org.DefaultUI;
	import jui.org.Icon;
	import jui.org.coms.buttons.ToggleButton;
	import jui.org.uis.checkboxs.BasicCheckBoxUI;
	
	public class CheckBox extends ToggleButton
	{
		public function CheckBox(text:String="", icon:Icon=null)
		{
			super(text, icon);
			setName("CheckBox");
			setIconTextGap(1);
		}
		
		override protected function getDefaultUIClassID():String
		{
			return DefaultUI.CheckBoxUI;
		}
		
		override public function getDefaultBasicUIClass():Class
		{
			return BasicCheckBoxUI;
		}
	}
}