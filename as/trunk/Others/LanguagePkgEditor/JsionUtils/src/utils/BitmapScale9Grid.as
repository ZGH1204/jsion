package utils
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.geom.Rectangle;
    import flash.geom.Point;
	
	/**
	 * Bitmap划分九宫格
	 * @author jsion
	 * 
	 */	
	public class BitmapScale9Grid extends Sprite
	{
		private var source : Bitmap;/* 要划分九宫格的原始图片 */
        private var scaleGridTop : Number; /* 九宫格上面部分的高度 */
        private var scaleGridBottom : Number; /* 九宫格下面部分的高度 */
        private var scaleGridLeft : Number; /* 九宫格左边部分的高度 */
        private var scaleGridRight : Number; /* 九宫格右边部分的高度 */
        
        private var leftUp : Bitmap; /* 左上部分 */
        private var leftCenter : Bitmap; /* 左中部分 */
        private var leftBottom : Bitmap; /* 左下部分 */
        private var centerUp : Bitmap; /* 中上部分 */
        private var center : Bitmap; /* 中间部分 */
        private var centerBottom : Bitmap; /* 中下部分 */
        private var rightUp : Bitmap; /* 右上部分 */
        private var rightCenter : Bitmap; /* 右中部分 */
        private var rightBottom : Bitmap; /* 右下部分 */
        
        private var _width : Number; /* 宽度 */
        private var _height : Number; /* 高度 */
        
        private var minWidth : Number; /* 最小宽度 */
        private var minHeight : Number; /* 最小高度 */
		
		public function BitmapScale9Grid(source:Bitmap, scaleGridTop:Number, scaleGridBottom:Number, scaleGridLeft:Number, scaleGridRight:Number)
		{
			this.source = source;
            this.scaleGridTop = scaleGridTop;
            this.scaleGridBottom = scaleGridBottom;
            this.scaleGridLeft = scaleGridLeft;
            this.scaleGridRight = scaleGridRight;
            init();
		}
		
		private function init() : void {
            _width = source.width;
            _height = source.height;
            
            leftUp = getBitmap(0, 0, scaleGridLeft, scaleGridTop);
            this.addChild(leftUp);
            
            leftCenter = getBitmap(0, scaleGridTop, scaleGridLeft, scaleGridBottom - scaleGridTop);
            this.addChild(leftCenter);
            
            leftBottom = getBitmap(0, scaleGridBottom, scaleGridLeft, source.height - scaleGridBottom);
            this.addChild(leftBottom);
            
            centerUp = getBitmap(scaleGridLeft, 0, scaleGridRight - scaleGridLeft, scaleGridTop);
            this.addChild(centerUp);
            
            center = getBitmap(scaleGridLeft, scaleGridTop, scaleGridRight - scaleGridLeft, scaleGridBottom - scaleGridTop);
            this.addChild(center);
            
            centerBottom = getBitmap(scaleGridLeft, scaleGridBottom, scaleGridRight - scaleGridLeft, source.height - scaleGridBottom);
            this.addChild(centerBottom);
            
            rightUp = getBitmap(scaleGridRight, 0, source.width - scaleGridRight, scaleGridTop);
            this.addChild(rightUp);
            
            rightCenter = getBitmap(scaleGridRight, scaleGridTop, source.width - scaleGridRight, scaleGridBottom - scaleGridTop);
            this.addChild(rightCenter);
            
            rightBottom = getBitmap(scaleGridRight, scaleGridBottom, source.width - scaleGridRight, source.height - scaleGridBottom);
            this.addChild(rightBottom);
            
            minWidth = leftUp.width + rightBottom.width;
            minHeight = leftBottom.height + rightBottom.height;
        }
		
		private function getBitmap(x:Number, y:Number, w:Number, h:Number) : Bitmap {
            var bit:BitmapData = new BitmapData(w, h);
            bit.copyPixels(source.bitmapData, new Rectangle(x, y, w, h), new Point(0, 0));
            var bitMap:Bitmap = new Bitmap(bit);
            bitMap.x = x;
            bitMap.y = y;
            return bitMap;
        }
        
        override public function set width(w : Number) : void {
            if(w < minWidth) {
                w = minWidth;
            }
            _width = w;
            refurbishSize();
        }
        
        override public function set height(h : Number) : void {
            if(h < minHeight) {
                h = minHeight;
            }
            _height = h;
            refurbishSize();
        }
        
        private function refurbishSize() : void {
            leftCenter.height = _height - leftUp.height - leftBottom.height;
            leftBottom.y = _height - leftBottom.height;
            centerUp.width = _width - leftUp.width - rightUp.width;
            center.width = centerUp.width;
            center.height = leftCenter.height;
            centerBottom.width = center.width;
            centerBottom.y = leftBottom.y;
            rightUp.x = _width - rightUp.width;
            rightCenter.x = rightUp.x;
            rightCenter.height = center.height;
            rightBottom.x = rightUp.x;
            rightBottom.y = leftBottom.y;
        }
	}
}