package jui.org.coms.img
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import jui.org.Component;
	import jui.org.DefaultUI;
	import jui.org.uis.imgs.BasicImageUI;
	
	import jutils.org.util.DisposeUtil;
	
	public class Image extends Component
	{
		protected var bmp:Bitmap;
		
		protected var sourceBmd:BitmapData;
		
		protected var changed:Boolean;
		
		public function Image(bmd:BitmapData = null)
		{
			super();
			changed = false;
			bmp = new Bitmap();
			setAsset(bmd);
		}
		
		public function getSourceBmd():BitmapData
		{
			return sourceBmd;
		}
		
		public function setSourceBmd(value:BitmapData):void
		{
			setAsset(value);
		}
		
		public function getAsset():Bitmap
		{
			return bmp;
		}
		
		public function setAsset(bmd:BitmapData = null):void
		{
			if(bmp && sourceBmd != bmd)
			{
				sourceBmd = bmd;
				
				changed = true;
				
				bmp.bitmapData = bmd;
				
				setSizeWH(bmp.width, bmp.height);
				
				changed = false;
			}
		}
		
		public function isChanged():Boolean
		{
			return changed;
		}
		
		override public function getDefaultBasicUIClass():Class
		{
			return BasicImageUI;
		}
		
		override protected function getDefaultUIClassID():String
		{
			return DefaultUI.ImageUI;
		}
		
		override public function dispose():void
		{
			if(bmp != null)
				DisposeUtil.free(bmp, bmp.bitmapData != sourceBmd);
			bmp = null;
			
			sourceBmd = null;
			
			super.dispose();
		}
	}
}