package jsion.ui.components.buttons
{
	import jsion.*;
	import jsion.ui.DefaultConfigKeys;

	public class ImageButton extends AbstractButton
	{
		public function ImageButton(text:String=null, prefix:String = null, id:String=null)
		{
			super(text, prefix, id);
			
			model = new DefaultButtonModel();
		}
		
		override public function setSizeWH(w:int, h:int):void
		{
			var min:IntDimension = getMinimumSize();
			var max:IntDimension = getMaximumSize();
			
			if(w < min.width) w = min.width;
			if(h < min.height) h = min.height;
			
			if(w > max.width) w = max.width;
			if(h > max.height) h = max.height;
			
			super.setSizeWH(w, h);
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