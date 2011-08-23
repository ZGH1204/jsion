package jui.org.uis.imgs
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import jui.org.Component;
	import jui.org.Graphics2D;
	import jui.org.coms.img.Image;
	import jui.org.coms.img.Scale9Image;
	
	import jutils.org.util.DisposeUtil;

	public class ScaleImageByDrawBmdUI extends BasicImageUI
	{
		protected var scale9Type:int;
		
		public function ScaleImageByDrawBmdUI()
		{
			super();
		}
		
		override public function paint(component:Component, graphics:Graphics2D, bound:IntRectangle):void
		{
			paintAsset(component, bound);
		}
		
		protected function paintAsset(component:Component, bound:IntRectangle):void
		{
			var img:Scale9Image = Scale9Image(component);
			
			var bmp:Bitmap = img.getAsset();
			var changed:Boolean = img.isChanged();
			var size:IntDimension = img.getSize();
			var displaySize:IntDimension = new IntDimension(bmp.width, bmp.height);
			
			scale9Type = img.getScale9Type();
			
			
			if(changed == false && size.equals(displaySize)) return;
			
			//changed = false;
			
			var sourceBmd:BitmapData = img.getSourceBmd();
			
			var bmd:BitmapData = new BitmapData(size.width, size.height, true, 0x0);
			var old:BitmapData = bmp.bitmapData;
			bmp.bitmapData = bmd;
			
			bmd.lock();
			
			bmd.fillRect(bmd.rect, 0x0);
			
			var sourceSize:IntDimension = new IntDimension(sourceBmd.width, sourceBmd.height);
			var tmpBmd:BitmapData;
			var sourceRect:IntRectangle;
			var copyRect:IntRectangle;
			
			copyOther(bmd, sourceBmd, img.getMiddleCenterRect(sourceSize), img.getMiddleCenterRect(size));
			
			copyOther(bmd, sourceBmd, img.getMiddleLeftRect(sourceSize), img.getMiddleLeftRect(size));
			
			copyOther(bmd, sourceBmd, img.getTopCenterRect(sourceSize), img.getTopCenterRect(size));
			
			copyOther(bmd, sourceBmd, img.getMiddleRightRect(sourceSize), img.getMiddleRightRect(size));
			
			copyOther(bmd, sourceBmd, img.getBottomCenterRect(sourceSize), img.getBottomCenterRect(size));
			
			copyFourCorner(bmd, sourceBmd, img.getTopLeftRect(sourceSize), img.getTopLeftRect(size));
			
			copyFourCorner(bmd, sourceBmd, img.getTopRightRect(sourceSize), img.getTopRightRect(size));
			
			copyFourCorner(bmd, sourceBmd, img.getBottomLeftRect(sourceSize), img.getBottomLeftRect(size));
			
			copyFourCorner(bmd, sourceBmd, img.getBottomRightRect(sourceSize), img.getBottomRightRect(size));
			
			bmd.unlock();
			
			if(sourceBmd != old) DisposeUtil.free(old);
			
			old = null;
		}
		
		private function copyOther(bmd:BitmapData, sourceBmd:BitmapData, sourceRect:IntRectangle, copyRect:IntRectangle):void
		{
			var tmpBmd:BitmapData = drawScaleRect(sourceBmd, sourceRect, copyRect);
			bmd.copyPixels(tmpBmd, tmpBmd.rect, copyRect.getLocation().toPoint());
			DisposeUtil.free(tmpBmd);
			tmpBmd = null;
		}
		
		private function copyFourCorner(bmd:BitmapData, sourceBmd:BitmapData, sourceRect:IntRectangle, copyRect:IntRectangle):void
		{
			bmd.copyPixels(sourceBmd, sourceRect.toRectangle(), copyRect.getLocation().toPoint());
		}
		
		private function drawScaleRect(sourceBmd:BitmapData, sourceRect:IntRectangle, drawRect:IntRectangle):BitmapData
		{
			var sBmd:BitmapData = new BitmapData(sourceRect.width, sourceRect.height, true, 0);
			sBmd.copyPixels(sourceBmd, sourceRect.toRectangle(), Constant.ZeroPoint);
			
			var rltBmd:BitmapData = new BitmapData(drawRect.width, drawRect.height, true, 0);
			
			if(scale9Type == Scale9Image.SCALE_TILE)
			{
				rltBmd.lock();
				
				var point:Point = new Point();
				
				while(true)
				{
					rltBmd.copyPixels(sBmd, sBmd.rect, point);
					
					point.x += sBmd.width;
					
					if(point.x >= drawRect.width)
					{
						point.x = 0;
						point.y += sBmd.height;
						
						if(point.y >= drawRect.height)
						{
							break;
						}
					}
				}
				
				rltBmd.unlock();
			}
			else
			{
				var bmp:Bitmap = new Bitmap(sBmd);
				bmp.width = drawRect.width;
				bmp.height = drawRect.height;
				var matrix:Matrix = bmp.transform.matrix.clone();
				
				rltBmd.draw(sBmd, matrix);
				
				bmp.bitmapData = null;
				bmp = null;
			}
			
			return rltBmd;
		}
		
		
		
		override public function dispose():void
		{
			super.dispose();
		}
	}
}