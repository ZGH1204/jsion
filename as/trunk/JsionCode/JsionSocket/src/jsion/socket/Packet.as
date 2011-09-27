package jsion.socket
{
	import flash.utils.ByteArray;
	
	public class Packet extends ByteArray
	{
		public function get headerSize():int
		{
			return 4;
		}
		
		public function get pkgLenOffset():int
		{
			return 0;
		}
		
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
		
		public function readHeader():void
		{
			
		}
		
		public function writeHeader():void
		{
			
		}
		
		public function writeData():void
		{
			
		}
		
		public function pack():void
		{
			
		}
		
		public function reset():void
		{
			this.position = headerSize;
		}
		
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
		
		public function writeDate(date:Date):void
		{
			writeShort(date.fullYear);
			writeByte(date.month + 1);
			writeByte(date.date);
			writeByte(date.hours);
			writeByte(date.minutes);
			writeByte(date.seconds);
		}
	}
}