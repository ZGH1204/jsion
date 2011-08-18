package jpromiscuous.vo.abc
{
	import flash.utils.ByteArray;
	
	import jpromiscuous.vo.Reader;
	
	public class String_info extends Reader
	{
		/*
		string_info
		{
		u30 size
		u8 utf8[size]
		} 
		*/
		
		public var size:uint;
		public var utf8String:String;
		
		public function String_info(data:ByteArray)
		{
			this.data = data;
		}
		
		override protected function read():void
		{
			size = readUnsigned30();
			utf8String = readUTFBytes(size);
		}
	}
}