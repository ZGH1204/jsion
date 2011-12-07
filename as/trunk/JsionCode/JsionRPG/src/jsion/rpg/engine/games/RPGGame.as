package jsion.rpg.engine.games
{
	import flash.display.BitmapData;
	
	import jsion.HashMap;
	import jsion.rpg.engine.datas.MapConfig;
	import jsion.rpg.engine.renders.RenderCharactar;
	import jsion.rpg.engine.renders.RenderStatic;

	public class RPGGame extends BaseGame
	{
		protected var m_tileCompleteList:HashMap;
		
		public function RPGGame(w:int, h:int, mapConfig:MapConfig, mapsRoot:String, smallMapBmd:BitmapData)
		{
			super(w, h, mapConfig, mapsRoot, smallMapBmd);
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			m_tileCompleteList = new HashMap();
			
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
			//m_worldMap.needRepaintMap = true;
			
			m_tileCompleteList.put(tileY + "_" + tileX, bmd);
		}
		
		override public function render():void
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
				
				for each(var key:String in keys)
				{
					var pos:Array = key.split("_");
					var x:int = pos[1];
					var y:int = pos[0];
					
					m_worldMap.drawTile(m_buffer, m_tileCompleteList.get(key) as BitmapData, x, y);
				}
				
				m_tileCompleteList.removeAll();
			}
			
			super.render();
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
	}
}