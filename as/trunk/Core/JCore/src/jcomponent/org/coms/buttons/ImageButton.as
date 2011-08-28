package jcomponent.org.coms.buttons
{
	import jcomponent.org.basic.DefaultConfigKeys;

	public class ImageButton extends AbstractButton
	{
		public function ImageButton(text:String=null, id:String=null)
		{
			super(text, id);
			
			model = new DefaultButtonModel();
		}
		
		override public function getUIDefaultBasicClass():Class
		{
			return ImageButtonUI;
		}
		
		override protected function getUIDefaultClassID():String
		{
			return DefaultConfigKeys.IMAGE_BUTTON_UI;
		}
	}
}