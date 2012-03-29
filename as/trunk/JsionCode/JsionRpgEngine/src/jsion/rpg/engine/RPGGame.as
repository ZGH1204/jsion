package jsion.rpg.engine
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	import jsion.IDispose;
	import jsion.rpg.engine.datas.MapInfo;
	import jsion.rpg.engine.datas.RPGInfo;
	
	public class RPGGame implements IDispose
	{
		protected var m_cameraRect:Rectangle;
		protected var m_bitmapData:BitmapData;
		
		protected var m_map:RPGMap;
		
		protected var m_mapRepainted:Boolean;
		
		protected var m_rpgInfo:RPGInfo;
		
		public function RPGGame(w:int, h:int)
		{
			m_cameraRect = new Rectangle(0, 0, w, h);
			
			m_bitmapData = new BitmapData(w, h, true, 0);
		}
		
		public function setMap(info:RPGInfo):void
		{
			m_rpgInfo = info;
			
			m_map = new RPGMap(info, m_cameraRect.width, m_cameraRect.height);
		}
		
		public function get bitmapData():BitmapData
		{
			return m_bitmapData;
		}
		
		public function render():void
		{
			if(m_map.needRepaint)
			{
				m_map.render(m_bitmapData);
				m_mapRepainted = true;
			}
			
			if(m_mapRepainted)
			{
				m_mapRepainted = false;
			}
			else
			{
				trace("RPGObject.clearMe();");
			}
		}
		
		public function dispose():void
		{
		}
	}
}