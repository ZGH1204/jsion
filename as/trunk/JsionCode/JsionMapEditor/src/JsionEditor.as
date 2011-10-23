package
{
	import flash.display.Stage;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import jsion.rpg.engine.datas.MapConfig;
	import jsion.utils.StringUtil;
	import jsion.utils.XmlUtil;

	public class JsionEditor
	{
		public static var W:Number;
		
		public static var H:Number;
		
		public static var stage:Stage;
		
		
		public static var mapConfig:MapConfig = new MapConfig();
		
		
		public static var MAP_NEWED_OPENED:Boolean = false;
		
		public static var MAP_PIC_FILE:String = "";//
		
		public static var MAP_OUTPUT_ROOT:String = File.applicationDirectory.resolvePath("Maps").nativePath;//
		
		public static var MAP_OUTPUT_FORMAT:String = "{0}/assets";
		
		public static var MAP_TILES_OUTPUT_FORMAT:String = MAP_OUTPUT_FORMAT + "/tiles";
		
		public static var MAP_TILES_FILENAME_FORMAT:String = "{1}_{0}{2}";
		
		public static var MAP_TILES_EXTENSION:String = "";//
		
		public static var BIGMAP_FILE_NAME:String = "big_map";
		
		public static var SMALLMAP_FILE_NAME:String = "small_map.png";
		
//		public static var mapid:String = "未命名地图";
//		
//		public static var MAP_WIDTH:int = 2600;
//		
//		public static var MAP_HEIGHT:int = 2200;
//		
//		public static var SMALL_MAP_WIDTH:int = 300;
//		
//		public static var SMALL_MAP_HEIGHT:int = 200;
//		
//		public static var TILE_WIDTH:int = 200;
//		
//		public static var TILE_HEIGHT:int = 200;
		
		public static function saveMapConfig():void
		{
			JsionEditor.mapConfig.MapAssetRoot = StringUtil.format(JsionEditor.MAP_OUTPUT_FORMAT, JsionEditor.mapConfig.MapID);
			JsionEditor.mapConfig.SmallMapFile = JsionEditor.SMALLMAP_FILE_NAME;
			JsionEditor.mapConfig.TileAssetRoot = StringUtil.format(JsionEditor.MAP_TILES_OUTPUT_FORMAT, JsionEditor.mapConfig.MapID);
			JsionEditor.mapConfig.TileExtension = JsionEditor.MAP_TILES_EXTENSION;
			
			var xml:XML = XmlUtil.encodeWithProperty("Map", mapConfig);
			
			var file:File = new File(JsionEditor.MAP_OUTPUT_ROOT + "\\" + JsionEditor.mapConfig.MapID + "\\" + "config.map");
			if(file.exists) file.deleteFile();
			var fs:FileStream = new FileStream();
			fs.open(file, FileMode.WRITE);
			var str:String = xml.toXMLString();
			var bytes:ByteArray = new ByteArray();
			bytes.writeUTF(str);
			
			var bytes2:ByteArray = new ByteArray();
			bytes.position = 0;
			bytes.readShort();
			bytes.readBytes(bytes2);
			
			fs.writeBytes(bytes2);
			fs.close();
		}
	}
}