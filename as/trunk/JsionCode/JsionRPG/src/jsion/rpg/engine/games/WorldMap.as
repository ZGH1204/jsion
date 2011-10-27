package jsion.rpg.engine.games
{
	import flash.display.BitmapData;
	
	import jsion.core.loaders.ImageLoader;
	import jsion.rpg.engine.datas.MapConfig;
	import jsion.utils.DisposeUtil;

	public class WorldMap extends BaseMap
	{
		protected var m_smallMap:BitmapData;
		
		protected var m_tileAdapter:TileAdapter;
		
		protected var m_smallMapLoader:ImageLoader;
		
		public function WorldMap(mapConfig:MapConfig, mapsRoot:String, smallMapBmd:BitmapData, cameraWidth:int, cameraHeight:int)
		{
			m_smallMap = smallMapBmd;
			
			super(mapConfig, mapsRoot, cameraWidth, cameraHeight);
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			m_tileAdapter = new TileAdapter(this);
			
			refreshBuffer();
			
			needRepaintMap = true;
		}
		
		override protected function refreshBuffer():void
		{
			super.refreshBuffer();
			
			m_buffer.lock();
			m_tileAdapter.fill(m_buffer);
			m_buffer.unlock();
		}
		
		public function get smallMap():BitmapData
		{
			return m_smallMap;
		}
		
		public function get tileAdapter():TileAdapter
		{
			return m_tileAdapter;
		}
		
		override public function dispose():void
		{
			DisposeUtil.free(m_tileAdapter);
			m_tileAdapter = null;
			
			DisposeUtil.free(m_smallMap);
			m_smallMap = null;
			
			DisposeUtil.free(m_smallMapLoader);
			m_smallMapLoader = null;
			
			super.dispose();
		}
	}
}