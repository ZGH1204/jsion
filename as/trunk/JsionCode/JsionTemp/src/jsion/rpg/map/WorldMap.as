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
		protected var m_cameraTileWidth:int;
		protected var m_cameraTileHeight:int;
		
		
		protected var m_buffer:BitmapData;
		
		protected var m_needRepaintBuffer:Boolean;
		
		protected var m_centerPoint:Point;
		
		protected var m_centerPointRect:Rectangle;
		
		public function WorldMap()
		{
			m_needRepaintBuffer = false;
			m_centerPoint = new Point();
			m_centerPointRect = new Rectangle();
		}
		
		public function get needRepaint():Boolean
		{
			return m_needRepaintBuffer;
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
		
		public function calcCameraTileSize():void
		{
			m_cameraTileWidth = Math.ceil(m_cameraWidth / m_tileWidth);
			m_cameraTileHeight = Math.ceil(m_cameraHeight / m_tileHeight);
		}
		
		public function calcCenterPointRect():void
		{
			m_centerPointRect.x = Math.ceil(m_cameraWidth / 2);
			m_centerPointRect.y = Math.ceil(m_cameraHeight / 2);
			m_centerPointRect.width = m_mapWidth - m_cameraWidth;
			m_centerPointRect.height = m_mapHeight - m_cameraHeight;
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
		
		public function render(buffer:BitmapData):void
		{
			if(m_needRepaintBuffer)
			{
				repaintBufferImp();
				
				m_needRepaintBuffer = false;
				
				buffer.copyPixels(m_buffer, m_buffer.rect, Constant.ZeroPoint);
			}
		}
	}
}