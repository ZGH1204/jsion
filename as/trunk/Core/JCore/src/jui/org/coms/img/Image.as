package jui.org.coms.img
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import jui.org.Component;
	
	public class Image extends Component
	{
		protected var bmp:Bitmap;
		
		protected var sourceBmd:BitmapData;
		
		public function Image(bmd:BitmapData = null)
		{
			super();
			bmp = new Bitmap();
			setAsset(bmd);
		}
		
		public function setAsset(bmd:BitmapData = null):void
		{
			if(bmp && sourceBmd != bmd)
			{
				sourceBmd = bmd;
				
				bmp.bitmapData = bmd;
				
				if(bmp.parent == null)
				{
					addChild(bmp);
				}
				
				setSizeWH(bmp.width, bmp.height);
			}
		}
		
		public function getAsset():Bitmap
		{
			return bmp;
		}
	}
}