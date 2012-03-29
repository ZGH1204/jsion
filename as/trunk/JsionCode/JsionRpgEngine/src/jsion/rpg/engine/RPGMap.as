package jsion.rpg.engine
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	import jsion.IDispose;
	import jsion.rpg.RPGGlobal;
	import jsion.rpg.engine.datas.MapInfo;
	import jsion.rpg.engine.datas.RPGInfo;
	import jsion.utils.PathUtil;
	import jsion.utils.StringUtil;
	
	public class RPGMap implements IDispose
	{
		private var m_rpgInfo:RPGInfo;
		private var m_mapInfo:MapInfo;
		private var m_cameraWidth:int;
		private var m_cameraHeight:int;
		
		private var m_mapRoot:String;
		private var m_tilesRoot:String;
		
		private var m_startTileX:int;
		private var m_startTileY:int;
		
		private var m_areaTileX:int;
		private var m_areaTileY:int;
		
		private var m_maxTileX:int;
		private var m_maxTileY:int;
		
		private var m_bufferWidth:int;
		private var m_bufferHeight:int;
		
		private var m_center:Point;
		
		private var m_buffer:BitmapData;
		
		public var needRepaint:Boolean;
		
		public function RPGMap(info:RPGInfo, cameraWidth:int, cameraHeight:int)
		{
			m_rpgInfo = info;
			m_mapInfo = info.mapInfo;
			m_cameraWidth = cameraWidth;
			m_cameraHeight = cameraHeight;
			
			m_mapRoot = StringUtil.format(RPGGlobal.MapRoot, m_mapInfo.mapID)
			m_tilesRoot = PathUtil.combinPath(m_mapRoot, "tiles");
			
			m_startTileX = 0;
			m_startTileY = 0;
			
			m_areaTileX = int(m_cameraWidth / m_mapInfo.tileWidth) + 1;
			m_areaTileY = int(m_cameraHeight / m_mapInfo.tileHeight) + 1;
			
			m_maxTileX = Math.ceil(m_mapInfo.mapWidth / m_mapInfo.tileWidth);
			m_maxTileY = Math.ceil(m_mapInfo.mapHeight / m_mapInfo.tileHeight);
			
			m_bufferWidth = m_areaTileX * m_mapInfo.tileWidth;
			m_bufferHeight = m_areaTileY * m_mapInfo.tileHeight;
			
			m_center = new Point();
			
			m_buffer = new BitmapData(m_bufferWidth, m_bufferHeight, true, 0);
		}
		
		public function get buffer():BitmapData
		{
			return m_buffer;
		}
		
		/**
		 * 镜头中心点坐标
		 */		
		public function get center():Point
		{
			m_center.x = Math.min(m_center.x, m_mapInfo.mapWidth - m_cameraWidth / 2);
			m_center.x = Math.max(m_center.x, m_cameraWidth / 2);
			
			m_center.y = Math.min(m_center.y, m_mapInfo.mapHeight - m_cameraHeight / 2);
			m_center.y = Math.max(m_center.y, m_cameraHeight / 2);
			
			return m_center;
		}
		
		/**
		 * 镜头中心点坐标
		 */		
		public function set center(pos:Point):void
		{
			m_center.x = pos.x;
			m_center.y = pos.y;
		}
		
		/**
		 * 缓冲区起始坐标X
		 */		
		public function get originX():int
		{
			return m_startTileX * m_mapInfo.tileWidth;
		}
		
		/**
		 * 缓冲区起始坐标X
		 */		
		public function get originY():int
		{
			return m_startTileY * m_mapInfo.tileHeight;
		}
		
		/**
		 * 缓冲区结束坐标X
		 */		
		public function get endX():int
		{
			return originX + m_areaTileX * m_mapInfo.tileWidth;
		}
		
		/**
		 * 缓冲区结束坐标Y
		 */		
		public function get endY():int
		{
			return originY + m_areaTileY * m_mapInfo.tileHeight;
		}
		
		public function render(bitmapData:BitmapData):void
		{
			
		}
		
		public function dispose():void
		{
		}
	}
}