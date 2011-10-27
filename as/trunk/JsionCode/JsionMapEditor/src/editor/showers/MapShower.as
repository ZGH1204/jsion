package editor.showers
{
	import editor.leftviews.SmallMap;
	import editor.rightviews.CoordViewer;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import jsion.rpg.engine.EngineGlobal;
	import jsion.rpg.engine.RPGEngine;
	
	public class MapShower extends RPGEngine
	{
		protected var m_editorContainer:EditorAssistant;
		
		protected var m_smallMapShower:SmallMap;
		
		protected var m_coordView:CoordViewer;
		
		public function MapShower(w:int, h:int, configPath:String, mapsRoot:String)
		{
			EngineGlobal.MapsList.put("editor", configPath);
			super(w, h, "editor", mapsRoot);
		}
		
		override protected function initialize():void
		{
			m_editorContainer = new EditorAssistant(this);
			addChild(m_editorContainer);
			
			addEventListener(MouseEvent.MOUSE_MOVE, __mouseMoveHandler);
			
			super.initialize();
		}
		
		private function __mouseMoveHandler(e:MouseEvent):void
		{
			if(m_coordView)
			{
				var p:Point = game.worldMap.screenToWorld(e.localX, e.localY);
				m_coordView.setWorldPos(p.x, p.y);
				
				p = game.worldMap.screenToTile(e.localX, e.localY);
				m_coordView.setTilePos(p.x, p.y);
				
				m_coordView.setScreenPos(e.localX, e.localY);
			}
		}
		
		public function setSmallMapShower(shower:SmallMap):void
		{
			m_smallMapShower = shower;
		}
		
		public function setCoordView(view:CoordViewer):void
		{
			m_coordView = view;
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