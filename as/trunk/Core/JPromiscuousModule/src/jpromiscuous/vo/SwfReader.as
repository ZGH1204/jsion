package jpromiscuous.vo
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class SwfReader extends ByteArray
	{
		public function SwfReader(bytes:ByteArray)
		{
			super();
			bytes.readBytes(this);
			position = 0;
			endian = Endian.LITTLE_ENDIAN;
		}
		
		public function readHeader():SwfHeader
		{
			var header:SwfHeader = new SwfHeader();
			
			header.header = "";
			
			header.header += String.fromCharCode(readUnsignedByte());
			header.header += String.fromCharCode(readUnsignedByte());
			header.header += String.fromCharCode(readUnsignedByte());
			
			header.version = readUnsignedByte();
			
			header.fileLength = readUnsignedInt();
			
			if(header.header == "CWS")
			{
				var bytes:ByteArray = new ByteArray();
				readBytes(bytes, bytes.position);
				bytes.uncompress();
				position = 0;
				length = 0;
				bytes.readBytes(this);
			}
			
			header.frameSize = readRect(this);
			
			position++;
			header.frameRate = readUnsignedByte();
			
			header.frameCount = readUnsignedShort();
			
			return header;
		}
		
		/**
		 * 读取tag类型，不移动position 
		 * @param bytes
		 * @return 
		 */
		public function readTagType():uint
		{
			var result:uint = readUnsignedShort();
			
			result = result >> 6;
			
			position -= 2;
			
			return result;
		}
		
		/**
		 * 读取tag长度 不包括头本身占的长度
		 * @return 
		 * 
		 */     
		public function readTagLen():uint
		{
			var tagLength:uint = (readUnsignedShort() & 0x3F);
			
			if (tagLength == 0x3F)
			{
				tagLength = readUnsignedInt();
			}
			
			if(tagLength < 0)
			{
				throw (Error("SwfReader:无效的tag长度"));
			}
			
			return tagLength;
		}
		
		
		/**
		 * 读取tag列表 
		 * @param bytes
		 * 
		 */     
		public function readTags():Array
		{
			var result:Array = [];
			
			var tagType:uint;
			var tagLength:uint;
			var start:int;
			var tag:Tag;
			var cl:Class;
			
			while(bytesAvailable > 0)
			{
				start = position;
				tagType = readTagType();
				tagLength = readTagLen();
				
				cl = TagTypes.getTagClassByTagType(tagType);
				if (cl == null)
				{
					trace("Tag Not Found, Type=" + tagType, tagLength);
					position += tagLength;// 跳过长度
					continue;
				}
				tag = new cl();
				tag.tagType = tagType;
				if( tagLength > 0)
					readBytes(tag.data, 0, tagLength);
				
				tag.data.position = 0;
				tag.data.endian = Endian.LITTLE_ENDIAN;
				
				// 调用解析方法
				tag.parse();
				
				result.push(tag);
				
				if (tagType == TagTypes.TAG_END)
					break;
			}
			
			return result;
		}
		

		
		/**
		 * 读取一定长度的位 
		 * 无符号的
		 * 
		 * @param bytes 二进制序列
		 * @param bitStartPosition 开始读取的位置，从0开始算
		 * @param bitLength     读取长度
		 * @return 无符号数字
		 * 
		 */     
		public static function readUBits(bytes:ByteArray, bitStartPosition:int, bitLength:int):uint
		{
			var bitBuffer:int;
			var bitCursor:int;
			
			var remainLength:int;
			var result:uint=0;
			
			bitCursor= bitStartPosition % 8;
			bytes.position = bitStartPosition / 8;
			
			if (bitCursor == 0)
			{
				bitBuffer = bytes.readUnsignedByte();
				bitCursor = 8;
			}
			else
			{
				bitBuffer = bytes.readUnsignedByte();
				bitBuffer = bitBuffer & (0xFF >> bitCursor);
				bitCursor = 8 - bitCursor;
			}
			
			while(bytes.bytesAvailable > 0)
			{
				remainLength = bitLength - bitCursor;
				if (remainLength > 0)
				{
					result = result | (bitBuffer << remainLength);
					bitLength -= bitCursor;
					bitBuffer = bytes.readUnsignedByte();
					bitCursor = 8;
				}
				else
				{
					result = result | (bitBuffer >> -remainLength);
					return result;
				}
			}
			
			return 0;
		}
		
		/**
		 * 读取一定长度的位 
		 * 有符号的
		 * 
		 * @param bytes 二进制序列
		 * @param bitStartPosition 开始读取的位置，从0开始算
		 * @param bitLength 读取长度
		 * @return 有符号数字
		 * 
		 */     
		public static function readSBits(bytes:ByteArray, bitStartPosition:int, bitLength:int):int{
			
			var result:int = readUBits(bytes, bitStartPosition, bitLength);
			
			var offset:int = (32 - bitLength);
			// 补齐符号位
			result = ((result << offset) >> offset);
			
			return result;
		}
		
		
		/**
		 * 读取rect结构
		 * 
		 * @param bytes
		 * @param rect 如果传入，则使用该对象
		 * @return 
		 * 
		 */     
		public static function readRect(bytes:ByteArray, rect:RectRecord = null):RectRecord
		{
			if (rect == null) rect = new RectRecord();
			
			var start:int = bytes.position* 8;
			var length:uint = readUBits(bytes, start, 5);
			
			rect.xMinTwips = readSBits(bytes, start + 5, length);
			rect.xMaxTwips = readSBits(bytes, start + 5 + length, length);
			rect.yMinTwips = readSBits(bytes, start + 5 + length * 2, length);
			rect.yMaxTwips = readSBits(bytes, start + 5 + length*3, length);
			
			return rect;
		}
		
		/**
		 * 读取字符串，字符串编码格式为：字符串编码+\0;
		 * @param bytes
		 * @return 
		 * 
		 */		
		public static function readString(bytes:ByteArray):String
		{
			var list:Array = [];
			
			var byte:int = bytes.readUnsignedByte();
			
			while(byte > 0)
			{
				list.push(byte);
				byte = bytes.readUnsignedByte();
			}
			
			return String.fromCharCode.apply(null, list);
		}
	}
}