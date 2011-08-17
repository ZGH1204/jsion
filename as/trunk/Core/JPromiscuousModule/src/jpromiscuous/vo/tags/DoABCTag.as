package jpromiscuous.vo.tags
{
	import flash.utils.flash_proxy;
	
	import jpromiscuous.vo.SwfReader;
	import jpromiscuous.vo.Tag;
	import jpromiscuous.vo.abc.ABCFile;
	
	import jutils.org.util.ByteArrayUtil;
	
	public class DoABCTag extends Tag
	{
		public var abcFile:ABCFile;
		
		public function DoABCTag()
		{
			super();
		}
		
		override public function parse():void
		{
			abcFile = new ABCFile();
			//trace(ByteArrayUtil.toHexDump("DoABC:",data, 0, data.length));
			abcFile.flags = data.readUnsignedInt();
			abcFile.name = SwfReader.readString(data);
			abcFile.minorVer = data.readUnsignedShort();
			abcFile.majorVer = data.readUnsignedShort();
			
			//abcFile.constantPool.intCount = SwfReader.readABCU30(data);
		}
	}
}