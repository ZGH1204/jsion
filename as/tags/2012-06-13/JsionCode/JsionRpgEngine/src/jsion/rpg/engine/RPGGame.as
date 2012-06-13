package jsion.rpg.engine
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import jsion.Constant;
	import jsion.IDispose;
	import jsion.rpg.engine.datas.MapInfo;
	import jsion.rpg.engine.datas.RPGInfo;
	import jsion.rpg.engine.objects.RPGObject;
	import jsion.rpg.engine.renders.Render2D;
	import jsion.utils.ArrayUtil;
	import jsion.utils.DisposeUtil;
	
	public class RPGGame implements IDispose
	{
		protected var m_cameraRect:Rectangle;
		protected var m_bitmapData:BitmapData;
		
		protected var m_map:RPGMap;
		
		protected var m_rpgInfo:RPGInfo;
		
		protected var m_needRepaint:Boolean;
		
		
		
		protected var m_render:Render2D;
		
		protected var m_objects:Array;
		
		public function RPGGame(w:int, h:int)
		{
			m_cameraRect = new Rectangle(0, 0, w, h);
			
			m_bitmapData = new BitmapData(w, h, true, 0);
			
			m_objects = [];
			
			m_render = new Render2D();
			
			updateRenders();
		}
		
		public function addObject(obj:RPGObject):void
		{
			if(obj)
			{
				ArrayUtil.push(m_objects, obj);
				
				obj.game = this;
				obj.render = m_render;
			}
		}
		
		public function removeObject(obj:RPGObject):void
		{
			ArrayUtil.remove(m_objects, obj);
		}
		
		public function setMap(info:RPGInfo):void
		{
			m_rpgInfo = info;
			
			DisposeUtil.free(m_map);
			m_map = new RPGMap(info, m_cameraRect.width, m_cameraRect.height);
			
			needRepaint();
			
			updateRenders();
		}
		
		public function setCameraSize(w:int, h:int):void
		{
			m_cameraRect.width = w;
			m_cameraRect.height = h;
			
			needRepaint();
			
			var bmd:BitmapData = m_bitmapData;
			
			m_bitmapData = new BitmapData(w, h, true, 0);
			
			if(bmd) m_bitmapData.copyPixels(bmd, bmd.rect, Constant.ZeroPoint);
			
			if(m_map) m_map.setCameraSize(w, h);
			
			updateRenders();
		}
		
		public function updateRenders():void
		{
			m_render.map = m_map;
			m_render.buffer = m_bitmapData;
		}
		
		public function get bitmapData():BitmapData
		{
			return m_bitmapData;
		}
		
		public function render():void
		{
			sortZOrder(m_objects);
			
			if(m_needRepaint)
			{
				m_map.render(m_bitmapData);
				m_needRepaint = false;
				
				renderObjects(m_objects);
				
				//trace("RPGObject.renderMe();");
			}
			else if(m_map)
			{
				m_map.renderLoadComplete(m_bitmapData);
				
				clearObjects(m_objects);
				
				renderObjects(m_objects);
				
				//trace("RPGObject.clearMe();");
				
				//trace("RPGObject.renderMe();");
			}
		}
		
		protected function sortZOrder(list:Array):void
		{
			list.sortOn("zOrder", Array.NUMERIC);
		}
		
		protected function clearObjects(list:Array):void
		{
			for each(var obj:RPGObject in list)
			{
				obj.clearMe();
			}
		}
		
		protected function renderObjects(list:Array):void
		{
			for each(var obj:RPGObject in list)
			{
				obj.renderMe();
			}
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
			needRepaint();
			m_map.center = pos;
		}
		
		protected function needRepaint():void
		{
			m_needRepaint = m_map != null;
		}
		
		public function dispose():void
		{
		}
	}
}