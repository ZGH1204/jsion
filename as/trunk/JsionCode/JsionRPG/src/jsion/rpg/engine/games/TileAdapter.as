package jsion.rpg.engine.games
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	import jsion.rpg.engine.ResourcePool;

	public class TileAdapter implements IDispose
	{
		protected var m_map:WorldMap;
		
		protected var m_pool:ResourcePool;
		
		public function TileAdapter(map:WorldMap)
		{
			m_map = map;
			
			m_pool = new ResourcePool();
		}
		
		public function fill(buffer:BitmapData):void
		{
			
		}
		
		public function dispose():void
		{
			
		}
	}
}