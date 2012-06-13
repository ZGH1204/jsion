package jsion.utils
{
	import flash.geom.*;
	
	/**
	 * 几何工具
	 * @author Jsion
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion JUtils 1
	 * 
	 */	
	public final class GeomUtil
	{
		/**
		 * 角度转换为弧度
		 * @param angle 角度值
		 * @return 转换后的弧度值
		 * 
		 */		
		public static function toRadians(angle:Number):Number
		{
			var radians:Number = angle * Math.PI / 180;
			return radians;
		}
		
		/**
		 * 弧度转换为角度
		 * @param radians 弧度值
		 * @return 角度值
		 * 
		 */		
		public static function toAngle(radians:Number):Number
		{
			var angle:Number = radians * 180 / Math.PI;
			return angle;
		}
		
		/**
		 * 获取两点之间的弧度
		 * @param p1 第一个点
		 * @param p2 第二个点
		 * @return 弧度值
		 * 
		 */		
		public static function getRadians(p1:Point, p2:Point):Number
		{
			var ty:Number = p2.y - p1.y;
			var tx:Number = p2.x - p1.x;
			
			return Math.atan(ty / tx);
		}
		
		/**
		 * 获取两点之间的角度
		 * @param p1 第一个点
		 * @param p2 第二个点
		 * @return 角度值
		 * 
		 */		
		public static function getAngle(p1:Point, p2:Point):Number
		{
			return toAngle(getRadians(p1, p2));
		}
	}
}