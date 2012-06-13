package jsion.parser.swf.abc
{
	import flash.utils.ByteArray;
	
	import jsion.parser.swf.Reader;
	
	public class Multiname_info extends Reader
	{
		/*
		
		multiname_info
		{
			u8		kind
			u8		data[]
		}
		
		Multiname Kind					Value
		
		CONSTANT_QName					0x07
		CONSTANT_QNameA					0x0D
		CONSTANT_RTQName				0x0F
		CONSTANT_RTQNameA				0x10
		CONSTANT_RTQNameL				0x11
		CONSTANT_RTQNameLA				0x12
		CONSTANT_Multiname				0x09
		CONSTANT_MultinameA				0x0E
		CONSTANT_MultinameL				0x1B
		CONSTANT_MultinameLA			0x1C
		
		multiname_kind_QName
		multiname_kind_QNameA
		{
			u30		ns		//The index of namespaces-arrays, if zero for the ns field indicates any("*") namespace
			u30		name	//is an index into the string array of the constant_pool entry, if zero for the name field indicates any("*") name
		}
		
		multiname_kind_RTQName
		multiname_kind_RTQNameA
		{
			u30		name	//is an index into the string array of the constant_pool entry. A value of zero indicates the any("*") name. 
		}
		
		multiname_kind_RTQNameL
		multiname_kind_RTQNameLA
		{
			//This kind has no associated data.
		}
		
		multiname_kind_Multiname
		multiname_kind_MultinameA
		{
			u30		name	//is an index into the string array. A value of zero indicates the any("*") name.
			u30		ns_set	//is an index into the ns_set array. Can't be zero.
		}
		
		multiname_kind_MultinameL
		multiname_kind_MultinameLA
		{
			u30		ns_set	// is an index into the ns_set array of the constant pool.Can't be zero.
		}
		
		*/
		
		public var kind:uint;
		public var ns:uint;
		public var name:uint;
		public var ns_set:uint;
		
		public function Multiname_info(data:ByteArray)
		{
			this.data = data;
		}
		
		override protected function read():void
		{
			
		}
	}
}