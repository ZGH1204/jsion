package editor.showers
{
	import editor.SmallMap;
	
	import flash.geom.Point;
	
	import jsion.rpg.engine.RPGEngine;
	
	public class MapShower extends RPGEngine
	{
		protected var m_editorContainer:EditorAssistant;
		
		protected var m_smallMapShower:SmallMap;
		
		public function MapShower(w:int, h:int, configPath:String)
		{
			super(w, h, configPath);
		}
		
		override protected function initialize():void
		{
			m_editorContainer = new EditorAssistant(this);
			addChild(m_editorContainer);
		}
		
		public function setSmallMapShower(shower:SmallMap):void
		{
			m_smallMapShower = shower;
		}
		
		override public function setCameraWH(w:int, h:int):void
		{
			super.setCameraWH(w, h);
			
			if(m_editorContainer) m_editorContainer.updateRect();
		}
		
		override protected function onEnterFrameHandler():void
		{
			if(m_game && m_game.worldMap.needRepaintMap)
			{
				if(m_smallMapShower)
				{
					var temp:Point = m_game.worldMap.center;
					m_smallMapShower.updateDisplayRect(temp.x, temp.y);
				}
				
				m_editorContainer.updateTileGrid();
				m_editorContainer.updateWayTileGrid();
			}
			
			super.onEnterFrameHandler();
		}
		
		public function get assistant():EditorAssistant
		{
			return m_editorContainer;
		}
	}
}