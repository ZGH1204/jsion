package jcomponent.org.coms.images
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import jcomponent.org.basic.DefaultConfigKeys;
	
	public class ScaleImageDraw extends AbstractImage
	{
		public function ScaleImageDraw(bmd:BitmapData, scaleInset:Insets = null, id:String = null)
		{
			super(bmd, scaleInset, id);
		}
		
		override public function getUIDefaultBasicClass():Class
		{
			return ScaleImageDrawUI;
		}
		
		override protected function getUIDefaultClassID():String
		{
			return DefaultConfigKeys.SCALE_IMAGE_DRAW_UI;
		}
			
	}
}