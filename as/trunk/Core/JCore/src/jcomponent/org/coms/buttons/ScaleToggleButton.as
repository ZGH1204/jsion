package jcomponent.org.coms.buttons
{
	import jcomponent.org.basic.DefaultConfigKeys;

	public class ScaleToggleButton extends AbstractButton
	{
		public function ScaleToggleButton(text:String=null, prefix:String = null, id:String=null)
		{
			super(text, prefix, id);
			
			model = new ToggleButtonModel();
		}
		
		override public function getUIDefaultBasicClass():Class
		{
			return ScaleToggleButtonUI;
		}
		
		override protected function getUIDefaultClassID():String
		{
			return DefaultConfigKeys.SCALE_TOGGLE_BUTTON_UI;
		}
	}
}