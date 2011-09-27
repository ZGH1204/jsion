package jsion.parser.swf.abc
{
	import flash.utils.ByteArray;
	
	import jsion.parser.swf.Reader;
	
	public class Script_info extends Reader
	{
		public function Script_info(data:ByteArray)
		{
			this.data = data;
		}
	}
}