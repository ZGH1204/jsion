package jui.org.coms.img
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	
	import jui.org.Component;
	import jui.org.DefaultUI;
	import jui.org.Graphics2D;
	import jui.org.Icon;
	import jui.org.uis.imgs.BasicImageUI;
	
	import jutils.org.util.DisposeUtil;
	
	public class Image extends Component implements Icon
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
		
		
		public function getIconWidth(c:Component):int
		{
			return bmp.width;
		}
		
		public function getIconHeight(c:Component):int
		{
			return bmp.height;
		}
		
		public function updateIcon(c:Component, g:Graphics2D, x:int, y:int):void
		{
			
		}
		
		public function getDisplay(component:Component):DisplayObject
		{
			return this;
		}
	}
}