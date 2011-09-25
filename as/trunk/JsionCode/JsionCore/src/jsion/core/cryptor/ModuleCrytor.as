package jsion.core.cryptor
{
	import flash.utils.ByteArray;

	/**
	 * 模块加密实现
	 * @author Jsion
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion JUtils 1
	 * 
	 */	
	public class ModuleCrytor implements ICryption
	{
		public function encry(bytes:ByteArray):ByteArray
		{
			var rlt:ByteArray = new ByteArray();
			
			var key:ByteArray = new ByteArray();
			var len:int = 21;
			while(len--)
			{
				key.writeByte((65536 * Math.random()) & 0xFF);
			}
  			
  			var a:ByteArray = new ByteArray();
  			//去掉CWS
  			bytes.position = 3;
  			bytes.readBytes(a,0,121);
  			
  			var b:ByteArray = new ByteArray();
  			bytes.readBytes(b,0,bytes.length - 124);
  			
  			rlt.writeBytes(key);
  			rlt.writeBytes(b);
  			rlt.writeBytes(a);
  			
  			return rlt;
		}
		
		public function decry(bytes:ByteArray):ByteArray
		{
			var decry:ByteArray = new ByteArray();
			decry.writeByte(67);
			decry.writeByte(87);
			decry.writeByte(83);
			bytes.position = 21;
			bytes.readBytes(decry,124,bytes.bytesAvailable -121);
			bytes.readBytes(decry,3);
			return decry;
		}
		
	}
}