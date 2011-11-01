package
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import jsion.rpg.engine.datas.MapConfig;
	import jsion.rpg.engine.games.BaseMap;
	import jsion.utils.StringUtil;
	import jsion.utils.XmlUtil;
	
	import org.aswing.VectorListModel;

	public class JsionEditor
	{
		public static var mapConfig:MapConfig = new MapConfig();
		
		public static var mapWayConfig:Array = [];
		
		public static var MAP_NEWED_OPENED:Boolean = false;
		
		public static var MAP_PIC_FILE:String = "";//
		
		public static var MAP_OUTPUT_ROOT:String = File.applicationDirectory.resolvePath("Maps").nativePath;//
		
		public static var MAP_OUTPUT_FORMAT:String = "{0}/assets";
		
		public static var MAP_TILES_OUTPUT_FORMAT:String = MAP_OUTPUT_FORMAT + "/tiles";
		
		public static var MAP_SURFACES_DIR:String = "surfaces";
		
		public static var MAP_SURFACES_FORMAT:String = MAP_OUTPUT_FORMAT + "/" + MAP_SURFACES_DIR;
		
		public static var MAP_BUILDINGS_DIR:String = "buildings";
		
		public static var MAP_BUILDINGS_FORMAT:String = MAP_OUTPUT_FORMAT + "/" + MAP_BUILDINGS_DIR;
		
		public static var MAP_NPCS_DIR:String = "npcs";
		
		public static var MAP_NPCS_FORMAT:String = MAP_OUTPUT_FORMAT + "/" + MAP_NPCS_DIR;
		
		public static var MAP_TILES_FILENAME_FORMAT:String = "{1}_{0}{2}";
		
		public static var MAP_TILES_EXTENSION:String = "";//
		
		public static var BIGMAP_FILE_NAME:String = "big_map";
		
		public static var SMALLMAP_FILE_NAME:String = "small_map.png";
		
		
		
		public static var surfaceRenderInfo:HashMap = new HashMap();
		
		public static var buildingRenderInfo:HashMap = new HashMap();
		
		public static var npcRenderInfo:HashMap = new HashMap();
		
		public static var surfaceModule:VectorListModel = new VectorListModel();
		
		public static var buildingModule:VectorListModel = new VectorListModel();
		
		public static var npcModule:VectorListModel = new VectorListModel();
		
		
		
		
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
		
		public static function getMapRoot():String
		{
			return new File(MAP_OUTPUT_ROOT).resolvePath(mapConfig.MapID).nativePath;
		}
		
		public static function getMapAssetRoot():String
		{
			var dir:String = StringUtil.format(MAP_OUTPUT_FORMAT, mapConfig.MapID);
			dir = new File(MAP_OUTPUT_ROOT).resolvePath(dir).nativePath;
			return dir;
		}
		
		public static function getTileRoot():String
		{
			var dir:String = StringUtil.format(MAP_TILES_OUTPUT_FORMAT, mapConfig.MapID);
			dir = new File(MAP_OUTPUT_ROOT).resolvePath(dir).nativePath;
			return dir;
		}
		
		public static function getSurfacesRoot():String
		{
			var dir:String = StringUtil.format(MAP_SURFACES_FORMAT, mapConfig.MapID);
			dir = new File(MAP_OUTPUT_ROOT).resolvePath(dir).nativePath;
			return dir;
		}
		
		public static function getBuildingsRoot():String
		{
			var dir:String = StringUtil.format(MAP_BUILDINGS_FORMAT, mapConfig.MapID);
			dir = new File(MAP_OUTPUT_ROOT).resolvePath(dir).nativePath;
			return dir;
		}
		
		public static function getNPCsRoot():String
		{
			var dir:String = StringUtil.format(MAP_NPCS_FORMAT, mapConfig.MapID);
			dir = new File(MAP_OUTPUT_ROOT).resolvePath(dir).nativePath;
			return dir;
		}
		
		public static function getBigMapPicPath(extName:String):String
		{
			var file:File = new File(getMapRoot());
			
			return file.resolvePath(BIGMAP_FILE_NAME + extName).nativePath;
		}
		
		public static function getSmallMapPicPath():String
		{
			var file:File = new File(getMapAssetRoot());
			
			return file.resolvePath(SMALLMAP_FILE_NAME).nativePath;
		}
		
		public static function getMapConfigRelativePath():String
		{
			return JsionEditor.mapConfig.MapID + "\\" + "config.map";
		}
		
		public static function getMapConfigPath():String
		{
			return JsionEditor.MAP_OUTPUT_ROOT + "\\" + JsionEditor.mapConfig.MapID + "\\" + "config.map";
		}
		
		public static function createWayTileGridData():void
		{
			JsionEditor.mapWayConfig = [];
			
			var xWayCount:int = JsionEditor.mapConfig.MapWidth / JsionEditor.mapConfig.WayTileWidth;
			if((JsionEditor.mapConfig.MapWidth % JsionEditor.mapConfig.WayTileWidth) != 0) xWayCount++;
			
			var yWayCount:int = JsionEditor.mapConfig.MapHeight / JsionEditor.mapConfig.WayTileHeight;
			if((JsionEditor.mapConfig.MapHeight % JsionEditor.mapConfig.WayTileHeight) != 0) yWayCount++;
			
			JsionEditor.mapWayConfig.length = yWayCount;
			
			for(var j:int = 0; j < yWayCount; j++)
			{
				JsionEditor.mapWayConfig[j] = [];
				JsionEditor.mapWayConfig[j].length = xWayCount;
				for(var i:int = 0; i < xWayCount; i++)
				{
					JsionEditor.mapWayConfig[j][i] = 0;
				}
			}
		}
		
		public static function getWayTileGridDataStr():String
		{
			return BaseMap.getWayTileGridDataStr(mapWayConfig);
		}
		
		public static function parseWayTileGridData(str:String):Array
		{
			return BaseMap.parseWayTileGridData(str);
		}
		
		public static function saveMapConfig(mapEditor:JsionMapEditor):void
		{
			if(MAP_NEWED_OPENED == false)
			{
				if(mapEditor) mapEditor.msg("未打开或创建地图");
				return;
			}
			
			JsionEditor.mapConfig.MapAssetRoot = StringUtil.format(JsionEditor.MAP_OUTPUT_FORMAT, JsionEditor.mapConfig.MapID);
			JsionEditor.mapConfig.SmallMapFile = JsionEditor.SMALLMAP_FILE_NAME;
			JsionEditor.mapConfig.TileAssetRoot = StringUtil.format(JsionEditor.MAP_TILES_OUTPUT_FORMAT, JsionEditor.mapConfig.MapID);
			JsionEditor.mapConfig.SurfaceAssetRoot = StringUtil.format(JsionEditor.MAP_SURFACES_FORMAT, JsionEditor.mapConfig.MapID);
			JsionEditor.mapConfig.BuildingAssetRoot = StringUtil.format(JsionEditor.MAP_BUILDINGS_FORMAT, JsionEditor.mapConfig.MapID);
			JsionEditor.mapConfig.NPCAssetRoot = StringUtil.format(JsionEditor.MAP_NPCS_FORMAT, JsionEditor.mapConfig.MapID);
			JsionEditor.mapConfig.TileExtension = JsionEditor.MAP_TILES_EXTENSION;
			
			var xml:XML = XmlUtil.encodeWithProperty("Map", mapConfig);
			
			//TODO:确定解析格式并保存碰撞格子信息
			var ways:String = getWayTileGridDataStr();
			
			var waysXml:XML = new XML("<ways>" + ways + "</ways>");
			
			xml.appendChild(waysXml);
			
			var file:File = new File(getMapConfigPath());
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
			
			if(mapEditor) mapEditor.msg("保存成功", 0);
		}
	}
}