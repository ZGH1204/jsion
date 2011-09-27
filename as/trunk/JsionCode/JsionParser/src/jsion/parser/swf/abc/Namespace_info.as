package jsion.parser.swf.abc
{
	import flash.utils.ByteArray;
	
	import jsion.parser.swf.Reader;
	
	public class Namespace_info extends Reader
	{
		/* 
		namespace_info
		{
		u8 kind
		u30 name
		}
		*/
		
		public var kind:uint;
		
		public var name:uint;
		
		public function Namespace_info(data:ByteArray)
		{
			this.data = data;
		}
		
		override protected function read():void
		{
			kind = readUnsignedByte();
			name = readUnsigned30();
		}
	}
}