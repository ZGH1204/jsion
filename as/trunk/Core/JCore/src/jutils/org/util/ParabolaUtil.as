package jutils.org.util
{
	import flash.geom.*;
	
	/**
	 * 抛物线工具
	 * @author Jsion
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion JUtils 1
	 * 
	 */	
	public final class ParabolaUtil
	{
		/**
		 * 三点确定抛物线<br />
		 * 由（x1,y1），（x2,y2），（x3,y3）计算y=ax^2+bx+c：<br />
		 * ①（y2-y1）/（x2-x1）→A<br />
		 * ②（y3-y2）/（x3-x2）→B<br />
		 * ③x1-x3→C<br />
		 * ④x1+x2→D<br />
		 * ⑤a=（A-B）/C<br />
		 * ⑥b=A-D•a<br />
		 * ⑦c=y1-ax1^2+bx1（x1,y1可换成x2,y2或x3,y3）<br />
		 * ⑧得出结果：y=ax^2+bx+c
		 * 
		 * @param p1
		 * @param p2
		 * @param p3
		 * @return ParabolaInfo对象内的a,b,c对应抛物线的三个常数
		 * 
		 */		
		public static function getParabolaInfo(p1:Point, p2:Point, p3:Point):ParabolaInfo
		{
			var info:ParabolaInfo = new ParabolaInfo();
			
			var v1:Number = (p2.y - p1.y) / (p2.x - p1.x);
			var v2:Number = (p3.y - p2.y) / (p3.x - p2.x);
			var v3:Number = p1.x - p3.x;
			var v4:Number = p1.x + p2.x;
			
			info.a = (v1 - v2) / v3;
			info.b = v1 - v4 * info.a;
			info.c = p1.y - info.a * p1.x * p1.x + info.b * p1.x;
			
			return info;
		}
	}
}