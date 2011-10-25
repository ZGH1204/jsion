package jsion.rpg.engine.games
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import jsion.core.loaders.ImageLoader;
	import jsion.rpg.engine.RPGEngine;
	import jsion.rpg.engine.datas.MapConfig;
	import jsion.utils.DisposeUtil;
	import jsion.utils.PathUtil;

	public class WorldMap extends EventDispatcher implements IDispose
	{
		public static var MapsRoot:String = "";
		
		public var mapid:String;
		
		public var mapWidth:int;
		
		public var mapHeight:int;
		
		public var tileWidth:int;
		
		public var tileHeight:int;
		
		public var wayTileWidth:int;
		
		public var wayTileHeight:int;
		
		protected var m_mapRoot:String;
		
		protected var m_mapAssetRoot:String;
		
		protected var m_tileAssetRoot:String;
		
		protected var m_tileExtension:String;
		
		protected var m_mapConfig:MapConfig;
		
		protected var m_cameraWidth:int;
		
		protected var m_cameraHeight:int;
		
		protected var m_smallMap:BitmapData;
		
		protected var m_smallMapReady:Boolean;
		
		protected var m_tileAdapter:TileAdapter;
		
		protected var m_buffer:BitmapData;
		
		protected var m_areaTileX:int;
		
		protected var m_areaTileY:int;
		
		protected var m_wayAreaTileX:int;
		
		protected var m_wayAreaTileY:int;
		
		protected var m_nowTileX:int = -1;
		
		protected var m_nowTileY:int = -1;
		
		protected var m_nowAreaTileX:int = -1;
		
		protected var m_nowAreaTileY:int = -1;
		
		
		
		
		public var needRepaintMap:Boolean;
		
		
		protected var m_smallMapLoader:ImageLoader;
		
		protected var m_smallMapCallback:Function;
		
		protected var m_tileCallback:Function;
		
		
		
		protected var m_center:Point = new Point();
		
		protected var m_tempRect:Rectangle = new Rectangle();
		protected var m_tempPoint:Point = new Point();
		
		public function WorldMap(mapConfig:MapConfig, cameraWidth:int, cameraHeight:int)
		{
			m_mapConfig = mapConfig;
			
			m_cameraWidth = cameraWidth;
			m_cameraHeight = cameraHeight;
			
			initialize();
			
			loadSmallMap();
		}
		
		protected function initialize():void
		{
			mapid = m_mapConfig.MapID;
			mapWidth = m_mapConfig.MapWidth;
			mapHeight = m_mapConfig.MapHeight;
			tileWidth = m_mapConfig.TileWidth;
			tileHeight = m_mapConfig.TileHeight;
			wayTileWidth = m_mapConfig.WayTileWidth;
			wayTileHeight = m_mapConfig.WayTileHeight;
			
			updateAreaTiles();
			
			m_mapRoot = PathUtil.combinPath(MapsRoot, mapid, "/");
			m_mapAssetRoot = PathUtil.combinPath(MapsRoot, m_mapConfig.MapAssetRoot, "/");
			m_tileAssetRoot = PathUtil.combinPath(MapsRoot, m_mapConfig.TileAssetRoot, "/");
			m_tileExtension = m_mapConfig.TileExtension;
			
			m_tileAdapter = new TileAdapter(this);
			
			buildBuffer();
		}
		
		protected function updateAreaTiles():void
		{
			if(tileWidth <= 0) m_areaTileX = 1;
			else m_areaTileX = Math.ceil(m_cameraWidth / tileWidth);
			
			if(tileHeight <= 0) m_areaTileY = 1;
			else m_areaTileY = Math.ceil(m_cameraHeight / tileHeight);
			
			if(wayTileWidth <= 0) m_wayAreaTileX = 1;
			else m_wayAreaTileX = Math.ceil(m_cameraWidth / wayTileWidth);
			
			if(wayTileHeight <= 0) m_wayAreaTileY = 1;
			else m_wayAreaTileY = Math.ceil(m_cameraHeight / wayTileHeight);
		}
		
		protected function buildBuffer():void
		{
			m_buffer = new BitmapData(m_cameraWidth, m_cameraHeight, true, 0);
		}
		
		protected function loadSmallMap():void
		{
			m_smallMapLoader = new ImageLoader(m_mapConfig.SmallMapFile, {root: m_mapAssetRoot});
			m_smallMapLoader.loadAsync(smallMapLoadCallback);
		}
		
		private function smallMapLoadCallback(loader:ImageLoader):void
		{
			if(loader.isComplete == false)
			{
				throw new Error("缩略图加载失败");
				
				DisposeUtil.free(m_smallMapLoader);
				m_smallMapLoader = null;
				
				return;
			}
			
			var bmp:Bitmap = loader.content as Bitmap;
			
			m_smallMap = bmp.bitmapData.clone();
			
			DisposeUtil.free(m_smallMapLoader);
			m_smallMapLoader = null;
			
			refreshBuffer();
			
			needRepaintMap = true;
			
			m_smallMapReady = true;
			
			if(m_smallMapCallback != null) m_smallMapCallback();
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function render(buffer:BitmapData):void
		{
			if(m_smallMapReady)
			{
				refreshBuffer();
				
				needRepaintMap = false;
				
				buffer.copyPixels(m_buffer, m_buffer.rect, Constant.ZeroPoint);
			}
		}
		
		protected function refreshBuffer():void
		{
			m_nowTileX = originTileX;
			m_nowTileY = originTileY;
			
			m_nowAreaTileX = originWayTileX;
			m_nowAreaTileY = originWayTileY;
			
			m_buffer.lock();
			m_tileAdapter.fill(m_buffer);
			m_buffer.unlock();
		}
		
		public function screenToWorld(x:Number, y:Number):Point
		{
			m_tempPoint.x = originX + x;
			m_tempPoint.y = originY + y;
			
			return m_tempPoint;
		}
		
		public function screenToTile(x:Number, y:Number):Point
		{
			return worldToTile(x + originX, y + originY);
		}
		
		public function worldToScreen(x:Number, y:Number):Point
		{
			m_tempPoint.x = x - originX;
			m_tempPoint.y = y - originY;
			
			return m_tempPoint;
		}
		
		public function worldToTile(x:Number, y:Number):Point
		{
			m_tempPoint.x = x / tileWidth;
			m_tempPoint.y = y / tileHeight;
			
			return m_tempPoint;
		}
		
		public function tileToWorld(x:int, y:int):Point
		{
			m_tempPoint.x = x * tileWidth;
			m_tempPoint.y = y * tileHeight;
			
			return m_tempPoint;
		}
		
		public function tileToScreen(x:int, y:int):Point
		{
			return worldToScreen(x * tileWidth, y * tileHeight);
		}
		
		public function wayTileToScreen(x:int, y:int):Point
		{
			return worldToScreen(x * wayTileWidth, y * wayTileHeight);
		}
		
		public function screenToWayTile(x:Number, y:Number):Point
		{
			m_tempPoint.x = int((originX + x) / wayTileWidth);
			m_tempPoint.y = int((originY + y) / wayTileHeight);
			
			return m_tempPoint;
		}
		
		public function setCameraWH(w:int, h:int):void
		{
			if(w <= 0 || h <= 0) return;
			
			if(m_cameraWidth == w && m_cameraHeight == h) return;
			
			m_cameraWidth = w;
			
			m_cameraHeight = h;
			
			updateAreaTiles();
			
			needRepaintMap = true;
			
			buildBuffer();
		}
		
		public function get mapRoot():String
		{
			return m_mapRoot;
		}
		
		public function get mapAssetRoot():String
		{
			return m_mapAssetRoot;
		}
		
		public function get tileAssetRoot():String
		{
			return m_tileAssetRoot;
		}
		
		public function get tileExtension():String
		{
			return m_tileExtension;
		}
		
		public function get buffer():BitmapData
		{
			return m_buffer;
		}
		
		public function get smallMap():BitmapData
		{
			return m_smallMap;
		}
		
		public function get smallMapReady():Boolean
		{
			return m_smallMapReady;
		}
		
		public function get tileAdapter():TileAdapter
		{
			return m_tileAdapter;
		}
		
		public function get cameraRect():Rectangle
		{
			m_tempRect.x = originX;
			m_tempRect.y = originY;
			m_tempRect.width = m_cameraWidth;
			m_tempRect.height = m_cameraHeight;
			
			return m_tempRect;
		}
		
		public function get maxWayTileX():int
		{
			if(wayTileWidth <= 0) return 1;
			
			var max_x:int = int(mapWidth / wayTileWidth);
			
			if((mapWidth % wayTileWidth) != 0) max_x++;
			
			return max_x;
		}
		
		public function get maxWayTileY():int
		{
			if(wayTileHeight <= 0) return 1;
			
			var max_y:int = int(mapHeight / wayTileHeight);
			
			if((mapHeight % wayTileHeight) != 0) max_y++;
			
			return max_y;
		}
		
		public function get maxTileX():int
		{
			if(tileWidth <= 0) return 1;
			
			var max_X:int = int(mapWidth / tileWidth);
			
			if((mapWidth % tileWidth) != 0) max_X++;
			
			return max_X;
		}
		
		public function get maxTileY():int
		{
			if(tileHeight <= 0) return 1;
			
			var max_Y:int = int(mapHeight / tileHeight);
			
			if((mapHeight % tileHeight) != 0) max_Y++;
			
			return max_Y;
		}
		
		public function get originX():int
		{
			var screen_x:int = center.x - int(m_cameraWidth / 2);
			
			screen_x = Math.min(mapWidth - m_cameraWidth, screen_x);
			screen_x = Math.max(0, screen_x);
			
			return screen_x;
		}
		
		public function get originY():int
		{
			var screen_y:int = center.y - int(m_cameraHeight / 2);
			
			screen_y = Math.min(mapHeight - m_cameraHeight, screen_y);
			screen_y = Math.max(0, screen_y);
			
			return screen_y;
		}
		
		public function get originWayTileX():int
		{
			return int(originX / wayTileWidth);
		}
		
		public function get originWayTileY():int
		{
			return int(originY / wayTileHeight);
		}
		
		public function get originTileX():int
		{
			return int(originX / tileWidth);
		}
		
		public function get originTileY():int
		{
			return int(originY / tileHeight);
		}
		
		public function get center():Point
		{
			m_center.x = Math.min(m_center.x, mapWidth - m_cameraWidth / 2);
			m_center.x = Math.max(m_center.x, m_cameraWidth / 2);
			
			m_center.y = Math.min(m_center.y, mapHeight - m_cameraHeight / 2);
			m_center.y = Math.max(m_center.y, m_cameraHeight / 2);
			
			return m_center;
		}
		
		public function set center(value:Point):void
		{
			m_center = value;
			needRepaintMap = true;
		}
		
		public function get nowAreaTileX():int
		{
			return m_nowAreaTileX;
		}
		
		public function get nowAreaTileY():int
		{
			return m_nowAreaTileY;
		}
		
		public function get nowTileX():int
		{
			return m_nowTileX;
		}
		
		public function get nowTileY():int
		{
			return m_nowTileY;
		}
		
		public function get wayAreaTileX():int
		{
			return m_wayAreaTileX;
		}
		
		public function get wayAreaTileY():int
		{
			return m_wayAreaTileY;
		}
		
		public function get areaTileX():int
		{
			return m_areaTileX;
		}
		
		public function get areaTileY():int
		{
			return m_areaTileY;
		}
		
		public function get smallMapCallback():Function
		{
			return m_smallMapCallback;
		}
		
		public function set smallMapCallback(value:Function):void
		{
			m_smallMapCallback = value;
		}
		
		/**
		 * 调用方式：tileCallback(tileX, tileY, bmd)，其中，tileX和tileY为Tile编号(非坐标)。
		 */		
		public function get tileCallback():Function
		{
			return m_tileCallback;
		}
		
		public function set tileCallback(value:Function):void
		{
			m_tileCallback = value;
		}
		
		public static function getWayTileGridDataStr(wayTilesConfig:Array):String
		{
			var list:Array = [];
			list.length = wayTilesConfig.length;
			for(var i:int = 0; i < wayTilesConfig.length; i++)
			{
				list[i] = wayTilesConfig[i].join(",");
			}
			
			return list.join("|");
		}
		
		public static function parseWayTileGridData(str:String):Array
		{
			var rlt:Array = [];
			
			var yList:Array = str.split("|");
			
			rlt.length = yList.length;
			
			for(var i:int = 0; i < yList.length; i++)
			{
				rlt[i] = yList[i].split(",");
			}
			
			return rlt;
		}
		
		public function dispose():void
		{
			DisposeUtil.free(m_tileAdapter);
			m_tileAdapter = null;
			
			DisposeUtil.free(m_smallMap);
			m_smallMap = null;
			
			DisposeUtil.free(m_buffer);
			m_buffer = null;
		}
	}
}