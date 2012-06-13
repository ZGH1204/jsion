package jsion.rpg.engine.datas
{
	public dynamic class MapInfo
	{
		/**
		 * 以Tile方法加载显示
		 */		
		public static const TileMap:int = 1;
		
		/**
		 * 以循环背景方法显示
		 */		
		public static const LoopMap:int = 2;
		
		/**
		 * 地图ID
		 */		
		public var mapID:int;
		
		/**
		 * 地图名称
		 */		
		public var mapName:String;
		
		/**
		 * 地图宽度
		 */		
		public var mapWidth:int;
		
		/**
		 * 地图高度
		 */		
		public var mapHeight:int;
		
		/**
		 * 地图类型：
		 * 1.大张切割地图(以Tile方法加载显示)
		 * 2.循环背景地图
		 */		
		public var mapType:int;
		
		/**
		 * 缩略图宽度
		 */		
		public var smallWidth:int;
		
		/**
		 * 缩略图高度(暂时无效)
		 */		
		public var smallHeight:int;
		
		/**
		 * 每块宽度
		 */		
		public var tileWidth:int;
		
		/**
		 * 每块高度
		 */		
		public var tileHeight:int;
		
		/**
		 * 切割块文件的扩展名
		 */		
		public var tileExt:String;
		
//		/**
//		 * 循环背景图片相对路径(含完整文件名)
//		 */		
//		public var loopPic:String;
	}
}