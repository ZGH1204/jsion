package editor.showers
{
	import editor.events.LibTabEvent;
	import editor.leftviews.SmallMap;
	import editor.rightviews.CoordViewer;
	import editor.rightviews.ResourceTabbed;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import jsion.rpg.engine.EngineGlobal;
	import jsion.rpg.engine.RPGEngine;
	
	public class MapShower extends RPGEngine
	{
		protected var m_editorContainer:EditorAssistant;
		
		protected var m_smallMapShower:SmallMap;
		
		protected var m_coordView:CoordViewer;
		
		protected var m_resourceTabbed:ResourceTabbed;
		
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
		
		public function setResourceTabbed(bed:ResourceTabbed):void
		{
//			if(m_resourceTabbed)
//			{
//				if(m_resourceTabbed.npcsTab) m_resourceTabbed.npcsTab.removeEventListener(LibTabEvent.DOUBLE_CLICK, __itemDoubleClickHandler);
//			
//				if(m_resourceTabbed.buildingsTab) m_resourceTabbed.buildingsTab.removeEventListener(LibTabEvent.DOUBLE_CLICK, __buildingItemDoubleClickHandler);
//			}
			
			m_resourceTabbed = bed;
			
			if(m_resourceTabbed)
			{
				if(m_resourceTabbed.npcsTab) m_resourceTabbed.npcsTab.addEventListener(LibTabEvent.DOUBLE_CLICK, __npcItemDoubleClickHandler);
				
				if(m_resourceTabbed.buildingsTab) m_resourceTabbed.buildingsTab.addEventListener(LibTabEvent.DOUBLE_CLICK, __buildingItemDoubleClickHandler);
			}
		}
		
		private function __npcItemDoubleClickHandler(e:LibTabEvent):void
		{
			
		}
		
		private function __buildingItemDoubleClickHandler(e:LibTabEvent):void
		{
			
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