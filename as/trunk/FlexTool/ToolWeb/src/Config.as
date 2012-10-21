package 
{
	import jsion.utils.XmlUtil;

	public class Config
	{
		public static var ResRoot:String;
		
		public static var DebugCSS:String;
		
		public static var DefaultExt:String;
		
		public static function setup(config:XML):void
		{
			var cfg:XML = config.Config[0];
			
			XmlUtil.decodeWithProperty(Config, cfg);
			
			var index:int = DefaultExt.lastIndexOf(".");
			
			if(index != -1)
			{
				DefaultExt = DefaultExt.substr(index + 1);
			}
		}
	}
}