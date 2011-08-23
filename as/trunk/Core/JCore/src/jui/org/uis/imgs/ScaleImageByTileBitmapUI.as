package jui.org.uis.imgs
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import jui.org.Component;
	import jui.org.Graphics2D;
	import jui.org.coms.img.Scale9Image;
	
	import jutils.org.util.DisposeUtil;

	public class ScaleImageByTileBitmapUI extends BasicImageUI
	{
		//左上、右上、右下、左下
		protected var corner:Array = [];
		
		protected var middleLeft:Bitmap;
		protected var topCenter:Bitmap;
		protected var middleRight:Bitmap;
		protected var bottomCenter:Bitmap;
		protected var middleCenter:Bitmap;
		
		private var scale9Type:int;
		
		private var tileBmp:Array = [];
		
		private var bmdList:Array = [];
		
		private var container:Component;
		
		private var displaySize:IntDimension;
		
		public function ScaleImageByTileBitmapUI()
		{
			super();
		}
		
		override public function installUI(component:Component):void
		{
			middleLeft = new Bitmap(null, PixelSnapping.AUTO, true);
			component.addChild(middleLeft);
			
			topCenter = new Bitmap(null, PixelSnapping.AUTO, true);
			component.addChild(topCenter);
			
			middleRight = new Bitmap(null, PixelSnapping.AUTO, true);
			component.addChild(middleRight);
			
			bottomCenter = new Bitmap(null, PixelSnapping.AUTO, true);
			component.addChild(bottomCenter);
			
			middleCenter = new Bitmap(null, PixelSnapping.AUTO, true);
			component.addChild(middleCenter);
			
			corner.push(new Bitmap());
			component.addChild(corner[0]);
			
			corner.push(new Bitmap());
			component.addChild(corner[1]);
			
			corner.push(new Bitmap());
			component.addChild(corner[2]);
			
			corner.push(new Bitmap());
			component.addChild(corner[3]);
		}
		
		override public function uninstallUI(component:Component):void
		{
			clearTiles();
			
			DisposeUtil.free(middleLeft);
			middleLeft = null;
			
			DisposeUtil.free(topCenter);
			middleLeft = null;
			
			DisposeUtil.free(middleRight);
			middleLeft = null;
			
			DisposeUtil.free(bottomCenter);
			middleLeft = null;
			
			DisposeUtil.free(middleCenter);
			middleLeft = null;
			
			DisposeUtil.free(corner);
			corner = null;
			
			container = null;
			
			displaySize = null;
		}
		
		override public function paint(component:Component, graphics:Graphics2D, bound:IntRectangle):void
		{
			paintAsset(component, bound);
		}
		
		
		protected function paintAsset(component:Component, bound:IntRectangle):void
		{
			var img:Scale9Image = Scale9Image(component);
			var size:IntDimension = img.getSize();
			
			container = img;
			scale9Type = img.getScale9Type();
			
			if(img.isChanged() == false && size.equals(displaySize)) return;
			
			updatePos(img);
			
			updateAsset(img);
			
			displaySize = size;
		}
		
		protected function updatePos(img:Scale9Image):void
		{
			var s:IntDimension = img.getSize();
			var assetInsets:Insets = img.getAssetInsets();
			
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
		
		protected function updateAsset(img:Scale9Image):void
		{
			clearTiles();
			
			var sourceBmd:BitmapData = img.getSourceBmd();
			var s:IntDimension = img.getSize();
			var sourceSize:IntDimension = new IntDimension(sourceBmd.width, sourceBmd.height);
			
			updateCornerAsset(corner[0], sourceBmd, img.getTopLeftRect(sourceSize));
			
			updateCornerAsset(corner[1], sourceBmd, img.getTopRightRect(sourceSize));
			
			updateCornerAsset(corner[2], sourceBmd, img.getBottomRightRect(sourceSize));
			
			updateCornerAsset(corner[3], sourceBmd, img.getBottomLeftRect(sourceSize));
			
			updateScaleAsset(middleLeft, sourceBmd, img.getMiddleLeftRect(sourceSize), img.getMiddleLeftRect(s));
			
			updateScaleAsset(topCenter, sourceBmd, img.getTopCenterRect(sourceSize), img.getTopCenterRect(s));
			
			updateScaleAsset(middleRight, sourceBmd, img.getMiddleRightRect(sourceSize), img.getMiddleRightRect(s));
			
			updateScaleAsset(bottomCenter, sourceBmd, img.getBottomCenterRect(sourceSize), img.getBottomCenterRect(s));
			
			updateScaleAsset(middleCenter, sourceBmd, img.getMiddleCenterRect(sourceSize), img.getMiddleCenterRect(s));
		}
		
		protected function clearTiles():void
		{
			while(tileBmp && tileBmp.length > 0)
			{
				DisposeUtil.free(tileBmp.pop(), false);
			}
			
			while(bmdList && bmdList.length > 0)
			{
				DisposeUtil.free(bmdList.pop());
			}
		}
		
		private function updateCornerAsset(bmp:Bitmap, sBmd:BitmapData, r:IntRectangle):void
		{
			var old:BitmapData = bmp.bitmapData;
			
			var bmd:BitmapData = new BitmapData(r.width, r.height, true, 0);
			
			bmd.copyPixels(sBmd, r.toRectangle(), Constant.ZeroPoint);
			
			bmp.bitmapData = bmd;
			
			DisposeUtil.free(old);
		}
		
		private function updateScaleAsset(bmp:Bitmap, sBmd:BitmapData, sRect:IntRectangle, r:IntRectangle):void
		{
			var tmp:BitmapData = new BitmapData(sRect.width, sRect.height, true, 0);
			tmp.copyPixels(sBmd, sRect.toRectangle(), Constant.ZeroPoint);
			
			if(scale9Type == Scale9Image.SCALE_TILE)
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
						container.addChild(b);
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
						container.addChild(b);
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
						container.addChild(b);
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
					container.addChild(b);
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
		
		
		override public function dispose():void
		{
			uninstallUI(null);
			
			tileBmp = null;
			bmdList = null;
			container = null;
			displaySize = null;
			
			super.dispose();
		}
	}
}