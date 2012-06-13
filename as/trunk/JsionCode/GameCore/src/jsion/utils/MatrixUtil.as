package jsion.utils
{
	import flash.geom.*;
	
	import jsion.Constant;
	
	/**
	 * 矩阵工具
	 * @author Jsion
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion JUtils 1
	 * 
	 */	
	public final class MatrixUtil
	{
		/**
		 * 更改 Matrix 矩阵对象,按指定旋转中心点旋转指定角度值.
		 * @param matrix 要更改的矩阵
		 * @param point 旋转中心点
		 * @param angle 旋转角度值
		 * @param scale 缩放值
		 * 
		 */		
		public static function rotateWithPoint(matrix:Matrix, point:Point, angle:Number, scale:Number = 1):void
		{
			if(matrix == null) return;
			resetMatrix(matrix);
			var distance:Number = Point.distance(point, Constant.ZeroPoint);
			var radians:Number = GeomUtil.toRadians(angle);
			var centerRadians:Number = Math.acos(point.x / distance) + Math.PI;
			//var cosRadians:Number = Math.cos(radians);
			//var sinRadians:Number = Math.sin(radians);
			var translateX:Number = Math.cos(radians + centerRadians) * distance + point.x;
			var translateY:Number = Math.sin(radians + centerRadians) * distance + point.y;
			matrix.rotate(radians);
			matrix.translate(translateX, translateY);
			matrix.scale(scale, scale);
		}
		
		/**
		 * 重置矩阵
		 * @param matrix
		 * 
		 */		
		public static function resetMatrix(matrix:Matrix):void
		{
			matrix.a = 1;
			matrix.b = 0;
			matrix.c = 0;
			matrix.d = 1;
			matrix.tx = 0;
			matrix.ty = 0;
		}
	}
}