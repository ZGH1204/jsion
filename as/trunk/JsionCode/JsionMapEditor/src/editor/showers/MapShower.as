package editor.showers
{
	import editor.events.LibTabEvent;
	import editor.forms.renders.RenderInfo;
	import editor.leftviews.SmallMap;
	import editor.rightviews.CoordViewer;
	import editor.rightviews.ResourceTabbed;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import jsion.rpg.engine.EngineGlobal;
	import jsion.rpg.engine.RPGEngine;
	import jsion.rpg.engine.gameobjects.BuildingObject;
	import jsion.rpg.engine.gameobjects.GameObject;
	import jsion.rpg.engine.gameobjects.NCharactarObject;
	import jsion.utils.ArrayUtil;
	import jsion.utils.DisposeUtil;
	import jsion.utils.PathUtil;
	
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
			
			addEventListener(MouseEvent.MOUSE_DOWN, __mouseDownHandler);
			addEventListener(MouseEvent.MOUSE_MOVE, __mouseMoveHandler);
			addEventListener(MouseEvent.MOUSE_UP, __mouseUpHandler);
			stage.addEventListener(MouseEvent.CONTEXT_MENU, __contextMenuHandler);
			
			super.initialize();
		}
		
		private function __contextMenuHandler(e:MouseEvent):void
		{
			cancelObject();
		}
		
		private var clickRect:Rectangle = new Rectangle(0, 0, 6, 6);
		
		private function __mouseDownHandler(e:MouseEvent):void
		{
			clickRect.x = e.localX - clickRect.width / 2;
			clickRect.y = e.localY - clickRect.height / 2;
		}
		
		private function __mouseUpHandler(e:MouseEvent):void
		{
			if(clickRect.contains(e.localX, e.localY))
			{
				submitObject();
			}
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
			
			if(m_dragingObject)
			{
				var tmp:Point = game.worldMap.screenToWorld(e.localX, e.localY);
				
				m_dragingObject.setPos(tmp.x, tmp.y);
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
			if(m_resourceTabbed)
			{
				if(m_resourceTabbed.npcsTab) m_resourceTabbed.npcsTab.removeEventListener(LibTabEvent.DOUBLE_CLICK, __npcItemDoubleClickHandler);
			
				if(m_resourceTabbed.buildingsTab) m_resourceTabbed.buildingsTab.removeEventListener(LibTabEvent.DOUBLE_CLICK, __buildingItemDoubleClickHandler);
			}
			
			m_resourceTabbed = bed;
			
			if(m_resourceTabbed)
			{
				if(m_resourceTabbed.npcsTab) m_resourceTabbed.npcsTab.addEventListener(LibTabEvent.DOUBLE_CLICK, __npcItemDoubleClickHandler);
				
				if(m_resourceTabbed.buildingsTab) m_resourceTabbed.buildingsTab.addEventListener(LibTabEvent.DOUBLE_CLICK, __buildingItemDoubleClickHandler);
			}
		}
		
		private var m_dragingObject:GameObject;
		private var m_dragingList:Array;
		
		private function __npcItemDoubleClickHandler(e:LibTabEvent):void
		{
			m_dragingList = JsionEditor.npcObjects;
			
			cancelObject();
			
			m_dragingObject = createNPC(e.filename, game.worldMap.center.clone());
			
			startObject(m_dragingObject);
		}
		
		private function __buildingItemDoubleClickHandler(e:LibTabEvent):void
		{
			m_dragingList = JsionEditor.buildingObjects;
			
			cancelObject();
			
			m_dragingObject = createBuilding(e.filename, game.worldMap.center.clone());
			
			startObject(m_dragingObject);
		}
		
		
		public function createNPC(filename:String, pos:Point):NCharactarObject
		{
			var renderInfo:RenderInfo;
			
			if(JsionEditor.npcRenderInfo.containsKey(filename))
			{
				renderInfo = JsionEditor.npcRenderInfo.get(filename) as RenderInfo;
			}
			else
			{
				renderInfo = new RenderInfo();
				renderInfo.path = PathUtil.combinPath(JsionEditor.MAP_NPCS_DIR, filename);
				renderInfo.filename = filename;
			}
			
			return game.createNPC(renderInfo, pos);
		}
		
		public function createBuilding(filename:String, pos:Point):BuildingObject
		{
			var renderInfo:RenderInfo;
			
			if(JsionEditor.buildingRenderInfo.containsKey(filename))
			{
				renderInfo = JsionEditor.buildingRenderInfo.get(filename) as RenderInfo;
			}
			else
			{
				renderInfo = new RenderInfo();
				renderInfo.path = PathUtil.combinPath(JsionEditor.MAP_BUILDINGS_DIR, filename);
				renderInfo.filename = filename;
			}
			
			return game.createBuilding(renderInfo, pos);
		}

		private function startObject(object:GameObject):void
		{
			game.addObject(object);
			m_dragingList.push(object);
		}
		
		private function cancelObject():void
		{
			if(m_dragingObject)
			{
				ArrayUtil.remove(m_dragingList, m_dragingObject);
				m_dragingObject.clearMe();
				game.removeObject(m_dragingObject);
				DisposeUtil.free(m_dragingObject);
				m_dragingObject = null;
			}
		}
		
		private function submitObject():void
		{
			m_dragingObject = null;
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