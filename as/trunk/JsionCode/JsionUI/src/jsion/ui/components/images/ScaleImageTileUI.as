package jsion.ui.components.images
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	import jsion.ui.Component;
	
	import jsion.utils.DisposeUtil;

	public class ScaleImageTileUI extends BasicScaleImageUI
	{
		private var sourceBitmapData:BitmapData;
		private var scaleImage:ScaleImageTile;
		
		private var bmpList:Array = [];
		
		private var bmdList:Array = [];
		
		public function ScaleImageTileUI()
		{
			super();
		}
		
		override public function install(component:Component):void
		{
			scaleImage = component as ScaleImageTile;
			
			sourceBitmapData = scaleImage.sourceBitmapData;
		}
		
		override public function uninstall(component:Component):void
		{
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
			DisposeUtil.free(bmpList, false);
			
			DisposeUtil.free(bmdList);
			
			var tiledSize:IntDimension = bounds.getSize();
			var sourceSize:IntDimension = IntRectangle.creatWithRectangle(sourceBitmapData.rect).getSize();
			
			if(scaleImage.scaleType == AbstractImage.TILE_SCALE)
			{
				tileBmp(sourceSize, tiledSize, TOP_CENTER);
				tileBmp(sourceSize, tiledSize, MIDDLE_RIGHT);
				tileBmp(sourceSize, tiledSize, BOTTOM_CENTER);
				tileBmp(sourceSize, tiledSize, MIDDLE_LEFT);
				tileBmp(sourceSize, tiledSize, MIDDLE_CENTER);
			}
			else
			{
				var r:IntRectangle;
				var tc:Bitmap, mr:Bitmap, bc:Bitmap, ml:Bitmap, mc:Bitmap;
				
				tc = createBmp(sourceSize, tiledSize, TOP_CENTER);
				mr = createBmp(sourceSize, tiledSize, MIDDLE_RIGHT);
				bc = createBmp(sourceSize, tiledSize, BOTTOM_CENTER);
				ml = createBmp(sourceSize, tiledSize, MIDDLE_LEFT);
				mc = createBmp(sourceSize, tiledSize, MIDDLE_CENTER);
				
				if(tc)
				{
					r = getGridRect(tiledSize, scaleImage.scaleInsets, TOP_CENTER);
					tc.width = r.width;
					tc.height = r.height;
				}
				
				if(mr)
				{
					r = getGridRect(tiledSize, scaleImage.scaleInsets, MIDDLE_RIGHT);
					mr.width = r.width;
					mr.height = r.height;
				}
				
				if(bc)
				{
					r = getGridRect(tiledSize, scaleImage.scaleInsets, BOTTOM_CENTER);
					bc.width = r.width;
					bc.height = r.height;
				}
				
				if(ml)
				{
					r = getGridRect(tiledSize, scaleImage.scaleInsets, MIDDLE_LEFT);
					ml.width = r.width;
					ml.height = r.height;
				}
				
				if(mc)
				{
					r = getGridRect(tiledSize, scaleImage.scaleInsets, MIDDLE_CENTER);
					mc.width = r.width;
					mc.height = r.height;
				}
			}
			
			createBmp(sourceSize, tiledSize, TOP_LEFT);
			createBmp(sourceSize, tiledSize, TOP_RIGHT);
			createBmp(sourceSize, tiledSize, BOTTOM_LEFT);
			createBmp(sourceSize, tiledSize, BOTTOM_RIGHT);
		}
		
		private function tileBmp(sourceSize:IntDimension, tiledSize:IntDimension, part:int):void
		{
			var p:IntPoint;
			var op:IntPoint;
			var r:IntRectangle;
			var bmd:BitmapData;
			var bmp:Bitmap;
			
			
			r = getGridRect(sourceSize, scaleImage.scaleInsets, part);
			if(r.width <= 0 || r.height <= 0) return;
			bmd = new BitmapData(r.width, r.height, true, 0);
			bmd.copyPixels(sourceBitmapData, r.toRectangle(), Constant.ZeroPoint);
			bmdList.push(bmd);
			
			r = getGridRect(tiledSize, scaleImage.scaleInsets, part);
			if(r.width <= 0 || r.height <= 0) return;
			p = r.getLocation();
			op = r.getLocation();
			
			var xCount:int = r.width / bmd.width;
			var xOther:Boolean = (r.width % bmd.width) != 0;
			
			var yCount:int = r.height / bmd.height;
			var yOther:Boolean = (r.height % bmd.height) != 0;
			
			p.x = op.x;
			for(var i:int = 0; i < xCount; i++, p.x += bmd.width)
			{
				p.y = op.y;
				for(var j:int = 0; j < yCount; j++, p.y += bmd.height)
				{
					bmp = new Bitmap(bmd);
					bmp.x = p.x;
					bmp.y = p.y;
					bmpList.push(bmp);
					scaleImage.addChild(bmp);
				}
				
			}
			var bd:BitmapData;
			if(xOther)
			{
				p.x = bmd.width * xCount;
				p.x += op.x;
				bd = new BitmapData(r.width - bmd.width * xCount, bmd.height, true, 0);
				bd.copyPixels(bmd, bd.rect, Constant.ZeroPoint);
				bmdList.push(bd);
				p.y = op.y;
				for(var k:int = 0; k < yCount; k++)
				{
					bmp = new Bitmap(bd);
					bmp.x = p.x;
					bmp.y = p.y;
					p.y += bmd.height;
					bmpList.push(bmp);
					scaleImage.addChild(bmp);
				}
			}
			
			if(yOther)
			{
				p.y = bmd.height * yCount;
				p.y += op.y;
				bd = new BitmapData(bmd.width, r.height - bmd.height * yCount, true, 0);
				bd.copyPixels(bmd, bd.rect, Constant.ZeroPoint);
				bmdList.push(bd);
				p.x = op.x;
				for(var l:int = 0; l < xCount; l++)
				{
					bmp = new Bitmap(bd);
					bmp.x = p.x;
					bmp.y = p.y;
					p.x += bmd.width;
					bmpList.push(bmp);
					scaleImage.addChild(bmp);
				}
			}
			
			if(xOther && yOther)
			{
				p.x = bmd.width * xCount;
				p.x += op.x;
				
				p.y = bmd.height * yCount;
				p.y += op.y;
				
				bd = new BitmapData(r.width - bmd.width * xCount, r.height - bmd.height * yCount, true, 0);
				bd.copyPixels(bmd, bd.rect, Constant.ZeroPoint);
				bmdList.push(bd);
				
				bmp = new Bitmap(bd);
				bmp.x = p.x;
				bmp.y = p.y;
				bmpList.push(bmp);
				scaleImage.addChild(bmp);
			}
		}
		
		private function createBmp(sourceSize:IntDimension, tiledSize:IntDimension, part:int):Bitmap
		{
			var bmp:Bitmap;
			var r:IntRectangle;
			
			r = getGridRect(sourceSize, scaleImage.scaleInsets, part);
			if(r.width <= 0 || r.height <= 0) return null;
			bmp = new Bitmap(new BitmapData(r.width, r.height, true, 0));
			bmp.smoothing = true;
			bmp.bitmapData.copyPixels(sourceBitmapData, r.toRectangle(), Constant.ZeroPoint);
			
			r = getGridRect(tiledSize, scaleImage.scaleInsets, part);
			bmp.x = r.x;
			bmp.y = r.y;
			
			scaleImage.addChild(bmp);
			bmpList.push(bmp);
			bmdList.push(bmp.bitmapData);
			
			return bmp;
		}
		
		override public function dispose():void
		{
			DisposeUtil.free(bmpList, false);
			
			DisposeUtil.free(bmdList);
			
			sourceBitmapData = null;
			
			scaleImage = null;
			
			super.dispose();
		}
	}
}