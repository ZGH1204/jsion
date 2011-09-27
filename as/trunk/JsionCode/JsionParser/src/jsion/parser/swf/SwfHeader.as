package jsion.parser.swf
{
	import flash.geom.Rectangle;

	public class SwfHeader
	{
		public var header:String;
		
		public var version:uint;
		
		public var fileLength:uint;
		
		public var frameSize:RectRecord;
		
		public var frameRate:uint;
		
		public var frameCount:uint;
	}
}