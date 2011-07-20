package utils
{
	public class IntUtil
	{
		/**
		 * Rotates x left n bits
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 */
		public static function rol ( x:int, n:int ):int {
			return ( x << n ) | ( x >>> ( 32 - n ) );
		}
		
		/**
		 * Rotates x right n bits
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 */
		public static function ror ( x:int, n:int ):uint {
			var nn:int = 32 - n;
			return ( x << nn ) | ( x >>> ( 32 - nn ) );
		}
		
		/**
		 * Outputs the algorism value of a uint
		 * @return 
		 * @tiptext Random a number
		 */		
		public static function getRandom():uint
		{
			var n:uint = Math.round(Math.random()*1000000);
			return n;
		}
		
		/** String for quick lookup of a hex character based on index */
		private static var hexChars:String = "0123456789abcdef";
		
		/**
		 * Outputs the hex value of a int, allowing the developer to specify
		 * the endinaness in the process.  Hex output is lowercase.
		 *
		 * @param n The int value to output as hex
		 * @param bigEndian Flag to output the int as big or little endian
		 * @return A string of length 8 corresponding to the 
		 *		hex representation of n ( minus the leading "0x" )
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 */
		public static function toHex( n:int, bigEndian:Boolean = false ):String {
			var s:String = "";
			
			if ( bigEndian ) {
				for ( var i:int = 0; i < 4; i++ ) {
					s += hexChars.charAt( ( n >> ( ( 3 - i ) * 8 + 4 ) ) & 0xF ) 
						+ hexChars.charAt( ( n >> ( ( 3 - i ) * 8 ) ) & 0xF );
				}
			} else {
				for ( var x:int = 0; x < 4; x++ ) {
					s += hexChars.charAt( ( n >> ( x * 8 + 4 ) ) & 0xF )
						+ hexChars.charAt( ( n >> ( x * 8 ) ) & 0xF );
				}
			}
			
			return s;
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