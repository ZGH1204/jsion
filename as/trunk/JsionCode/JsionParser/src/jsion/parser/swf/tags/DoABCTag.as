package jsion.parser.swf.tags
{
	import jsion.parser.swf.Tag;
	import jsion.parser.swf.abc.ABCFile;
	
	public class DoABCTag extends Tag
	{
		public var flags:uint;
		
		public var name:String;
		
		public var abcfile:ABCFile;
		
		public function DoABCTag()
		{
			super();
		}
		
		override public function parse():void
		{
			flags = readUnsignedInt();
			name = readString();
			
			abcfile = new ABCFile(data);
		}
	}
}