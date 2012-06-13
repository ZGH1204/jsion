package jsion.rpg.engine.renders
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import jsion.rpg.engine.RPGMap;
	import jsion.rpg.engine.objects.RPGObject;

	public class Render2D
	{
		/**
		 * 地图引用
		 */		
		public var map:RPGMap;
		
		/**
		 * 引用成像区位图数据
		 */		
		public var buffer:BitmapData;
		
		
		protected var m_renderPos:Point;
		
		
		private var m_tempPoint:Point;
		
		public function Render2D()
		{
			m_renderPos = new Point();
		}
		
		public function clearMe(object:RPGObject):void
		{
			buffer.copyPixels(map.buffer, object.lastRenderRect, object.lastRenderPoint);
		}
		
		public function renderMe(object:RPGObject):void
		{
			m_tempPoint = map.world2Screen(object.x, object.y);
			
			object.updateRenderPoint(m_renderPos, m_tempPoint);
			
			buffer.copyPixels(object.bitmapData, object.bmdRect, m_renderPos, null, null, true);
			
			object.setLastRenderXY(m_renderPos.x, m_renderPos.y);
		}
	}
}