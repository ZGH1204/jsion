package jui.org.coms.img
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import jutils.org.util.DisposeUtil;
	
	public class ScaleImageByTileBitmap extends Scale9Image
	{
		protected var corner:Array = [];
		
		protected var middleLeft:Bitmap;
		protected var topCenter:Bitmap;
		protected var middleRight:Bitmap;
		protected var bottomCenter:Bitmap;
		protected var middleCenter:Bitmap;
		
		public function ScaleImageByTileBitmap(bmd:BitmapData=null, assetInset:Insets=null)
		{
			middleLeft = new Bitmap(null, PixelSnapping.AUTO, true);
			addChild(middleLeft);
			topCenter = new Bitmap(null, PixelSnapping.AUTO, true);
			addChild(topCenter);
			middleRight = new Bitmap(null, PixelSnapping.AUTO, true);
			addChild(middleRight);
			bottomCenter = new Bitmap(null, PixelSnapping.AUTO, true);
			addChild(bottomCenter);
			middleCenter = new Bitmap(null, PixelSnapping.AUTO, true);
			addChild(middleCenter);
			
			corner.push(new Bitmap());
			addChild(corner[0]);
			corner.push(new Bitmap());
			addChild(corner[1]);
			corner.push(new Bitmap());
			addChild(corner[2]);
			corner.push(new Bitmap());
			addChild(corner[3]);
			
			super(bmd, assetInset);
			
			DisposeUtil.free(bmp, false);
		}
		
		override protected function paintAsset(bound:IntRectangle):void
		{
			var size:IntDimension = getSize();
			var displaySize:IntDimension = new IntDimension(bmp.width, bmp.height);
			
			if(changed == false && size.equals(displaySize)) return;
			
			changed = false;
			
			updatePos();
			
			updateAsset();
		}
		
		protected function updatePos():void
		{
			var s:IntDimension = getSize();
			
			corner[0].x = 0;
			corner[0].y = 0;
			
			corner[1].x = s.width - assetInsets.right;
			corner[1].y = 0;
			
			corner[2].x = s.width - assetInsets.right;
			corner[2].y = s.height - assetInsets.bottom;
			
			corner[3].x = 0;
			corner[3].y = s.height - assetInsets.bottom;
			
			middleLeft.x = 0;
			middleLeft.y = assetInsets.top;
			
			topCenter.x = assetInsets.left;
			topCenter.y = 0;
			
			middleRight.x = s.width - assetInsets.right;
			middleRight.y = assetInsets.top;
			
			bottomCenter.x = s.width - assetInsets.left;
			bottomCenter.y = s.height - assetInsets.bottom;
		}
		
		protected var tileBmp:Array = [];
		
		protected function updateAsset():void
		{
			var s:IntDimension = getSize();
			var sourceSize:IntDimension = new IntDimension(sourceBmd.width, sourceBmd.height);
			
			updateCornerAsset(corner[0], sourceBmd, getTopLeftRect(sourceSize));
			
			updateCornerAsset(corner[1], sourceBmd, getTopRightRect(sourceSize));
			
			updateCornerAsset(corner[2], sourceBmd, getBottomRightRect(sourceSize));
			
			updateCornerAsset(corner[3], sourceBmd, getBottomLeftRect(sourceSize));
			
			while(tileBmp && tileBmp.length > 0)
			{
				DisposeUtil.free(tileBmp.pop(), false);
			}
			
			while(bmdList && bmdList.length > 0)
			{
				DisposeUtil.free(bmdList.pop());
			}
			
			updateScaleAsset(middleLeft, sourceBmd, getMiddleLeftRect(sourceSize), getMiddleLeftRect(s));
			
			updateScaleAsset(topCenter, sourceBmd, getTopCenterRect(sourceSize), getTopCenterRect(s));
			
			updateScaleAsset(middleRight, sourceBmd, getMiddleRightRect(sourceSize), getMiddleRightRect(s));
			
			updateScaleAsset(bottomCenter, sourceBmd, getBottomCenterRect(sourceSize), getBottomCenterRect(s));
			
			updateScaleAsset(middleCenter, sourceBmd, getMiddleCenterRect(sourceSize), getMiddleCenterRect(s));
		}
		
		private function updateCornerAsset(bmp:Bitmap, sBmd:BitmapData, r:IntRectangle):void
		{
			var old:BitmapData = bmp.bitmapData;
			
			var bmd:BitmapData = new BitmapData(r.width, r.height, true, 0);
			
			bmd.copyPixels(sBmd, r.toRectangle(), Constant.ZeroPoint);
			
			bmp.bitmapData = bmd;
			
			DisposeUtil.free(old);
		}
		
		private var bmdList:Array = [];
		
		private function updateScaleAsset(bmp:Bitmap, sBmd:BitmapData, sRect:IntRectangle, r:IntRectangle):void
		{
			var tmp:BitmapData = new BitmapData(sRect.width, sRect.height, true, 0);
			tmp.copyPixels(sBmd, sRect.toRectangle(), Constant.ZeroPoint);
			
			if(scale9Type == SCALE_TILE)
			{
				bmdList.push(tmp);
				
				var xCount:int = r.width / sRect.width;
				var xOther:int = r.width % sRect.width;
				var xLast:Boolean = (xOther > 0);
				
				var yCount:int = r.height / sRect.height;
				var yOther:int = r.height % sRect.height;
				var yLast:Boolean = (yOther > 0);
				
				var b:Bitmap;
				var point:Point = r.getLocation().toPoint();
				
				for (var i:int = 0; i < xCount; i++)
				{
					for(var j:int = 0; j < yCount; j++)
					{
						b = new Bitmap(tmp);
						b.x = point.x + (i * b.width);
						b.y = point.y + (j * b.height);
						addChild(b);
						tileBmp.push(b);
					}
				}
				
				if(xLast)
				{
					var rightBmd:BitmapData = new BitmapData(r.width - sRect.width * xCount, sRect.height, true, 0);
					rightBmd.copyPixels(sBmd, new Rectangle(sRect.x, sRect.y, rightBmd.width, rightBmd.height), Constant.ZeroPoint);
					bmdList.push(rightBmd);
					
					point.x = r.x + sRect.width * xCount;
					point.y = r.y;
					
					for(var k:int = 0; k < yCount; k++)
					{
						b = new Bitmap(rightBmd);
						b.x = point.x;
						b.y = point.y;
						addChild(b);
						tileBmp.push(b);
						
						point.y += b.height;
					}
				}
				
				if(yLast)
				{
					var bottomBmd:BitmapData = new BitmapData(sRect.width, r.height - sRect.height * yCount, true, 0);
					bottomBmd.copyPixels(sBmd, new Rectangle(sRect.x, sRect.y, bottomBmd.width, bottomBmd.height), Constant.ZeroPoint);
					bmdList.push(bottomBmd);
					
					point.x = r.x;
					point.y = r.y + sRect.height * yCount;
					
					for(var l:int = 0; l < xCount; l++)
					{
						b = new Bitmap(bottomBmd);
						b.x = point.x;
						b.y = point.y;
						addChild(b);
						tileBmp.push(b);
						
						point.x += b.width;
					}
				}
				
				if(xLast && yLast)
				{
					var brBmd:BitmapData = new BitmapData(r.width - sRect.width * xCount, r.height - sRect.height * yCount, true, 0);
					brBmd.copyPixels(sBmd, new Rectangle(sRect.x, sRect.y, brBmd.width, brBmd.height), Constant.ZeroPoint);
					bmdList.push(brBmd);
					
					point.x = r.x + sRect.width * xCount;
					point.y = r.y + sRect.height * yCount;
					
					b = new Bitmap(bottomBmd);
					b.x = point.x;
					b.y = point.y;
					addChild(b);
					tileBmp.push(b);
				}
			}
			else
			{
				var old:BitmapData = bmp.bitmapData;
				bmp.bitmapData = tmp;
				bmp.x = r.x;
				bmp.y = r.y;
				bmp.width = r.width;
				bmp.height = r.height;
				DisposeUtil.free(old);
			}
		}
	}
}