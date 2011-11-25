package jsion.ui.components.images
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import jsion.ui.Component;
	import jsion.utils.DisposeUtil;
	
	public class ScaleImageDrawUI extends BasicScaleImageUI
	{
		private var bmp:Bitmap;
		private var sourceBitmapData:BitmapData;
		private var scaleImage:ScaleImageDraw;
		
		override public function install(component:Component):void
		{
			scaleImage = component as ScaleImageDraw;
			
			sourceBitmapData = scaleImage.sourceBitmapData;
			
			bmp = new Bitmap();
			
			scaleImage.addChild(bmp);
		}
		
		override public function uninstall(component:Component):void
		{
			if(bmp)
			{
				DisposeUtil.free(bmp, bmp.bitmapData != sourceBitmapData);
				bmp = null;
			}
			
			sourceBitmapData = null;
			
			scaleImage = null;
		}
		
		override public function getMinimumSize(component:Component):IntDimension
		{
			var scaleInsets:Insets = scaleImage.scaleInsets;
			
			return new IntDimension(scaleInsets.left + scaleInsets.right, scaleInsets.top + scaleInsets.bottom);
		}
		
		override public function getPreferredSize(component:Component):IntDimension
		{
			return new IntDimension(sourceBitmapData.width, sourceBitmapData.height);
		}
		
		override public function paint(component:Component, bounds:IntRectangle):void
		{
			super.paint(component, bounds);
			
			paintImage(scaleImage.scaleType, bounds);
		}
		
		private function paintImage(st:int, bounds:IntRectangle):void
		{
			var scaleType:int = st;
			var sourceSize:IntDimension = IntRectangle.creatWithRectangle(sourceBitmapData.rect).getSize();
			var drawedSize:IntDimension = bounds.getSize();
			
			var old:BitmapData = bmp.bitmapData;
			
			bmp.bitmapData = new BitmapData(drawedSize.width, drawedSize.height, true, 0);
			
			var bmd:BitmapData = bmp.bitmapData;
			
			bmd.lock();
			
			if(scaleType == AbstractImage.TILE_SCALE)
			{
				tileOther(bmd, drawedSize, TOP_CENTER);
				tileOther(bmd, drawedSize, MIDDLE_RIGHT);
				tileOther(bmd, drawedSize, BOTTOM_CENTER);
				tileOther(bmd, drawedSize, MIDDLE_LEFT);
				tileOther(bmd, drawedSize, MIDDLE_CENTER);
			}
			else
			{
				drawOther(bmd, drawedSize, TOP_CENTER);
				drawOther(bmd, drawedSize, MIDDLE_RIGHT);
				drawOther(bmd, drawedSize, BOTTOM_CENTER);
				drawOther(bmd, drawedSize, MIDDLE_LEFT);
				drawOther(bmd, drawedSize, MIDDLE_CENTER);
			}
			
			drawCorner(bmd, drawedSize, TOP_LEFT);
			drawCorner(bmd, drawedSize, TOP_RIGHT);
			drawCorner(bmd, drawedSize, BOTTOM_LEFT);
			drawCorner(bmd, drawedSize, BOTTOM_RIGHT);
			
			bmd.unlock();
			
			GC.collect();
		}
		
		private function tileOther(bmd:BitmapData, drawedSize:IntDimension, part:int):void
		{
			var scaleInsets:Insets = scaleImage.scaleInsets;
			var sourceSize:IntDimension = IntRectangle.creatWithRectangle(sourceBitmapData.rect).getSize();
			
			var copySourceRect:IntRectangle = getGridRect(sourceSize, scaleInsets, part);
			var destTargetRect:IntRectangle = getGridRect(drawedSize, scaleInsets, part);
			
			if(destTargetRect.width <= 0 || destTargetRect.height <= 0) return;
			
			var b:BitmapData = new BitmapData(copySourceRect.width, copySourceRect.height, true, 0);
			
			b.copyPixels(sourceBitmapData, copySourceRect.toRectangle(), Constant.ZeroPoint);
			
			var point:Point = new Point();
			
			//使用新的BitmapData防止大小超出
			var bd:BitmapData = new BitmapData(destTargetRect.width, destTargetRect.height, true, 0);
			
			for(point.x = 0; point.x < destTargetRect.width; point.x += b.width, point.y = 0)
			{
				for(point.y = 0; point.y < destTargetRect.height; point.y += b.height)
				{
					bd.copyPixels(b, b.rect, point);
				}
			}
			
			point.x = destTargetRect.x;
			point.y = destTargetRect.y;
			
			bmd.copyPixels(bd, bd.rect, point);
			
			DisposeUtil.free(b);
			b = null;
			
			DisposeUtil.free(bd);
			bd = null;
		}
		
		private function drawOther(bmd:BitmapData, drawedSize:IntDimension, part:int):void
		{
			var scaleInsets:Insets = scaleImage.scaleInsets;
			var sourceSize:IntDimension = IntRectangle.creatWithRectangle(sourceBitmapData.rect).getSize();
			
			var copySourceRect:IntRectangle = getGridRect(sourceSize, scaleInsets, part);
			var destTargetRect:IntRectangle = getGridRect(drawedSize, scaleInsets, part);
			
			if(destTargetRect.width <= 0 || destTargetRect.height <= 0) return;
			
			var b:BitmapData = new BitmapData(copySourceRect.width, copySourceRect.height, true, 0);
			
			b.copyPixels(sourceBitmapData, copySourceRect.toRectangle(), Constant.ZeroPoint);
			
			var matrix:Matrix = new Matrix();
			var sx:Number = destTargetRect.width / copySourceRect.width;
			var sy:Number = destTargetRect.height / copySourceRect.height;
			
			matrix.scale(sx, sy);
			matrix.translate(destTargetRect.x, destTargetRect.y);
			
			bmd.draw(b, matrix);
			
			DisposeUtil.free(b);
			b = null;
		}
		
		private function drawCorner(bmd:BitmapData, drawedSize:IntDimension, part:int):void
		{
			var scaleInsets:Insets = scaleImage.scaleInsets;
			var sourceSize:IntDimension = IntRectangle.creatWithRectangle(sourceBitmapData.rect).getSize();
			
			var copySourceRect:IntRectangle = getGridRect(sourceSize, scaleInsets, part);
			var destTargetRect:IntRectangle = getGridRect(drawedSize, scaleInsets, part);
			
			if(destTargetRect.width <= 0 || destTargetRect.height <= 0) return;
			
			bmd.copyPixels(sourceBitmapData, copySourceRect.toRectangle(), destTargetRect.getLocation().toPoint());
		}
		
		override public function dispose():void
		{
			DisposeUtil.free(bmp);
			bmp = null;
			
			sourceBitmapData = null;
			
			scaleImage = null;
			
			super.dispose();
		}
	}
}