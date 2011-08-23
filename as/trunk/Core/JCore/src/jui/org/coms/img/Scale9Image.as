package jui.org.coms.img
{
	import flash.display.BitmapData;
	
	import jui.org.DefaultUI;
	import jui.org.uis.imgs.BasicImageUI;
	
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
		
		protected var scale9Type:int;
		
		public function Scale9Image(bmd:BitmapData = null, assetInset:Insets = null)
		{
			super(bmd.clone());
			
			scale9Type = SCALE_STRETCHED;
			
			setAssetInsets(assetInset);
			
			updateUI();
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
			super.paint(bound);
			changed = false;
			GC.collect();
		}
		
		override public function getDefaultBasicUIClass():Class
		{
			return BasicImageUI;
		}
		
		override protected function getDefaultUIClassID():String
		{
			return DefaultUI.Scale9ImageUI;
		}
		
		
		//左上
		public function getTopLeftRect(size:IntDimension):IntRectangle
		{
			var rect:IntRectangle = new IntRectangle();
			
			rect.width = assetInsets.left;
			rect.height = assetInsets.top;
			
			return rect;
		}
		
		//上中
		public function getTopCenterRect(size:IntDimension):IntRectangle
		{
			var rect:IntRectangle = new IntRectangle();
			
			rect.x = assetInsets.left;
			rect.width = size.width - assetInsets.left;
			rect.width -= assetInsets.right;
			rect.height = assetInsets.top;
			
			return rect;
		}
		
		//右上
		public function getTopRightRect(size:IntDimension):IntRectangle
		{
			var rect:IntRectangle = new IntRectangle();
			
			rect.x = size.width - assetInsets.right;
			rect.width = assetInsets.right;
			rect.height = assetInsets.top;
			
			return rect;
		}
		
		//左中
		public function getMiddleLeftRect(size:IntDimension):IntRectangle
		{
			var rect:IntRectangle = new IntRectangle();
			
			rect.y = assetInsets.top;
			rect.width = assetInsets.left;
			rect.height = size.height - assetInsets.top;
			rect.height -= assetInsets.bottom;
			
			return rect;
		}
		
		//中间
		public function getMiddleCenterRect(size:IntDimension):IntRectangle
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
		public function getMiddleRightRect(size:IntDimension):IntRectangle
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
		public function getBottomLeftRect(size:IntDimension):IntRectangle
		{
			var rect:IntRectangle = new IntRectangle();
			
			rect.y = size.height - assetInsets.bottom;
			rect.width = assetInsets.left;
			rect.height = assetInsets.bottom;
			
			return rect;
		}
		
		//下中
		public function getBottomCenterRect(size:IntDimension):IntRectangle
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
		public function getBottomRightRect(size:IntDimension):IntRectangle
		{
			var rect:IntRectangle = new IntRectangle();
			
			rect.x = size.width - assetInsets.right;
			rect.y = size.height - assetInsets.bottom;
			rect.width = assetInsets.right;
			rect.height = assetInsets.bottom;
			
			return rect;
		}
		
		override public function dispose():void
		{
			assetInsets = null;
			
			super.dispose();
		}
	}
}