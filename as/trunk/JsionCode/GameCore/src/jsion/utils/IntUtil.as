package jsion.utils
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
		
		
		
		/**
		 * 将整数转换为16进制字符串(大写)
		 * @param num
		 * @return 
		 * @tiptext 将整数转换为16进制字符串(大写)
		 */		
		public static function toHexString(num:int):String
		{
			return num.toString(16).toUpperCase();
		}
		
		/**
		 * 将整数转换为8进制字符串
		 * @param num
		 * @return 
		 * 
		 */		
		public static function toOctString(num:int):String
		{
			return num.toString(8);
		}
		
		/**
		 * 将数字转换为2进制字符串
		 * @param num
		 * @return 
		 * 
		 */		
		public static function toBinString(num:Number):String
		{
			return num.toString(2);
		}
	}
}