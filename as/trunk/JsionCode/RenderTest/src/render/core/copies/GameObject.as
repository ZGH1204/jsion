package render.core.copies
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class GameObject
	{
		public var renderObj:Render;
		
		public var bmdList:Array;
		
		public var curIndex:int;
		
		public var pos:Point;
		
		public var oldPos:Point;
		
		public var renderRect:Rectangle;
		
		public var fps:int;
		
		public var bmp:Bitmap;
		
		private var m_cur:int;
		
		public function GameObject()
		{
			fps = 2;
			
			pos = new Point();
			
			oldPos = new Point();
			
			renderRect = new Rectangle();
		}
		
		public function get zIndex():int
		{
			return pos.y;
		}
		
		public function clear(bitmapData:BitmapData, buffer:BitmapData):void
		{
			renderObj.clearMe(bitmapData, buffer, this);
		}
		
		public function render(bitmapData:BitmapData, buffer:BitmapData):void
		{
			if(bmdList.length > 0)
			{
				renderObj.renderMe(bitmapData, buffer, this);
				
				m_cur++;
				
				if(m_cur >= fps)
				{
					m_cur = 0;
					
					curIndex++;
					
					if(curIndex >= bmdList.length) curIndex = 0;
				}
			}
		}
	}
}