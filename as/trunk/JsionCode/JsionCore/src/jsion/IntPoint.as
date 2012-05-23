package jsion
{
	import flash.geom.Point;

	/**
	 * IntPoint 对象表示二维坐标系统中的某个位置，其中 x 表示水平轴，y 表示垂直轴。 
	 * @author Jsion
	 * 
	 */	
	public class IntPoint
	{
		/**
		 * 横坐标
		 */		
		public var x:int;
		/**
		 * 纵坐标
		 */		
		public var y:int;
		
		public function IntPoint(x:int = 0, y:int = 0)
		{
			this.x = x;
			this.y = y;
		}
		
		/**
		 * 转换为 Point 对象
		 */		
		public function toPoint():Point
		{
			return new Point(x, y);
		}
		
		/**
		 * 使用指定的 Point 对象设置x、y坐标
		 * @param p 指定的 Point 对象
		 * 
		 */		
		public function setWithPoint(p:Point):void
		{
			x = p.x;
			y = p.y;
		}
		
		/**
		 * 使用指定的 Point 对象创建 IntPoint 对象
		 * @param p 指定的 Point 对象
		 */		
		public static function creatWithPoint(p:Point):IntPoint
		{
			return new IntPoint(p.x, p.y);
		}
		
		/**
		 * 设置坐标位置
		 */		
		public function setLocation(p:IntPoint):void
		{
			this.x = p.x;
			this.y = p.y;
		}
		
		/**
		 * 设置坐标位置
		 */		
		public function setLocationXY(x:int=0, y:int=0):void
		{
			this.x = x;
			this.y = y;
		}
		
		/**
		 * 将x、y坐标分别移动指定的距离
		 * @param dx x坐标要移动的距离
		 * @param dy y坐标要移动的距离
		 */		
		public function move(dx:int, dy:int):IntPoint
		{
			x += dx;
			y += dy;
			return this;
		}
		
		/**
		 * 通过指定的弧度方向和距离移动x、y坐标
		 * @param radians 指定的弧度方向
		 * @param distance 要移动的距离
		 */		
		public function moveRadians(radians:int, distance:int):IntPoint
		{
			x += Math.round(Math.cos(radians)*distance);
			y += Math.round(Math.sin(radians)*distance);
			return this;
		}
		
		/**
		 * 通过指定的弧度方向和距离移动x、y坐标 并生成新的 IntPoint 对象 不影响对象本身
		 * @param direction 指定的弧度方向
		 * @param distance 要移动的距离
		 */		
		public function nextPoint(direction:Number, distance:Number):IntPoint
		{
			return new IntPoint(x+Math.cos(direction)*distance, y+Math.sin(direction)*distance);
		}
		
		/**
		 * 计算与指定点之间的距离的平方
		 * @param p 要计算的点
		 */		
		public function distanceSq(p:IntPoint):int
		{
			var xx:int = p.x;
			var yy:int = p.y;
			
			return ((x-xx)*(x-xx)+(y-yy)*(y-yy));	
		}
		
		/**
		 * 计算与指定点之间的距离
		 * @param p 要计算的点
		 */		
		public function distance(p:IntPoint):int
		{
			return Math.sqrt(distanceSq(p));
		}
		
		/**
		 * 与指定对象比较是否相等
		 * @param o 要比较的对象
		 * @return true表示相等 false表示不相等
		 * 
		 */		
		public function equals(o:Object):Boolean
		{
			var toCompare:IntPoint = o as IntPoint;
			if(toCompare == null) return false;
			return x === toCompare.x && y === toCompare.y;
		}
		
		/**
		 * 克隆对象
		 */		
		public function clone():IntPoint
		{
			return new IntPoint(x,y);
		}
		
		/**
		 * 对象的字符串形式
		 */		
		public function toString():String
		{
			return "IntPoint["+x+","+y+"]";
		}
	}
}