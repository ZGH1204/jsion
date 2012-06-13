package jsion.parser.swf.abc
{
	import flash.utils.ByteArray;
	
	import jsion.parser.swf.Reader;
	
	public class Cpool_info extends Reader
	{
		/* 
		cpool_info
		{
		u30 int_count
		s32 integer[int_count]
		
		u30 uint_count
		u32 uinteger[uint_count]
		
		u30 double_count
		d64 double[double_count]
		
		u30 string_count
		string_info string[string_count]
		
		u30 namespace_count
		namespace_info namespace[namespace_count]
		
		u30 ns_set_count
		ns_set_info ns_set[ns_set_count]
		
		u30 multiname_count
		multiname_info multiname[multiname_count]
		}	 
		*/
		
		public var int_count:uint;
		public var integer:Array = [0];
		
		public var uint_count:uint;
		public var uinteger:Array = [];
		
		public var double_count:uint;
		public var double:Array = [0];
		
		public var string_count:uint;
		public var string:Array = [0];
		
		public var namespace_count:uint;
		public var namespaces:Array = [0];
		
		public var ns_set_count:uint;
		public var ns_set:Array = [0];
		
		public var multiname_count:uint;
		public var multiname:Array = [0];
		
		public function Cpool_info(data:ByteArray)
		{
			this.data = data;
		}
		
		override protected function read():void
		{
			var i:int;
			
			int_count = readUnsigned30();
			for(i = 1; i < int_count; i++)
			{
				integer.push(readSigned32());
			}
			
			uint_count = readUnsigned30();
			for(i = 0; i < uint_count; i++)
			{
				uinteger.push(readUnsigned32());
			}
			
			double_count = readUnsigned30();
			for(i = 1; i < double_count; i++)
			{
				double.push(readDouble());
			}
			
			string_count = readUnsigned30();
			for(i = 1; i < string_count; i++)
			{
				string.push(new String_info(data));
			}
			
			namespace_count = readUnsigned30();
			for(i = 1; i < namespace_count; i++)
			{
				namespaces.push(new Namespace_info(data));
			}
			
			ns_set_count = readUnsigned30();
			for(i = 1; i < ns_set_count; i++)
			{
				ns_set.push(new Ns_set_info(data));
			}
			
			multiname_count = readUnsigned30();
			for(i = 1; i < multiname_count; i++)
			{
				multiname.push(new Multiname_info(data));
			}
		}
	}
}