package jsion.core.quadtree
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import jsion.IDispose;
	import jsion.utils.*;

	public class QuadNode implements IDispose
	{
		public var rect:Rectangle;
		
		public var parentNode:QuadNode;
		
		public var hasChildren:Boolean;
		
		public var objects:Array = [];
		
		public var childNodes:Array;
		
		public function QuadNode()
		{
			childNodes = [null, null, null, null];
		}
		
		/**
		 * 确定由此 Rectangle 对象定义的矩形区域内是否包含指定的点。此方法与 Rectangle.contains() 方法类似，只不过它采用 Point 对象作为参数。
		 * @param point 用其 x 和 y 坐标表示的点。
		 * @return 如果 Rectangle 对象包含指定的点，则值为 true；否则为 false。
		 * 
		 */		
		public function containsPoint(point:Point):Boolean
		{
			return rect.containsPoint(point);
		}
		
		/**
		 * 确定由此 Rectangle 对象定义的矩形区域内是否包含指定的点。
		 * @param x 点的 x 坐标（水平位置）。
		 * @param y 点的 y 坐标（垂直位置）。
		 * @return 如果 Rectangle 对象包含指定的点，则值为 true；否则为 false。
		 */		
		public function contains(x:Number, y:Number):Boolean
		{
			return rect.contains(x, y);
		}
		
		public function dispose():void
		{
			while(objects && objects.length > 0)
			{
				objects.shift();
			}
			objects = null;
			
			DisposeUtil.free(childNodes);
			childNodes = null;
			
			parentNode = null;
			
			rect = null;
		}
	}
}