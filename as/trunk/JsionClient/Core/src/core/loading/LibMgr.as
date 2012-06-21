package core.loading
{
	import jsion.HashMap;
	import jsion.utils.ObjectUtil;
	import jsion.utils.StringUtil;
	import jsion.utils.XmlUtil;

	public class LibMgr
	{
		public static const DEBUG:String = "debug";
		public static const GAME_CORE:String = "gameCore";
		public static const COMPONENT:String = "component";
		public static const CORE:String = "core";
		public static const DEBUG_LOGIN:String = "debugLogin";
		public static const LOGIN:String = "login";
		public static const TEMPLATE:String = "template";
		public static const LANGUAGE:String = "language";
		public static const EMBED_FONT:String = "embedFont";
		public static const SOUND:String = "sound";
		
		private static const libs:HashMap = new HashMap();
		
		public static function setup(config:XML):void
		{
			var libXL:XMLList = config..Loading;
			
			for each(var libXml:XML in libXL)
			{
				var data:LibData = new LibData();
				
				XmlUtil.decodeWithProperty(data, libXml);
				
				if(StringUtil.isNullOrEmpty(data.id))
				{
					throw new Error("ID不能为空!");
					
					return;
				}
				
				if(libs.containsKey(data.id))
				{
					throw new Error("ID：" + data.id + "已存在!");
					
					return;
				}
				
				libs.put(data.id, data);
			}
		}
		
		public static function getLibData(id:String):LibData
		{
			return libs.get(id);
		}
		
		public static function getLibPath(id:String):String
		{
			var data:LibData = getLibData(id);
			
			if(data == null) return "";
			
			return data.libPath;
		}
	}
}