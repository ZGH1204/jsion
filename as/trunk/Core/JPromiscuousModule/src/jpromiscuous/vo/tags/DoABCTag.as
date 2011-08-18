package jpromiscuous.vo.tags
{
	import flash.utils.flash_proxy;
	
	import jpromiscuous.vo.SwfReader;
	import jpromiscuous.vo.Tag;
	import jpromiscuous.vo.abc.ABCFile;
	
	import jutils.org.util.ByteArrayUtil;
	
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