package jui.org.coms.img
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
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
			GC.collect();
		}
		
		protected function paintAsset(bound:IntRectangle):void
		{
			
		}
		
		
		//左上
		protected function getTopLeftRect(size:IntDimension):IntRectangle
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