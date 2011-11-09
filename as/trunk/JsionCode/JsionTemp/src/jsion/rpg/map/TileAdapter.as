package jsion.rpg.map
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	import jsion.rpg.ResourcePool;

	public class TileAdapter implements IDispose
	{
		protected var m_map:WorldMap;
		
		protected var m_loadings:HashMap;
		
		protected var m_pool:ResourcePool;
		
		protected var m_smallMapRect:Rectangle;
		
		public function TileAdapter(map:WorldMap)
		{
			m_map = map;
			
			m_loadings = new HashMap();
			
			m_pool = new ResourcePool();
			
			m_smallMapRect = new Rectangle();
		}
		
		public function fill(buffer:BitmapData):void
		{
		}
		
		public function dispose():void
		{
		}
	}
}