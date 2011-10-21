package
{
	import flash.display.Stage;
	import flash.filesystem.File;

	public class JsionEditor
	{
		public static var W:Number;
		
		public static var H:Number;
		
		public static var stage:Stage;
		
		
		
		public static var EIDTOR_OUTPUT_ROOT:String = File.desktopDirectory.nativePath;
		
		public static var MAP_OUTPUT_FORMAT:String = "map_{0}";
		
		public static var SMALLMAP_FILE_NAME:String = "small";
		
		public static var MAP_TILES_OUTPUT_FORMAT:String = "map_{0}/tiles";
		
		public static var MAP_TILES_FILENAME_FORMAT:String = "{1}_{0}{2}";
		
		public static var mapid:String = "Demo";
		
		public static var MAP_WIDTH:int = 2600;
		
		public static var MAP_HEIGHT:int = 2200;
		
		public static var SMALL_MAP_WIDTH:int = 300;
		
		public static var SMALL_MAP_HEIGHT:int = 200;
		
		public static var TILE_WIDTH:int = 200;
		
		public static var TILE_HEIGHT:int = 200;
	}
}