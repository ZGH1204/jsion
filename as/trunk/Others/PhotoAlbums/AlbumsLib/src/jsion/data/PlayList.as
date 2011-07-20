package jsion.data
{
	import com.utils.StringHelper;

	public class PlayList extends PlayItem
	{
		public var playMode:int;
		public var autoPlay:Boolean;
		
		public var items:Vector.<PlayItem> = new Vector.<PlayItem>();
		
		override public function slovePath(path:String):String
		{
			if(StringHelper.isNullOrEmpty(path)) return "";
			return (musicRoot + path);
		}
	}
}