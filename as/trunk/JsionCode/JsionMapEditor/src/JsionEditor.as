package
{
	import flash.display.Stage;
	import flash.filesystem.File;

	public class JsionEditor
	{
		public static var W:Number;
		
		public static var H:Number;
		
		public static var stage:Stage;
		
		
		
		public static var MAP_NEWED_OPENED:Boolean = false;
		
		public static var MAP_OUTPUT_ROOT:String = File.applicationDirectory.nativePath;
		
		public static var MAP_OUTPUT_FORMAT:String = "{0}";
		
		public static var SMALLMAP_FILE_NAME:String = "small";
		
		public static var MAP_TILES_OUTPUT_FORMAT:String = "{0}/tiles";
		
		public static var MAP_TILES_FILENAME_FORMAT:String = "{1}_{0}{2}";
		
		public static var mapid:String = "未命名地图";
		
		public static var MAP_WIDTH:int = 2600;
		
		public static var MAP_HEIGHT:int = 2200;
		
		public static var SMALL_MAP_WIDTH:int = 300;
		
		public static var SMALL_MAP_HEIGHT:int = 200;
		
		public static var TILE_WIDTH:int = 200;
		
		public static var TILE_HEIGHT:int = 200;
	}
}