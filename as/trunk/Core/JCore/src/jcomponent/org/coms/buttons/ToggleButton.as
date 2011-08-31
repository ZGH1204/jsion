package jcomponent.org.coms.buttons
{
	import jcomponent.org.basic.DefaultConfigKeys;

	public class ToggleButton extends AbstractButton
	{
		public function ToggleButton(text:String=null, prefix:String = null, id:String=null)
		{
			super(text, prefix, id);
			
			model = new ToggleButtonModel();
		}
		
		override public function getUIDefaultBasicClass():Class
		{
			return ToggleButtonUI;
		}
		
		override protected function getUIDefaultClassID():String
		{
			return DefaultConfigKeys.TOGGLE_BUTTON_UI;
		}
	}
}