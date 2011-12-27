package jsion.components
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.PixelSnapping;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import jsion.Constant;
	import jsion.Insets;
	import jsion.IntDimension;
	import jsion.IntPoint;
	import jsion.IntRectangle;
	import jsion.comps.CompGlobal;
	import jsion.comps.Component;
	import jsion.utils.DisposeUtil;
	import jsion.utils.MatrixUtil;
	
	public class Image extends Component
	{
		public static const SCALE:String = CompGlobal.SCALE;
		
		public static const TILE:String = CompGlobal.TILE;
		
		private var m_source:BitmapData;
		
		private var m_scale9Grid:Insets;
		
		private var m_scaleType:String;
		
		private var m_bmp:Bitmap;
		
		private var m_bitmapData:BitmapData;
		
		private var m_bmp1:Bitmap;
		private var m_bmp2:Bitmap;
		private var m_bmp3:Bitmap;
		private var m_bmp4:Bitmap;
		private var m_bmp5:Bitmap;
		private var m_bmp6:Bitmap;
		private var m_bmp7:Bitmap;
		private var m_bmp8:Bitmap;
		private var m_bmp9:Bitmap;
		
		public function Image(bmd:BitmapData = null, container:DisplayObjectContainer=null, xPos:Number=0, yPos:Number=0)
		{
			m_source = bmd;
			
			m_scaleType = SCALE;
			
			super(container, xPos, yPos);
		}
		
		public function get source():BitmapData
		{
			return m_source;
		}

		public function set source(value:BitmapData):void
		{
			if(m_source != value)
			{
				m_source = value;
				
				invalidate();
			}
		}

		public function get scale9Grids():Insets
		{
			return m_scale9Grid;
		}

		public function set scale9Grids(value:Insets):void
		{
			m_scale9Grid = value;
			
			invalidate();
		}

		public function get scaleType():String
		{
			return m_scaleType;
		}

		public function set scaleType(value:String):void
		{
			if(m_scaleType != value)
			{
				m_scaleType = value;
				
				invalidate();
			}
		}

		override protected function initialize():void
		{
			if(m_source)
			{
				m_width = m_source.width;
				m_height = m_source.height;
			}
			
			super.initialize();
		}
		
		override public function draw():void
		{
			if(m_source == null) return;
			
			if(m_scale9Grid != null)
			{
				if(m_scaleType == TILE)
				{
					drawTileImage(m_scale9Grid, m_source, m_scaleType);
				}
				else
				{
					drawScaleImage(m_scale9Grid, m_source, m_scaleType);
				}
			}
			else
			{
				if(m_bmp == null)
				{
					m_bmp = new Bitmap();
					addChild(m_bmp);
				}
				
				m_bmp.bitmapData = m_source;
				
				m_bmp.width = m_width;
				m_bmp.height = m_height;
			}
			
			super.draw();
		}
		
		private function drawTileImage(inset:Insets, source:BitmapData, scaleType:String):void
		{
			var sourceBound:IntRectangle = new IntRectangle(0, 0, source.width, source.height);
			var targetBound:IntRectangle = new IntRectangle(0, 0, m_width, m_height);
			
			var sourceRect:IntRectangle;
			var targetRect:IntRectangle;
			
			if(m_bmp == null)
			{
				m_bmp = new Bitmap();
				addChild(m_bmp);
			}
			
			if(m_bitmapData == null)
			{
				if(m_width > 0 && m_height > 0)
				{
					m_bitmapData = createBitmapData(m_bmp);
				}
			}
			else if(m_bitmapData.width != m_width || m_bitmapData.height != m_height)
			{
				if(m_bitmapData != m_source)
					DisposeUtil.free(m_bitmapData);
				
				m_bitmapData = createBitmapData(m_bmp);
			}
			
			
			m_bitmapData.lock();
			m_bitmapData.fillRect(m_bitmapData.rect, 0);
			
			
			//中间区域
			sourceRect = inset.getInsideBounds(sourceBound);
			targetRect = inset.getInsideBounds(targetBound);
			copyTileBmd(m_bitmapData, source, sourceRect, targetRect);
			
			
			
			//上面区域
			sourceRect = inset.getTopBounds(sourceBound);
			targetRect = inset.getTopBounds(targetBound);
			copyTileBmd(m_bitmapData, source, sourceRect, targetRect);
			
			
			
			//下面区域
			sourceRect = inset.getBottomBounds(sourceBound);
			targetRect = inset.getBottomBounds(targetBound);
			copyTileBmd(m_bitmapData, source, sourceRect, targetRect);
			
			
			
			//左面区域
			sourceRect = inset.getLeftBounds(sourceBound);
			targetRect = inset.getLeftBounds(targetBound);
			copyTileBmd(m_bitmapData, source, sourceRect, targetRect);
			
			
			
			//右面区域
			sourceRect = inset.getRightBounds(sourceBound);
			targetRect = inset.getRightBounds(targetBound);
			copyTileBmd(m_bitmapData, source, sourceRect, targetRect);
			
			
			
			//左上角区域
			sourceRect = inset.getLeftTopCornerBounds(sourceBound);
			targetRect = inset.getLeftTopCornerBounds(targetBound);
			copyTileBmd(m_bitmapData, source, sourceRect, targetRect);
			
			
			
			//右上角区域
			sourceRect = inset.getRightTopCornerBounds(sourceBound);
			targetRect = inset.getRightTopCornerBounds(targetBound);
			copyTileBmd(m_bitmapData, source, sourceRect, targetRect);
			
			
			
			//左下角区域
			sourceRect = inset.getLeftBottomCornerBounds(sourceBound);
			targetRect = inset.getLeftBottomCornerBounds(targetBound);
			copyTileBmd(m_bitmapData, source, sourceRect, targetRect);
			
			
			
			//右下角区域
			sourceRect = inset.getRightBottomCornerBounds(sourceBound);
			targetRect = inset.getRightBottomCornerBounds(targetBound);
			copyTileBmd(m_bitmapData, source, sourceRect, targetRect);
			
			m_bitmapData.unlock();
		}
		
		private function createBitmapData(bmp:Bitmap):BitmapData
		{
			var bmd:BitmapData = new BitmapData(m_width, m_height, true, 0);
			bmp.bitmapData = bmd;
			
			return bmd;
		}
		
		private function copyTileBmd(bmd:BitmapData, source:BitmapData, sourceRect:IntRectangle, targetRect:IntRectangle):void
		{
			var p:Point = new Point();
			var r:Rectangle = sourceRect.toRectangle();
			
			var curRect:IntRectangle = new IntRectangle(targetRect.x, targetRect.y, sourceRect.width, sourceRect.height);
			
			for(var j:int = curRect.y; j < (targetRect.y + targetRect.height); j += curRect.height)
			{
				for(var i:int = curRect.x; i < (targetRect.x + targetRect.width); i += curRect.width)
				{
					p.x = i;
					p.y = j;
					
					bmd.copyPixels(source, r, p);
				}
			}
		}
		
		
		
		
		
		private function drawScaleImage(inset:Insets, source:BitmapData, scaleType:String):void
		{
			var sourceBound:IntRectangle = new IntRectangle(0, 0, source.width, source.height);
			var targetBound:IntRectangle = new IntRectangle(0, 0, m_width, m_height);
			
			var sourceRect:IntRectangle;
			var targetRect:IntRectangle;
			
			//中间区域
			sourceRect = inset.getInsideBounds(sourceBound);
			targetRect = inset.getInsideBounds(targetBound);
			DisposeUtil.free(m_bmp1);
			m_bmp1 = copyScaleBmp(source, sourceRect, targetRect);
			addChild(m_bmp1);
			
			
			
			//上面区域
			sourceRect = inset.getTopBounds(sourceBound);
			targetRect = inset.getTopBounds(targetBound);
			DisposeUtil.free(m_bmp2);
			m_bmp2 = copyScaleBmp(source, sourceRect, targetRect);
			addChild(m_bmp2);
			
			
			
			//下面区域
			sourceRect = inset.getBottomBounds(sourceBound);
			targetRect = inset.getBottomBounds(targetBound);
			DisposeUtil.free(m_bmp3);
			m_bmp3 = copyScaleBmp(source, sourceRect, targetRect);
			addChild(m_bmp3);
			
			
			
			//左面区域
			sourceRect = inset.getLeftBounds(sourceBound);
			targetRect = inset.getLeftBounds(targetBound);
			DisposeUtil.free(m_bmp4);
			m_bmp4 = copyScaleBmp(source, sourceRect, targetRect);
			addChild(m_bmp4);
			
			
			
			//右面区域
			sourceRect = inset.getRightBounds(sourceBound);
			targetRect = inset.getRightBounds(targetBound);
			DisposeUtil.free(m_bmp5);
			m_bmp5 = copyScaleBmp(source, sourceRect, targetRect);
			addChild(m_bmp5);
			
			
			
			//左上角区域
			sourceRect = inset.getLeftTopCornerBounds(sourceBound);
			targetRect = inset.getLeftTopCornerBounds(targetBound);
			DisposeUtil.free(m_bmp6);
			m_bmp6 = copyScaleBmp(source, sourceRect, targetRect);
			addChild(m_bmp6);
			
			
			
			//右上角区域
			sourceRect = inset.getRightTopCornerBounds(sourceBound);
			targetRect = inset.getRightTopCornerBounds(targetBound);
			DisposeUtil.free(m_bmp7);
			m_bmp7 = copyScaleBmp(source, sourceRect, targetRect);
			addChild(m_bmp7);
			
			
			
			//左下角区域
			sourceRect = inset.getLeftBottomCornerBounds(sourceBound);
			targetRect = inset.getLeftBottomCornerBounds(targetBound);
			DisposeUtil.free(m_bmp8);
			m_bmp8 = copyScaleBmp(source, sourceRect, targetRect);
			addChild(m_bmp8);
			
			
			
			//右下角区域
			sourceRect = inset.getRightBottomCornerBounds(sourceBound);
			targetRect = inset.getRightBottomCornerBounds(targetBound);
			DisposeUtil.free(m_bmp9);
			m_bmp9 = copyScaleBmp(source, sourceRect, targetRect);
			addChild(m_bmp9);
		}
		
		private function copyScaleBmp(source:BitmapData, sourceRect:IntRectangle, targetRect:IntRectangle):Bitmap
		{
			var tmp:BitmapData = new BitmapData(sourceRect.width, sourceRect.height);
			tmp.copyPixels(source, new Rectangle(sourceRect.x, sourceRect.y, sourceRect.width, sourceRect.height), Constant.ZeroPoint);
			
			var b:Bitmap = new Bitmap(tmp, PixelSnapping.AUTO, true);
			
			b.x = targetRect.x;
			b.y = targetRect.y;
			b.width = targetRect.width;
			b.height = targetRect.height;
			
			return b;
		}
		
		override public function dispose():void
		{
			DisposeUtil.free(m_bmp, false);
			m_bmp = null;
			
			DisposeUtil.free(m_bitmapData);
			m_bitmapData = null;
			
			DisposeUtil.free(m_bmp1);
			m_bmp1 = null;
			
			DisposeUtil.free(m_bmp2);
			m_bmp2 = null;
			
			DisposeUtil.free(m_bmp3);
			m_bmp3= null;
			
			DisposeUtil.free(m_bmp4);
			m_bmp4 = null;
			
			DisposeUtil.free(m_bmp5);
			m_bmp5 = null;
			
			DisposeUtil.free(m_bmp6);
			m_bmp6 = null;
			
			DisposeUtil.free(m_bmp7);
			m_bmp7 = null;
			
			DisposeUtil.free(m_bmp8);
			m_bmp8 = null;
			
			DisposeUtil.free(m_bmp9);
			m_bmp9 = null;
			
			m_source = null;
			m_scale9Grid = null;
			
			super.dispose();
		}
	}
}