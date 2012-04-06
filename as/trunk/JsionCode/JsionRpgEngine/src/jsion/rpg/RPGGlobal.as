package jsion.rpg
{
	import flash.utils.ByteArray;
	
	import jsion.rpg.engine.datas.MapInfo;

	public class RPGGlobal
	{
		/**
		 * Maps\{MapID}
		 */		
		public static const MapRoot:String = "Maps\\{0}";
		
		
		public static function trans2Bytes(mapInfo:MapInfo):ByteArray
		{
			var bytes:ByteArray = new ByteArray();
			
			bytes.writeInt(mapInfo.mapID);
			bytes.writeUTF(mapInfo.mapName);
			bytes.writeInt(mapInfo.mapWidth);
			bytes.writeInt(mapInfo.mapHeight);
			bytes.writeInt(mapInfo.tileWidth);
			bytes.writeInt(mapInfo.tileHeight);
			bytes.writeInt(mapInfo.mapType);
			bytes.writeInt(mapInfo.smallWidth);
			bytes.writeUTF(mapInfo.tileExt);
			
			bytes.compress();
			
			return bytes;
		}
		
		public static function trans2MapInfo(bytes:ByteArray):MapInfo
		{
			bytes.uncompress();
			
			var mapInfo:MapInfo = new MapInfo();
			
			mapInfo.mapID = bytes.readInt();
			mapInfo.mapName = bytes.readUTF();
			mapInfo.mapWidth = bytes.readInt();
			mapInfo.mapHeight = bytes.readInt();
			mapInfo.tileWidth = bytes.readInt();
			mapInfo.tileHeight = bytes.readInt();
			mapInfo.mapType = bytes.readInt();
			mapInfo.smallWidth = bytes.readInt();
			mapInfo.tileExt = bytes.readUTF();
			
			return mapInfo;
		}
	}
}