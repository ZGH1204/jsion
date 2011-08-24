package jui.org.coms.buttons
{
	import jui.org.DefaultUI;
	import jui.org.Icon;
	import jui.org.UIMgr;
	import jui.org.uis.buttons.BasicToggleButtonUI;
	
	public class ToggleButton extends AbstractButton
	{
		public function ToggleButton(text:String="", icon:Icon=null)
		{
			super(text, icon);
			
			setName("ToggleButton");
			setModel(new ToggleButtonModel());
		}
		
		override protected function updateUI():void
		{
			setUI(UIMgr.getUI(this));
		}
		
		override public function getDefaultBasicUIClass():Class
		{
			return BasicToggleButtonUI;
		}
		
		override protected function getDefaultUIClassID():String
		{
			return DefaultUI.ToggleButtonUI;
		}
	}
}