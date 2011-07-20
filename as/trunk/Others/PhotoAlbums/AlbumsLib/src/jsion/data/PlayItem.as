package jsion.data
{
	import com.utils.StringHelper;

	public class PlayItem
	{
		public var musicRoot:String = "";
		public var url:String = "";
		public var songName:String = "";
		public var artist:String = "";
		
		public function slovePath(path:String):String
		{
			if(StringHelper.isNullOrEmpty(path)) return "";
			return (musicRoot + path);
		}
	}
}