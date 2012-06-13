package jsion.utils
{
	import flash.utils.*;
	
	/**
	 * 字节流工具
	 * @author Jsion
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion JUtils 1
	 * 
	 */	
	public final class ByteArrayUtil
	{
		/**
		 * 创建指定长度的字节流
		 * @param length 要创建的长度
		 * @return 指定长度的字节流
		 * 
		 */		
		public static function create(length:int):ByteArray
		{
			var bytes:ByteArray = new ByteArray();
			bytes.length = length;
			bytes.position = 0;
			return bytes;
		}
		
		/**
		 * Converts a byte array into a hex dump
		 * @param description Dump description
		 * @param dump byte array
		 * @param start dump start offset
		 * @param count dump bytes count
		 * @return the converted hex dump
		 * 
		 */		
		public static function toHexDump(description:String,dump:ByteArray, start:int, count:int):String
		{
			var hexDump:String = "";
			if (description != null)
			{
				hexDump += description;
				hexDump += "\n";
			}
			var end:int = start + count;
			for (var i:int = start; i < end; i += 16)
			{
				var text:String = "";
				var hex:String = "";
				
				for (var j:int = 0; j < 16; j++)
				{
					if (j + i < end)
					{
						var val:Number = dump[j + i];
						if(val < 16)
						{
							hex += "0" + val.toString(16)+" ";
						}
						else
						{
							hex += val.toString(16) + " ";
						}
						
						if (val >= 32 && val <= 127)
						{
							text += String.fromCharCode(val);
						}
						else
						{
							text += ".";
						}
					}
					else
					{
						hex += "   ";
						text += " ";
					}
				}
				hex +="  ";
				hex += text;
				hex += '\n';
				hexDump += hex;
			}
			return hexDump;
		}
	}
}