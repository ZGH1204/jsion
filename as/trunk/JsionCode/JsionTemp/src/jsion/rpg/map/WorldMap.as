package jsion.rpg.map
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import jsion.utils.DisposeUtil;

	public class WorldMap
	{
		protected var m_mapid:String;
		protected var m_smallMapBmd:BitmapData;
		protected var m_cameraWidth:int;
		protected var m_cameraHeight:int;
		protected var m_mapWidth:int;
		protected var m_mapHeight:int;
		protected var m_tileWidth:int;
		protected var m_tileHeight:int;
		
		
		protected var m_buffer:BitmapData;
		
		protected var m_needRepaintBuffer:Boolean;
		
		protected var m_centerPoint:Point;
		
		protected var m_centerPointRect:Rectangle;
		
		protected var m_startX:int;
		
		protected var m_startY:int;
		
		protected var m_startTileX:int;
		
		protected var m_startTileY:int;
		
		protected var m_cameraTileCountX:int;
		
		protected var m_cameraTileCountY:int;
		
		
		protected var m_tileLoadCompletes:HashMap;
		
		
		public function WorldMap()
		{
			m_needRepaintBuffer = false;
			m_centerPoint = new Point();
			m_centerPointRect = new Rectangle();
			m_tileLoadCompletes = new HashMap();
		}
		
		public function get buffer():BitmapData
		{
			return m_buffer;
		}
		
		public function get needRepaint():Boolean
		{
			return m_needRepaintBuffer;
		}
		
		public function get center():Point
		{
			return m_centerPoint;
		}
		
		public function get startX():int
		{
			return m_startX;
		}
		
		public function get startY():int
		{
			return m_startY;
		}
		
		public function get startTileX():int
		{
			return m_startTileX;
		}
		
		public function get startTileY():int
		{
			return m_startTileY;
		}
		
		public function get cameraTileCountX():int
		{
			return m_cameraTileCountX;
		}
		
		public function get cameraTileCountY():int
		{
			return m_cameraTileCountY;
		}
		
		public function setCenter(x:int, y:int):void
		{
			m_centerPoint.x = x;
			m_centerPoint.y = y;
			
			calcOthers();
			
			repaintBuffer();
		}
		
		public function setCenterByPoint(pos:Point):void
		{
			m_centerPoint.x = pos.x;
			m_centerPoint.y = pos.y;
			
			calcOthers();
			
			repaintBuffer();
		}
		
		public function setMapID(mapid:String):void
		{
			m_mapid = mapid;
		}
		
		public function setSmallMap(bmd:BitmapData):void
		{
			m_smallMapBmd = bmd;
		}
		
		public function setCameraSize(w:int, h:int):void
		{
			m_cameraWidth = w;
			m_cameraHeight = h;
		}
		
		public function setMapSize(w:int, h:int):void
		{
			m_mapWidth = w;
			m_mapHeight = h;
		}
		
		public function setTileSize(w:int, h:int):void
		{
			m_tileWidth = w;
			m_tileHeight = h;
		}
		
		public function calcCenterPointRect():void
		{
			m_centerPointRect.x = Math.ceil(m_cameraWidth / 2);
			m_centerPointRect.y = Math.ceil(m_cameraHeight / 2);
			m_centerPointRect.width = m_mapWidth - m_cameraWidth;
			m_centerPointRect.height = m_mapHeight - m_cameraHeight;
		}
		
		public function calcCameraTileCount():void
		{
			m_cameraTileCountX = Math.ceil(m_cameraWidth / m_tileWidth);
			m_cameraTileCountY = Math.ceil(m_cameraHeight / m_tileHeight);
		}
		
		public function calcOthers():void
		{
			m_startX = m_centerPoint.x - m_cameraWidth / 2;
			m_startY = m_centerPoint.y - m_cameraHeight / 2;
			m_startTileX = m_startX / m_tileWidth;
			m_startTileY = m_startY / m_tileHeight;
		}
		
		public function reviseCenterPoint():void
		{
			m_centerPoint.x = Math.max(m_centerPoint.x, m_centerPointRect.x);
			m_centerPoint.x = Math.min(m_centerPoint.x, m_centerPointRect.right);
			
			m_centerPoint.y = Math.max(m_centerPoint.y, m_centerPointRect.y);
			m_centerPoint.y = Math.max(m_centerPoint.y, m_centerPointRect.bottom);
		}
		
		public function build():void
		{
			var tmp:BitmapData = m_buffer;
			
			m_buffer = new BitmapData(m_cameraWidth, m_cameraHeight, true, 0x00000000);
			
			if(tmp) m_buffer.copyPixels(tmp, tmp.rect, Constant.ZeroPoint);
			
			DisposeUtil.free(tmp);
			tmp = null;
			
			repaintBuffer();
		}
		
		public function repaintBuffer():void
		{
			m_needRepaintBuffer = true;
		}
		
		protected function repaintBufferImp():void
		{
		}
		
		public function render(buff:BitmapData):void
		{
			if(m_needRepaintBuffer)
			{
				repaintBufferImp();
				
				m_needRepaintBuffer = false;
				
				m_tileLoadCompletes.removeAll();
			}
			
			buff.copyPixels(m_buffer, m_buffer.rect, Constant.ZeroPoint);
		}
		
		
		
		
		internal function addTileLoadComplete(x:int, y:int, bmd:BitmapData):void
		{
			m_tileLoadCompletes.put(y + "_" + x, bmd);
		}
		
		public function updateTileLoadComplete(buff:BitmapData):void
		{
			if(m_tileLoadCompletes.size == 0) return;
			
			var keys:Array = m_tileLoadCompletes.getKeys();
			
			var list:Array;
			
			var x:int, y:int;
			
			var bmd:BitmapData;
			
			for each(var key:String in keys)
			{
				list = key.split("_");
				x = int(list[1]);
				y = int(list[0]);
				bmd = m_tileLoadCompletes[key];
			}
			
			m_tileLoadCompletes.removeAll();
		}
	}
}