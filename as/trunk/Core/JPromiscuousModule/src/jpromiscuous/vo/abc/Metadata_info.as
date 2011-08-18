package jpromiscuous.vo.abc
{
	import flash.utils.ByteArray;
	
	import jpromiscuous.vo.Reader;
	
	public class Metadata_info extends Reader
	{
		public function Metadata_info(data:ByteArray)
		{
			this.data = data;
		}
	}
}