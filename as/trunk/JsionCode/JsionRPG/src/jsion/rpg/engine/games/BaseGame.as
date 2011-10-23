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
		
		public function BaseGame(w:int, h:int, mapConfig:MapConfig)
		{
			m_gameWidth = w;
			m_gameHeight = h;
			m_mapConfig = mapConfig;
			
			initialize();
		}
		
		protected function initialize():void
		{
			RPGEngine.CameraWidth = m_gameWidth;
			RPGEngine.CameraHeight = m_gameHeight;
			
			m_objects = [];
			
			m_renders = [];
			
			m_buffer = new BitmapData(m_gameWidth, m_gameHeight, true, 0);
			
			m_worldMap = new WorldMap(m_mapConfig, m_gameWidth, m_gameHeight);
			m_worldMap.tileCallback = tileCompleteCallback;
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
		}
		
		public function render():void
		{
			if(m_worldMap.needRepaintMap)
			{
				//TODO:清除新完成的Tile加载检测列表
				m_worldMap.render(m_buffer);
			}
			else
			{
				//TODO:检测是否有新完成的Tile加载需要更新视图
			}
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