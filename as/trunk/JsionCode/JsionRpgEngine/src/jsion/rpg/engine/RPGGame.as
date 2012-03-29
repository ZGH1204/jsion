package jsion.rpg.engine
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import jsion.IDispose;
	import jsion.rpg.engine.datas.MapInfo;
	import jsion.rpg.engine.datas.RPGInfo;
	import jsion.utils.DisposeUtil;
	
	public class RPGGame implements IDispose
	{
		protected var m_cameraRect:Rectangle;
		protected var m_bitmapData:BitmapData;
		
		protected var m_map:RPGMap;
		
		protected var m_rpgInfo:RPGInfo;
		
		protected var m_needRepaint:Boolean;
		
		public function RPGGame(w:int, h:int)
		{
			m_cameraRect = new Rectangle(0, 0, w, h);
			
			m_bitmapData = new BitmapData(w, h, true, 0);
		}
		
		public function setMap(info:RPGInfo):void
		{
			m_rpgInfo = info;
			m_needRepaint = true;
			DisposeUtil.free(m_map);
			m_map = new RPGMap(info, m_cameraRect.width, m_cameraRect.height);
		}
		
		public function get bitmapData():BitmapData
		{
			return m_bitmapData;
		}
		
		public function render():void
		{
			if(m_needRepaint)
			{
				if(m_map) m_map.render(m_bitmapData);
				m_needRepaint = false;
			}
			else
			{
				if(m_map) m_map.renderLoadComplete(m_bitmapData);
				//trace("RPGObject.clearMe();");
			}
			
			
			//trace("RPGObject.renderMe();");
		}
		
		public function get worldMap():RPGMap
		{
			return m_map;
		}
		
		public function get centerPoint():Point
		{
			return m_map.center;
		}
		
		public function set centerPoint(pos:Point):void
		{
			m_needRepaint = true;
			m_map.center = pos;
		}
		
		public function dispose():void
		{
		}
	}
}