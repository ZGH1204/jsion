package jsion
{
	import flash.geom.Rectangle;

	/**
	 * 一个指示坐标和宽高大小的范围并提供相关计算方法的类
	 * @author Jsion
	 * 
	 */	
	public class IntRectangle
	{
		/**
		 * 横坐标
		 */		
		public var x:int = 0;
		/**
		 * 纵坐标
		 */		
		public var y:int = 0;
		/**
		 * 宽度
		 */		
		public var width:int = 0;
		/**
		 * 高度
		 */		
		public var height:int = 0;
		
		public function IntRectangle(x:int = 0, y:int = 0, width:int = 0, height:int = 0)
		{
			setRectXYWH(x, y, width, height);
		}
		
		/**
		 * 设置为指定范围
		 * @param x x坐标位置
		 * @param y y坐标位置
		 * @param width 宽度
		 * @param height 高度
		 * 
		 */		
		public function setRectXYWH(x:int, y:int, width:int, height:int):void
		{
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
		}
		
		/**
		 * 转换为 Rectangle 对象
		 */		
		public function toRectangle():Rectangle
		{
			return new Rectangle(x, y, width, height);
		}
		
		/**
		 * 设置为指定范围
		 * @param r 要设置的范围
		 */		
		public function setWithRectangle(r:Rectangle):void
		{
			x = r.x;
			y = r.y;
			width = r.width;
			height = r.height;
		}
		
		/**
		 * 通过一个指定的 Rectangle 对象创建 IntRectangle 对象
		 * @param r 指定的Rectangle 对象
		 * @return 
		 * 
		 */		
		public static function creatWithRectangle(r:Rectangle):IntRectangle
		{
			return new IntRectangle(r.x, r.y, r.width, r.height);
		}
		
		/**
		 * 设置为指定范围
		 * @param rect 要设置的范围
		 * 
		 */		
		public function setRect(rect:IntRectangle):void
		{
			setRectXYWH(rect.x, rect.y, rect.width, rect.height);
		}
		
		/**
		 * 设置为指定坐标
		 * @param p 要设置的坐标
		 * 
		 */		
		public function setLocation(p:IntPoint):void
		{
			this.x = p.x;
			this.y = p.y;
		}
		
		/**
		 * 设置为指定大小 
		 * @param size 指定的大小
		 * 
		 */		
		public function setSize(size:IntDimension):void
		{
			this.width = size.width;
			this.height = size.height;
		}
		
		/**
		 * 获取宽度和高度的 IntDimension 对象
		 */		
		public function getSize():IntDimension
		{
			return new IntDimension(width, height);
		}
		
		/**
		 * 获取坐标位置的 IntPoint 对象
		 */		
		public function getLocation():IntPoint
		{
			return new IntPoint(x, y);
		}
		
		/**
		 * 计算与指定的范围合并后的范围 并返回新的 IntRectangle 对象
		 * @param r 指定的范围
		 */		
		public function union(r:IntRectangle):IntRectangle
		{
			var x1:int = Math.min(x, r.x);
			var x2:int = Math.max(x + width, r.x + r.width);
			var y1:int = Math.min(y, r.y);
			var y2:int = Math.max(y + height, r.y + r.height);
			return new IntRectangle(x1, y1, x2 - x1, y2 - y1);
		}
		
		/**
		 * 以范围中点上下、左右两组边分别往外增加指定的距离
		 * @param h 要增加的左、右距离
		 * @param v 要增加的上、下距离
		 * 
		 */		
		public function grow(h:int, v:int):void
		{
			x -= h;
			y -= v;
			width += h * 2;
			height += v * 2;
		}
		
		/**
		 * 将x、y坐标分别移动指定的距离
		 * @param dx x坐标要移动的距离
		 * @param dy y坐标要移动的距离
		 * 
		 */		
		public function move(dx:int, dy:int):void
		{
			x += dx;
			y += dy;
		}
		
		/**
		 * 增加宽度和高度
		 * @param dwidth 要增加的宽度
		 * @param dheight 要增加的高度
		 */		
		public function increaseSize(dwidth:int=0, dheight:int=0):void
		{
			width += dwidth;
			height += dheight;
		}
		
		/**
		 * 左上角坐标
		 */		
		public function leftTop():IntPoint
		{
			return new IntPoint(x, y);
		}
		
		/**
		 * 右上角坐标
		 */		
		public function rightTop():IntPoint
		{
			return new IntPoint(x + width, y);
		}
		
		/**
		 * 左下角坐标
		 */		
		public function leftBottom():IntPoint
		{
			return new IntPoint(x, y + height);
		}
		
		/**
		 * 右下角坐标
		 */		
		public function rightBottom():IntPoint
		{
			return new IntPoint(x + width, y + height);
		}
		
		/**
		 * 判断是否包含指定的坐标点
		 * @param p 要判断的坐标点
		 * @return 
		 * 
		 */		
		public function containsPoint(p:IntPoint):Boolean
		{
			if(p.x < x || p.y < y || p.x > x+width || p.y > y+height)
			{
				return false;
			}
			else
			{
				return true;
			}
		}
		
		/**
		 * 与指定对象比较是否相等
		 * @param o 要比较的对象
		 * @return true表示相等 false表示不相等
		 * 
		 */		
		public function equals(o:Object):Boolean
		{
			var r:IntRectangle = o as IntRectangle;
			if(r == null) return false;
			return x === r.x && y === r.y && width === r.width && height === r.height;
		}
		
		/**
		 * 克隆对象
		 */		
		public function clone():IntRectangle
		{
			return new IntRectangle(x, y, width, height);
		}
		
		/**
		 * 对象的字符串形式
		 */		
		public function toString():String
		{
			return "IntRectangle[x:"+x+",y:"+y+", width:"+width+",height:"+height+"]";
		}
	}
}