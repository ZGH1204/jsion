package jui.org.coms.img
{
	import flash.display.BitmapData;
	
	import jui.org.uis.imgs.ScaleImageByDrawBmdUI;
	
	public class ScaleImageByDrawBmd extends Scale9Image
	{
		public function ScaleImageByDrawBmd(bmd:BitmapData = null, assetInset:Insets = null)
		{
			super(bmd, assetInset);
		}
		
		override public function getDefaultBasicUIClass():Class
		{
			return ScaleImageByDrawBmdUI;
		}
	}
}