package
{
	import jsion.utils.XmlUtil;

	public class Config
	{
		public static var LibRoot:String;
		
		public static var ServerIP:String;
		
		public static var ServerPort:int;
		
		public static var GameWidth:int;
		
		public static var GameHeight:int;
		
		public static var ResRoot:String;
		
		public static function setup(config:XML):void
		{
			var cfg:XML = config.Config[0];
			
			XmlUtil.decodeWithProperty(Config, cfg);
			
			LibRoot = String(config.@LibRoot);
		}
	}
}