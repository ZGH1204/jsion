package jsion.rpg
{
	import flash.display.BitmapData;
	
	import jsion.rpg.interfaces.IPrepareMap;
	import jsion.rpg.map.WorldMap;

	public class RPGGame
	{
		protected var m_prepareMap:IPrepareMap;
		
		protected var m_cameraWidth:int;
		
		protected var m_cameraHeight:int;
		
		protected var m_buffer:BitmapData;
		
		protected var m_worldMap:WorldMap;
		
		public function RPGGame(cameraWidth:int, cameraHeight:int)
		{
			m_cameraWidth = cameraWidth;
			m_cameraHeight = cameraHeight;
			
			m_buffer = new BitmapData(m_cameraWidth, m_cameraHeight, true, 0xFF000000);
			
			m_worldMap = new WorldMap();
			m_worldMap.setCameraSize(m_cameraWidth, m_cameraHeight);
		}
		
		public function get cameraWidth():int
		{
			return m_cameraWidth;
		}
		
		public function get cameraHeight():int
		{
			return m_cameraHeight;
		}
		
		public function get buffer():BitmapData
		{
			return m_buffer;
		}
		
		public function get worldMap():WorldMap
		{
			return m_worldMap;
		}
		
		public function render():void
		{
			m_worldMap.render(m_buffer);
		}
	}
}