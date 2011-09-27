package jsion.parser.swf
{
	import flash.utils.ByteArray;

	public class Tag extends Reader
	{
		public var tagType:uint;
		public var tagLength:uint;
		
		public function Tag()
		{
			_data = new ByteArray();
		}
		
		public function parse():void
		{
			
		}
	}
}