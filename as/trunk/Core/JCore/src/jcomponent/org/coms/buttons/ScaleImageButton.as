package jcomponent.org.coms.buttons
{
	import jcomponent.org.basic.DefaultConfigKeys;

	public class ScaleImageButton extends AbstractButton
	{
		public function ScaleImageButton(text:String=null, id:String=null)
		{
			super(text, id);
			
			model = new DefaultButtonModel();
		}
		
		override public function getUIDefaultBasicClass():Class
		{
			return ScaleImageButtonUI;
		}
		
		override protected function getUIDefaultClassID():String
		{
			return DefaultConfigKeys.SCALE_IMAGE_BUTTON_UI;
		}
	}
}