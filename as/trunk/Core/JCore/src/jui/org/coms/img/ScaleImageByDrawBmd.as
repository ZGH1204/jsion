package jui.org.coms.img
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import jutils.org.util.DisposeUtil;
	
	public class ScaleImageByDrawBmd extends Scale9Image
	{
		public function ScaleImageByDrawBmd(bmd:BitmapData=null, assetInset:Insets=null)
		{
			super(bmd, assetInset);
		}
		
		override protected function paintAsset(bound:IntRectangle):void
		{
			var size:IntDimension = getSize();
			var displaySize:IntDimension = new IntDimension(bmp.width, bmp.height);
			
			if(changed == false && size.equals(displaySize)) return;
			
			changed = false;
			
			var bmd:BitmapData = new BitmapData(size.width, size.height, true, 0x0);
			var old:BitmapData = bmp.bitmapData;
			bmp.bitmapData = bmd;
			
			bmd.lock();
			
			bmd.fillRect(bmd.rect, 0x0);
			
			var sourceSize:IntDimension = new IntDimension(sourceBmd.width, sourceBmd.height);
			var tmpBmd:BitmapData;
			var sourceRect:IntRectangle;
			var copyRect:IntRectangle;
			
			copyOther(bmd, sourceBmd, getMiddleCenterRect(sourceSize), getMiddleCenterRect(size));
			
			copyOther(bmd, sourceBmd, getMiddleLeftRect(sourceSize), getMiddleLeftRect(size));
			
			copyOther(bmd, sourceBmd, getTopCenterRect(sourceSize), getTopCenterRect(size));
			
			copyOther(bmd, sourceBmd, getMiddleRightRect(sourceSize), getMiddleRightRect(size));
			
			copyOther(bmd, sourceBmd, getBottomCenterRect(sourceSize), getBottomCenterRect(size));
			
			copyFourCorner(bmd, sourceBmd, getTopLeftRect(sourceSize), getTopLeftRect(size));
			
			copyFourCorner(bmd, sourceBmd, getTopRightRect(sourceSize), getTopRightRect(size));
			
			copyFourCorner(bmd, sourceBmd, getBottomLeftRect(sourceSize), getBottomLeftRect(size));
			
			copyFourCorner(bmd, sourceBmd, getBottomRightRect(sourceSize), getBottomRightRect(size));
			
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
			
			if(scale9Type == SCALE_TILE)
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
	}
}