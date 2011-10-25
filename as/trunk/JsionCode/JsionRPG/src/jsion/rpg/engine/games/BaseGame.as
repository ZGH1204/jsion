package jsion.rpg.engine.games
{
	import flash.display.BitmapData;
	
	import jsion.rpg.engine.RPGEngine;
	import jsion.rpg.engine.datas.MapConfig;

	public class BaseGame implements IDispose
	{
		protected var m_objects:Array;
		
		protected var m_renders:Array;
		
		protected var m_buffer:BitmapData;
		
		protected var m_worldMap:WorldMap;
		
		
		protected var m_starting:Boolean;
		
		protected var m_gameWidth:int;
		
		protected var m_gameHeight:int;
		
		protected var m_mapConfig:MapConfig;
		
		protected var m_tileCompleteList:HashMap;
		
		public function BaseGame(w:int, h:int, mapConfig:MapConfig)
		{
			m_gameWidth = w;
			m_gameHeight = h;
			m_mapConfig = mapConfig;
			
			initialize();
		}
		
		protected function initialize():void
		{
			m_objects = [];
			
			m_renders = [];
			
			m_tileCompleteList = new HashMap();
			
			buildBuffer();
			
			m_worldMap = new WorldMap(m_mapConfig, m_gameWidth, m_gameHeight);
			m_worldMap.tileCallback = tileCompleteCallback;
		}
		
		protected function buildBuffer():void
		{
			m_buffer = new BitmapData(m_gameWidth, m_gameHeight, true, 0);
		}
		
		/**
		 * 单个Tile图片加载完成时同时更新视图
		 * @param tileX Tile编号(非坐标)
		 * @param tileY Tile编号(非坐标)
		 * @param bmd 图片数据
		 * 
		 */		
		protected function tileCompleteCallback(tileX:int, tileY:int, bmd:BitmapData):void
		{
			//TODO:保存到新完成的Tile加载检测列表
			//m_worldMap.needRepaintMap = true;
			
			m_tileCompleteList.put(tileY + "_" + tileX, bmd);
		}
		
		public function render():void
		{
			if(m_worldMap.needRepaintMap)
			{
				//TODO:清除新完成的Tile加载检测列表
				m_tileCompleteList.removeAll();
				m_worldMap.render(m_buffer);
			}
			else if(m_tileCompleteList.size > 0)
			{
				//TODO:检测是否有新完成的Tile加载需要更新视图
				var keys:Array = m_tileCompleteList.getKeys();
				
				var startx:int = m_worldMap.originX;
				var starty:int = m_worldMap.originY;
				
				for each(var key:String in keys)
				{
					var pos:Array = key.split("_");
					var x:int = pos[1];
					var y:int = pos[0];
					
					m_worldMap.tileAdapter.drawTile(m_buffer, m_tileCompleteList.get(key) as BitmapData, x, y, startx, starty);
				}
				
				m_tileCompleteList.removeAll();
			}
			
			//TODO:脏矩形渲染所有objectes或renders对象
		}
		
		public function setCameraWH(w:int, h:int):void
		{
			if(w <= 0 || h <= 0) return;
			
			if(m_gameWidth == w && m_gameHeight == h) return;
			
			m_gameWidth = w;
			m_gameHeight = h;
			
			var temp:BitmapData = m_buffer;
			
			buildBuffer();
			
			if(temp)
			{
				m_buffer.lock();
				m_buffer.copyPixels(temp, temp.rect, Constant.ZeroPoint);
				m_buffer.unlock();
			}
			
			m_worldMap.setCameraWH(w, h);
			
			temp.dispose();
		}
		
		public function get buffer():BitmapData
		{
			return m_buffer;
		}
		
		public function get worldMap():WorldMap
		{
			return m_worldMap;
		}
		
		public function dispose():void
		{
		}
	}
}