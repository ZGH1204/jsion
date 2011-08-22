package jui.org.coms.img
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import jutils.org.util.DisposeUtil;
	
	public class Scale9Image extends Image
	{
		/**
		 * 平铺方式的九宫格
		 */		
		public static const SCALE_TILE:int = 1;
		
		/**
		 * 拉伸方式的九宫格
		 */		
		public static const SCALE_STRETCHED:int = 2;
		
		/**
		 * 四边距(左、上、右、下)
		 */		
		protected var assetInsets:Insets;
		
		protected var changed:Boolean;
		
		protected var scale9Type:int;
		
		public function Scale9Image(bmd:BitmapData = null, assetInset:Insets = null)
		{
			super(bmd.clone());
			
			changed = false;
			
			scale9Type = SCALE_STRETCHED;
			
			setAssetInsets(assetInset);
		}
		
		public function getScale9Type():int
		{
			return scale9Type;
		}
		
		public function setScale9Type(value:int):void
		{
			if(value != SCALE_STRETCHED && value != SCALE_TILE)
			{
				throw new ArgumentError("The argument must be Scale9Image.SCALE_TILE or Scale9Image.SCALE_STRETCHED.");
				return;
			}
			
			scale9Type = value;
			
			changed = true;
			
			repaint();
		}
		
		public function getAssetInsets():Insets
		{
			return assetInsets;
		}
		
		public function setAssetInsets(assetInset:Insets):void
		{
			if (assetInsets && assetInsets.left == assetInset.left && 
			   	assetInsets.top == assetInset.top && 
				assetInsets.right == assetInset.right && 
				assetInsets.bottom == assetInset.bottom) return;
			
			assetInsets = assetInset;
			
			if(assetInsets == null) assetInsets = new Insets(10, 10, 10, 10);
			
			changed = true;
			
			repaint();
			revalidate();
		}
		
		override public function setAsset(bmd:BitmapData = null):void
		{
			if(bmp && sourceBmd != bmd)
			{
				sourceBmd = bmd;
				
				changed = true;
				
				bmp.bitmapData = bmd;
				
				if(bmp.parent == null)
				{
					addChild(bmp);
				}
				
				var size:IntDimension = getSize();
				
				if(size.width > 0 && size.height > 0)
				{
					this.size();
				}
				else
				{
					setSizeWH(bmp.width, bmp.height);
				}
			}
		}
		
		override protected function paint(bound:IntRectangle):void
		{
			paintAsset(bound);
			super.paint(bound);
		}
		
		protected function paintAsset(bound:IntRectangle):void
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
		
		protected function drawScaleRect(sourceBmd:BitmapData, sourceRect:IntRectangle, drawRect:IntRectangle):BitmapData
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
		
		
		//左上
		protected function getTopLeftRect(size:IntDimension):IntRectangle
		{
			var rect:IntRectangle = new IntRectangle();
			
			rect.width = assetInsets.left;
			rect.height = assetInsets.top;
			
			return rect;
		}
		
		protected function getTopLeftRectSource(size:IntDimension):IntRectangle
		{
			var rect:IntRectangle = new IntRectangle();
			
			rect.width = assetInsets.left;
			rect.height = assetInsets.top;
			
			return rect;
		}
		
		//上中
		protected function getTopCenterRect(size:IntDimension):IntRectangle
		{
			var rect:IntRectangle = new IntRectangle();
			
			rect.x = assetInsets.left;
			rect.width = size.width - assetInsets.left;
			rect.width -= assetInsets.right;
			rect.height = assetInsets.top;
			
			return rect;
		}
		
		//右上
		protected function getTopRightRect(size:IntDimension):IntRectangle
		{
			var rect:IntRectangle = new IntRectangle();
			
			rect.x = size.width - assetInsets.right;
			rect.width = assetInsets.right;
			rect.height = assetInsets.top;
			
			return rect;
		}
		
		//左中
		protected function getMiddleLeftRect(size:IntDimension):IntRectangle
		{
			var rect:IntRectangle = new IntRectangle();
			
			rect.y = assetInsets.top;
			rect.width = assetInsets.left;
			rect.height = size.height - assetInsets.top;
			rect.height -= assetInsets.bottom;
			
			return rect;
		}
		
		//中间
		protected function getMiddleCenterRect(size:IntDimension):IntRectangle
		{
			var rect:IntRectangle = new IntRectangle();
			
			rect.x = assetInsets.left;
			rect.y = assetInsets.top;
			
			rect.width = size.width - assetInsets.left;
			rect.width -= assetInsets.right;
			
			rect.height = size.height - assetInsets.top;
			rect.height -= assetInsets.bottom;
			
			return rect;
		}
		
		//右中
		protected function getMiddleRightRect(size:IntDimension):IntRectangle
		{
			var rect:IntRectangle = new IntRectangle();
			
			rect.x = size.width - assetInsets.right;
			rect.y = assetInsets.top;
			
			rect.width = assetInsets.right;
			rect.height = size.height - assetInsets.top;
			rect.height -= assetInsets.bottom;
			
			return rect;
		}
		
		//左下
		protected function getBottomLeftRect(size:IntDimension):IntRectangle
		{
			var rect:IntRectangle = new IntRectangle();
			
			rect.y = size.height - assetInsets.bottom;
			rect.width = assetInsets.left;
			rect.height = assetInsets.bottom;
			
			return rect;
		}
		
		//下中
		protected function getBottomCenterRect(size:IntDimension):IntRectangle
		{
			var rect:IntRectangle = new IntRectangle();
			
			rect.x = assetInsets.left;
			rect.y = size.height - assetInsets.bottom;
			rect.width = size.width - assetInsets.left;
			rect.width -= assetInsets.right;
			rect.height = assetInsets.bottom;
			
			return rect;
		}
		
		//右下
		protected function getBottomRightRect(size:IntDimension):IntRectangle
		{
			var rect:IntRectangle = new IntRectangle();
			
			rect.x = size.width - assetInsets.right;
			rect.y = size.height - assetInsets.bottom;
			rect.width = assetInsets.right;
			rect.height = assetInsets.bottom;
			
			return rect;
		}
	}
}