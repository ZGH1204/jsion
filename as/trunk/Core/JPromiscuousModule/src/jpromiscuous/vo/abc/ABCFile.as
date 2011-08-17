package jpromiscuous.vo.abc
{
	public class ABCFile
	{
		public var flags:uint;
		
		public var name:String;
		
		public var minorVer:uint;
		
		public var majorVer:uint;
		
		public var constantPool:CPoolInfo = new CPoolInfo();
		
		public var methodCount:uint;
		
		public var methodInfos:Array;
		
		public var metaDataCount:uint;
		
		public var metaDataInfos:Array;
		
		public var classCount:uint;
		
		public var instanceInfos:Array;
		public var classInfos:Array;
		
		public var scriptCount:uint;
		
		public var scriptInfos:Array;
		
		public var methodBodyCount:uint;
		
		public var methodBodyInfos:Array;
		
		public function ABCFile()
		{
		}
	}
}