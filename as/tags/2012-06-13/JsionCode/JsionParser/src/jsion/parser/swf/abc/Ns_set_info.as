package jsion.parser.swf.abc
{
	import flash.utils.ByteArray;
	
	import jsion.parser.swf.Reader;
	
	public class Ns_set_info extends Reader
	{
		/*
		ns_set_info
		{
		u30 count
		u30 ns[count]
		}
		*/
		
		public var count:uint;
		
		public var ns:Array;
		
		public function Ns_set_info(data:ByteArray)
		{
			this.data = data;
		}
		
		override protected function read():void
		{
			count = readUnsigned30();
			ns = [];
			for(var i:int = 0; i < count; i++)
			{
				ns.push(readUnsigned30());
			}
		}
	}
}