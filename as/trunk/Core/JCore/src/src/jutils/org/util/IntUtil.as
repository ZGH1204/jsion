package jutils.org.util
{
	/**
	 * 整型工具
	 * @author Jsion
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion JUtils 1
	 * 
	 */	
	public final class IntUtil
	{
		/**
		 * 获取指定位数的整数字符串
		 * @param value 整数值
		 * @param len 位数
		 * @return 
		 * 
		 */		
		public static function getIntStrByLength(value:uint, len:uint):String
		{
			var str:String = value.toString();
			if(len > 0)
			{
				if(str.length < len)
				{
					while(str.length < len)
					{
						str = "0" + str;
					}
				}
			}
			
			return str;
		}
	}
}