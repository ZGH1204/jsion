package jsion.rpg.engine
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import jsion.Constant;
	import jsion.HashMap;
	import jsion.IDispose;
	import jsion.core.loaders.ImageLoader;
	import jsion.rpg.RPGGlobal;
	import jsion.rpg.engine.datas.MapInfo;
	import jsion.rpg.engine.datas.RPGInfo;
	import jsion.utils.DisposeUtil;
	import jsion.utils.PathUtil;
	import jsion.utils.StringUtil;
	
	public class RPGMap implements IDispose
	{
		/**
		 * 包含地图信息和其他信息
		 */		
		private var m_rpgInfo:RPGInfo;
		
		/**
		 * 当前地图信息
		 */		
		private var m_mapInfo:MapInfo;
		
		/**
		 * 镜头范围
		 */		
		private var m_cameraRect:Rectangle;
		
		/**
		 * 地图资源根目录
		 */		
		private var m_mapRoot:String;
		
		/**
		 * 地图分块资源目录
		 */		
		private var m_tilesRoot:String;
		
		/**
		 * 缓冲区横向所在的起始块索引
		 */		
		private var m_startTileX:int;
		
		/**
		 * 缓冲区纵向所在的起始块索引
		 */		
		private var m_startTileY:int;
		
		/**
		 * 缓冲区横向所占的分块数
		 */		
		private var m_areaTileX:int;
		
		/**
		 * 缓冲区纵向所占的分块数
		 */		
		private var m_areaTileY:int;
		
		/**
		 * 地图横向最大分块数
		 */		
		private var m_maxTileX:int;
		
		/**
		 * 地图纵向最大分块数
		 */		
		private var m_maxTileY:int;
		
		/**
		 * 缓冲区宽度
		 */		
		private var m_bufferWidth:int;
		
		/**
		 * 缓冲区高度
		 */		
		private var m_bufferHeight:int;
		
		/**
		 * 镜头中心点
		 */		
		private var m_center:Point;
		
		/**
		 * 缓冲区
		 */		
		private var m_buffer:BitmapData;
		
		/**
		 * 是否需要重绘缓冲区
		 */		
		public var needRepaint:Boolean;
		
		
		
		private var m_tempRect:Rectangle;
		
		protected var m_tempPoint:Point;
		
		
		protected var m_pool:ResourcePool;
		
		protected var m_loadings:HashMap;
		
		protected var m_loaderConfig:Object;
		
		protected var m_loadComplete:HashMap;
		
		public function RPGMap(info:RPGInfo, cameraWidth:int, cameraHeight:int)
		{
			m_rpgInfo = info;
			m_mapInfo = info.mapInfo;
			m_cameraRect = new Rectangle();
			m_cameraRect.width = cameraWidth;
			m_cameraRect.height = cameraHeight;
			
			m_mapRoot = StringUtil.format(RPGGlobal.MapRoot, m_mapInfo.mapID);
			m_tilesRoot = PathUtil.combinPath(m_mapRoot, "tiles");
			m_loaderConfig = { root: m_tilesRoot };
			
			m_startTileX = 0;
			m_startTileY = 0;
			
			m_areaTileX = int(m_cameraRect.width / m_mapInfo.tileWidth) + 1;
			m_areaTileY = int(m_cameraRect.height / m_mapInfo.tileHeight) + 1;
			
			m_maxTileX = Math.ceil(m_mapInfo.mapWidth / m_mapInfo.tileWidth);
			m_maxTileY = Math.ceil(m_mapInfo.mapHeight / m_mapInfo.tileHeight);
			
			m_bufferWidth = m_areaTileX * m_mapInfo.tileWidth;
			m_bufferHeight = m_areaTileY * m_mapInfo.tileHeight;
			
			m_center = new Point();
			
			m_center = center;
			
			m_buffer = new BitmapData(m_bufferWidth, m_bufferHeight, true, 0);
			
			m_tempRect = new Rectangle();
			
			m_tempPoint = new Point()
			
			m_pool = new ResourcePool();
			
			m_loadings = new HashMap();
			
			m_loadComplete = new HashMap();
			
			needRepaint = true;
		}
		
		/**
		 * 缓冲区
		 */		
		public function get buffer():BitmapData
		{
			return m_buffer;
		}
		
		/**
		 * 缓冲区宽度
		 */		
		public function get bufferWidth():int
		{
			return m_bufferWidth;
		}
		
		/**
		 * 缓冲区高度
		 */		
		public function get bufferHeight():int
		{
			return m_bufferHeight;
		}
		
		/**
		 * 镜头中心点坐标
		 */		
		public function get center():Point
		{
			m_center.x = Math.min(m_center.x, m_mapInfo.mapWidth - m_cameraRect.width / 2);
			m_center.x = Math.max(m_center.x, m_cameraRect.width / 2);
			
			m_center.y = Math.min(m_center.y, m_mapInfo.mapHeight - m_cameraRect.height / 2);
			m_center.y = Math.max(m_center.y, m_cameraRect.height / 2);
			
			return m_center;
		}
		
		/**
		 * 镜头中心点坐标
		 */		
		public function set center(pos:Point):void
		{
			m_center.x = pos.x;
			m_center.y = pos.y;
			
			var tmpX:int = cameraX;
			var tmpY:int = cameraY;
			
			if( tmpX < 0 || 
				tmpY < 0 || 
				tmpX > m_mapInfo.tileWidth || 
				tmpY >  m_mapInfo.tileHeight)
			{
				needRepaint = true;
				
				m_startTileX = int(screenX / m_mapInfo.tileWidth);
				m_startTileY = int(screenY / m_mapInfo.tileHeight);
			}
		}
		
		/**
		 * 缓冲区横向起始分块索引
		 */		
		public function get startTileX():int
		{
			return m_startTileX;
		}
		
		/**
		 * 缓冲区纵向起始分块索引
		 */		
		public function get startTileY():int
		{
			return m_startTileY;
		}
		
		/**
		 * 缓冲区镜头X坐标,有效范围(0 - TileWidth)
		 */		
		public function get cameraX():int
		{
			m_cameraRect.x = screenX - originX;
			
			return m_cameraRect.x;
		}
		
		/**
		 * 缓冲区镜头Y坐标,有效范围(0 - TileHeight)
		 */		
		public function get cameraY():int
		{
			m_cameraRect.y = screenY - originY;
			
			return m_cameraRect.y;
		}
		
		/**
		 * 缓冲区镜头范围
		 */		
		public function get cameraRect():Rectangle
		{
			m_cameraRect.x = screenX - originX;
			
			m_cameraRect.y = screenY - originY;
			
			return m_cameraRect;
		}
		
		/**
		 * 当前屏幕相对地图世界的X坐标值
		 */		
		public function get screenX():int
		{
			return center.x - m_cameraRect.width / 2;
		}
		
		/**
		 * 当前屏幕相对地图世界的Y坐标值
		 */		
		public function get screenY():int
		{
			return center.y - m_cameraRect.height / 2;
		}
		
		/**
		 * 缓冲区相对地图世界的起始坐标X
		 */		
		public function get originX():int
		{
			return m_startTileX * m_mapInfo.tileWidth;
		}
		
		/**
		 * 缓冲区相对地图世界的起始坐标Y
		 */		
		public function get originY():int
		{
			return m_startTileY * m_mapInfo.tileHeight;
		}
		
		/**
		 * 缓冲区相对地图世界的结束坐标X,缓冲区右下角。
		 */		
		public function get endX():int
		{
			return originX + m_areaTileX * m_mapInfo.tileWidth;
		}
		
		/**
		 * 缓冲区相对地图世界的结束坐标Y,缓冲区右下角。
		 */		
		public function get endY():int
		{
			return originY + m_areaTileY * m_mapInfo.tileHeight;
		}
		
		public function render(bitmapData:BitmapData):void
		{
			refreshBuffer();
			
			bitmapData.copyPixels(m_buffer, cameraRect, Constant.ZeroPoint);
		}
		
		public function renderLoadComplete(bitmapData:BitmapData):void
		{
			if(m_loadComplete.size == 0) return;
			
			var list:Array = m_loadComplete.getKeys();
			
			for each(var key:String in list)
			{
				var pos:Array = key.split("_");
				var tileX:int = int(pos[1]);
				var tileY:int = int(pos[0]);
				
				
				m_tempPoint.x = tileX * m_mapInfo.tileWidth;
				m_tempPoint.x = m_tempPoint.x - originX;
				m_tempPoint.x = m_tempPoint.x - cameraX;
				
				m_tempPoint.y = tileY * m_mapInfo.tileHeight;
				m_tempPoint.y = m_tempPoint.y - originY;
				m_tempPoint.y = m_tempPoint.y - cameraY;
				
				var bmd:BitmapData = m_pool.getResource(key) as BitmapData;
				
				bitmapData.copyPixels(bmd, bmd.rect, m_tempPoint);
			}
			
			m_loadComplete.removeAll();
		}
		
		protected function refreshBuffer():void
		{
			if(needRepaint)
			{
				fillMapTiles(m_buffer);
				
				needRepaint = false;
			}
		}
		
		protected function fillMapTiles(bmd:BitmapData):void
		{
			var startX:int = screenX;
			var startY:int = screenY;
			
			var temp:BitmapData;
			
			if(m_rpgInfo.smallOrLoopBmd != null)
			{
				var scale:Number = m_rpgInfo.smallOrLoopBmd.width / m_mapInfo.mapWidth;
				
				temp = new BitmapData(m_bufferWidth * scale, m_bufferHeight * scale, true, 0);
				
				m_tempRect.x = startX * scale;
				m_tempRect.y = startY * scale;
				m_tempRect.width = temp.width;
				m_tempRect.height = temp.height;
				
				temp.copyPixels(m_rpgInfo.smallOrLoopBmd, m_tempRect, Constant.ZeroPoint);
				
				scale = m_bufferWidth / temp.width;
				
				bmd.draw(temp, new Matrix(scale, 0, 0, scale));
				
				temp.dispose();
				
				temp = null;
			}
			
			//多加载缓冲区外圈一层的Tile资源文件
			var stTileX:int = Math.max(m_startTileX - 1, 0);
			var stTileY:int = Math.max(m_startTileY - 1, 0);
			var mxTileX:int = Math.min(m_areaTileX + m_startTileX + 1, m_maxTileX);
			var mxTileY:int = Math.min(m_areaTileY + m_startTileY + 1, m_maxTileY);
			
			for(var y:int = m_startTileY; y < mxTileY; y++)
			{
				for(var x:int = m_startTileX; x < mxTileX; x++)
				{
					if(x < 0 || y < 0) continue;
					
					var key:String = y + "_" + x;
					
					if(m_pool.hasResource(key))
					{
						temp = m_pool.getResource(key) as BitmapData;
						
						drawTile(bmd, temp, x, y);
					}
					else
					{
						if(m_loadings.containsKey(key)) continue;
						
						var loader:ImageLoader = new ImageLoader(key + m_mapInfo.tileExt, m_loaderConfig);
						
						loader.tag = key;
						
						m_loadings.put(loader.tag, loader);
						
						loader.loadAsync(tileLoadCallback);
					}
				}
			}
		}
		
		
		private function tileLoadCallback(loader:ImageLoader):void
		{
			m_loadings.remove(loader.tag);
			
			if(loader.isComplete == false)
			{
				trace(StringUtil.format("加载{0}出错", loader.uri));
				
				DisposeUtil.free(loader);
				
				return;
			}
			
			var key:String = loader.tag as String;
			
			var pos:Array = key.split("_");
			var x:int = int(pos[1]);
			var y:int = int(pos[0]);
			
			var bmd:BitmapData = Bitmap(loader.content).bitmapData.clone();
			
			m_pool.addResource(key, bmd);
			
			m_loadComplete.put(key, bmd);
			
			DisposeUtil.free(loader);
			
			drawTile(m_buffer, bmd, x, y);
		}
		
		
		private function drawTile(bmd:BitmapData, tileBmd:BitmapData, tileX:int, tileY:int):void
		{
			m_tempPoint.x = tileX * m_mapInfo.tileWidth;
			m_tempPoint.x = m_tempPoint.x - originX;
			
			m_tempPoint.y = tileY * m_mapInfo.tileHeight;
			m_tempPoint.y = m_tempPoint.y - originY;
			
			bmd.copyPixels(tileBmd, tileBmd.rect, m_tempPoint);
		}
		
		public function dispose():void
		{
			DisposeUtil.free(m_pool);
			m_pool = null;
			
			DisposeUtil.free(m_loadings);
			m_loadings = null;
			
			DisposeUtil.free(m_buffer);
			m_buffer = null;
			
			m_loaderConfig = null;
			m_tempPoint = null;
			m_tempRect = null;
			m_center = null;
			m_cameraRect = null;
			m_mapInfo = null;
			m_rpgInfo = null;
		}
	}
}