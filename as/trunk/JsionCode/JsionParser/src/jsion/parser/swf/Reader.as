package jsion.parser.swf
{
	import flash.utils.ByteArray;

	public class Reader
	{
		protected var _data:ByteArray;
		protected var _offset:uint;
		protected var _length:uint = 0;
		public function Reader()
		{
			
		}
		
		public function get data():ByteArray
		{
			return _data;
		}
		
		public function set data(value:ByteArray):void
		{
			_data = value;
			_offset = _data.position;
			if(_data.bytesAvailable > 0) read();
			_length = _data.position - _offset;
		}
		
		public function get offset():uint
		{
			return _offset;
		}
		
		public function get length():uint
		{
			return _length;
		}
		
		protected function read():void
		{
			
		}
		
		public function readString():String
		{
			var text:String = "";
			
			try
			{
				var v:int = data.readUnsignedByte();
				while (v)
				{
					text += String.fromCharCode(v);
					v = data.readUnsignedByte();
				}
			}
			catch (e:Error)
			{};
			
			return text;
		}
		
		public function readUnsigned30():uint
		{
			return readVariableLengthUnsigned32()&0x3fffffff;
		}
		
		public function readSigned32():int
		{
			return readVariableLength32();
		}
		
		public function readUnsigned32():uint
		{
			return readVariableLengthUnsigned32();
		}
		
		public function readUnsignedByte():uint
		{
			return data.readUnsignedByte();
		}
		
		public function readUnsignedShort():uint
		{
			return data.readUnsignedShort()
		}
		
		public function readUnsignedInt():uint
		{
			return data.readUnsignedInt();
		}
		
		public function readDouble():Number
		{
			return data.readDouble();
		}
		
		public function readUTFBytes(length:uint):String
		{
			return data.readUTFBytes(length);
		}
		
		private function readVariableLengthUnsigned32():uint
		{
			var b:int = data.readUnsignedByte();
			
			var u32:uint = b;
			
			var bytes_count:uint = 1;
			
			var bit_mask:uint ;
			
			var mask:uint = 1<<7;
			
			while(true)
			{
				bit_mask = 1<<(bytes_count*7);
				if( !(b & mask) )
				{
					break;
				}
				b = data.readUnsignedByte();
				u32 = u32 & (bit_mask-1) | (b<<(bytes_count*7));
				bytes_count++;
				if(bytes_count>5)
				{
					break;
				}
			}
			return u32;
		}
		
		private function readVariableLength32():int
		{
			var result:int = readVariableLengthUnsigned32();
			
			if( 0 != ( result & 0x80000000 ) )
			{
				result &= 0x7fffffff;
				result -= 0x80000000;
			}
			return result;
		}
	}
}