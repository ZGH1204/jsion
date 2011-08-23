package jui.org.coms.img
{
	import flash.display.BitmapData;
	
	import jui.org.uis.imgs.ScaleImageByTileBitmapUI;
	
	public class ScaleImageByTileBitmap extends Scale9Image
	{
		public function ScaleImageByTileBitmap(bmd:BitmapData=null, assetInset:Insets=null)
		{
			super(bmd, assetInset);
		}
		
		override public function getDefaultBasicUIClass():Class
		{
			return ScaleImageByTileBitmapUI;
		}
	}
}