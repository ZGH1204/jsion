package jutils.org.util
{
	/**
	 * 随机工具
	 * @author Jsion
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion JUtils 1
	 * 
	 */	
	public final class RandomUtil
	{
		/**
		 * 返回指定数值范围内的随机数 n,其中 min <= n < max。
		 * @param min 最小数值
		 * @param max 最大数值
		 * @return 指定范围内的数值
		 * @langversion 3.0
		 * 
		 */		
		public static function randomRange(min:Number, max:Number):Number
		{
			return Math.random() * (max - min) + min;
		}
	}
}