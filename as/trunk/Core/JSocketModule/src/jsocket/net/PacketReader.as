package jsocket.net
{
	import flash.net.Socket;
	import flash.utils.ByteArray;

	public class PacketReader
	{
		private var offset:int;
		
		private var writeOffset:int;
		
		private var buffer:ByteArray;
		private var headerTmp:ByteArray;
		
		public function PacketReader()
		{
			buffer = new ByteArray();
			headerTmp = new ByteArray();
		}
		
		public function readBytes(socket:Socket):void
		{
			if(socket.bytesAvailable > 0)
			{
				var len:int = socket.bytesAvailable;
				
				socket.readBytes(buffer, writeOffset, len);
				
				writeOffset += len;
			}
		}
		
		public function readPacket():Array
		{
			offset = 0;
			buffer.position = 0;
			
			var list:Array = [];
			
			var dataLen:int = writeOffset - offset;
			
			while(true)
			{
				var pkg:Packet = PacketFactory.createPacket();
				
				if(dataLen < pkg.headerSize) break;
				
				pkg.position = 0;
				pkg.writeByte(buffer[offset + pkg.pkgLenOffset]);
				pkg.writeByte(buffer[offset + pkg.pkgLenOffset + 1]);
				pkg.position = 0;
				
				PacketFactory.receiveCryptor.decrypt(pkg);
				
				var len:int = pkg.readUnsignedShort();
				
				if(dataLen >= len)
				{
					buffer.position = offset;
					pkg.load(buffer, len);
					PacketFactory.receiveCryptor.decrypt(pkg);
					PacketFactory.receiveCryptor.update();
					pkg.readHeader();
					offset += len;
					dataLen = writeOffset - offset;
					list.push(pkg);
				}
				else
				{
					break;
				}
			}
			
			buffer.position = 0;
			
			if(dataLen > 0)
			{
				buffer.writeBytes(buffer, offset, dataLen);
			}
			
			offset = 0;
			writeOffset = dataLen;
			
			return list;
		}
	}
}