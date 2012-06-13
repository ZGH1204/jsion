package jsion.core.socket
{
	import flash.utils.ByteArray;
	
	/**
	 * 数据包
	 * @author Jsion
	 */	
	public class Packet extends ByteArray
	{
		/**
		 * 包头大小
		 */		
		public function get headerSize():int
		{
			return 4;
		}
		
		/**
		 * 包长数据在当前流中相对起始位置的偏移量
		 */		
		public function get pkgLenOffset():int
		{
			return 0;
		}
		
		/**
		 * 从当前流中加载指定长度的数据到 bytes 中。
		 * @param bytes
		 * @param len
		 * 
		 */		
		public function load(bytes:ByteArray, len:int):void
		{
			if(bytes.bytesAvailable >= len)
			{
				bytes.readBytes(this, 0, len);
			}
			else
			{
				throw new Error("字节数组超出可读的字节长度。");
			}
		}
		
		/**
		 * 读取包头数据
		 */		
		public function readHeader():void
		{
			
		}
		
		/**
		 * 写入包头数据
		 */		
		public function writeHeader():void
		{
			
		}
		
		/**
		 * 写入包体数据
		 */		
		public function writeData():void
		{
			
		}
		
		/**
		 * 打包数据
		 */		
		public function pack():void
		{
			
		}
		
		/**
		 * 重置数据指针位置
		 */		
		public function reset():void
		{
			this.position = headerSize;
		}
		
		/**
		 * 读取日期数据类型
		 */		
		public function readDate():Date
		{
			var year:uint = readUnsignedShort();
			var month:uint = readUnsignedByte() - 1;
			var date:uint = readUnsignedByte();
			var hours:uint = readUnsignedByte();
			var minutes:uint = readUnsignedByte();
			var seconds:uint = readUnsignedByte();
			
			return new Date(year, month, date, hours, minutes, seconds);
		}
		
		/**
		 * 读取仅含日期部分的日期数据型
		 */		
		public function readShortDate():Date
		{
			var year:uint = readUnsignedShort();
			var month:uint = readUnsignedByte() - 1;
			var date:uint = readUnsignedByte();
			
			return new Date(year, month, date);
		}
		
		/**
		 * 写入日期数据类型
		 * @param date 日期对象
		 */		
		public function writeDate(date:Date):void
		{
			writeShort(date.fullYear);
			writeByte(date.month + 1);
			writeByte(date.date);
			writeByte(date.hours);
			writeByte(date.minutes);
			writeByte(date.seconds);
		}
		
		/**
		 * 仅写入日期部分的日期数据型
		 * @param date 日期对象
		 */
		public function writeShortDate(date:Date):void
		{
			writeShort(date.fullYear);
			writeByte(date.month + 1);
			writeByte(date.date);
		}
	}
}