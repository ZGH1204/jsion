package jsion.rpg
{
	import jsion.HashMap;

	public class RPGGlobal
	{
		public static const MAP_CONFIG_FILE:String = "Config.map";
		
		public static const SMALL_MAP_FILE:String = "SmallMap.jpg";
		
		public static const BUILDING_ASSET_DIR:String = "Buildings";
		
		public static const NPC_ASSET_DIR:String = "NPCs";
		
		public static const TILE_ASSET_DIR:String = "Tiles";
		
		public static var MAPS_ROOT:String = "";
		
		public static var TIMER:int = 0;
		
		public static var MAP_CONFIG_LIST:HashMap = new HashMap();
		
		public static var SMALL_MAP_LIST:HashMap = new HashMap();
		
		public static var ResPool:ResourcePool = new ResourcePool();
	}
}