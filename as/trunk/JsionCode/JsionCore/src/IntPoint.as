package
{
	import flash.geom.Point;

	public class IntPoint
	{
		public var x:int;
		public var y:int;
		
		public function IntPoint(x:int = 0, y:int = 0)
		{
			this.x = x;
			this.y = y;
		}
		
		public function toPoint():Point
		{
			return new Point(x, y);
		}
		
		public function setWithPoint(p:Point):void
		{
			x = p.x;
			y = p.y;
		}
		
		public static function creatWithPoint(p:Point):IntPoint
		{
			return new IntPoint(p.x, p.y);
		}
		
		public function setLocation(p:IntPoint):void
		{
			this.x = p.x;
			this.y = p.y;
		}
		
		public function setLocationXY(x:int=0, y:int=0):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function move(dx:int, dy:int):IntPoint
		{
			x += dx;
			y += dy;
			return this;
		}
		
		public function moveRadians(radians:int, distance:int):IntPoint
		{
			x += Math.round(Math.cos(radians)*distance);
			y += Math.round(Math.sin(radians)*distance);
			return this;
		}
		
		public function nextPoint(direction:Number, distance:Number):IntPoint
		{
			return new IntPoint(x+Math.cos(direction)*distance, y+Math.sin(direction)*distance);
		}
		
		public function distanceSq(p:IntPoint):int
		{
			var xx:int = p.x;
			var yy:int = p.y;
			
			return ((x-xx)*(x-xx)+(y-yy)*(y-yy));	
		}
		
		public function distance(p:IntPoint):int
		{
			return Math.sqrt(distanceSq(p));
		}
		
		public function equals(o:Object):Boolean
		{
			var toCompare:IntPoint = o as IntPoint;
			if(toCompare == null) return false;
			return x === toCompare.x && y === toCompare.y;
		}
		
		public function clone():IntPoint
		{
			return new IntPoint(x,y);
		}
		
		public function toString():String
		{
			return "IntPoint["+x+","+y+"]";
		}
	}
}