package jsion.tool.mapeditor
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import jsion.rpg.engine.RPGEngine;
	import jsion.tool.mapeditor.panes.materials.CoordViewer;
	import jsion.tool.mapeditor.panes.materials.MaterialsTabbed;
	import jsion.utils.DisposeUtil;
	
	public class MapShower extends RPGEngine
	{
		private var m_frame:MapFrame;
		
		public var mapDragger:MapDragger;
		
		public var coordView:CoordViewer;
		
		public var materials:MaterialsTabbed;
		
		public function MapShower(frame:MapFrame)
		{
			m_frame = frame;
			
			mapDragger = new MapDragger(this);
			coordView = new CoordViewer();
			materials = new MaterialsTabbed(m_frame);
			
			super(1, 1);
		}
		
		override public function setMapID(id:int):void
		{
			//更新 mapRoot 属性
			super.setMapID(id);
			
			materials.setMapRoot(mapRoot);
		}
		
		override public function setCameraSize(w:int, h:int):void
		{
			super.setCameraSize(w, h);
			
			if(mapDragger) mapDragger.drawRect(w, h);
			
			if(materials) materials.height = h - 100;
		}
		
		override public function start():void
		{
			mapDragger.addEventListener(MouseEvent.MOUSE_MOVE, __mouseMoveHandler);
			
			super.start();
		}
		
		private function __mouseMoveHandler(e:MouseEvent):void
		{
			// TODO Auto-generated method stub
			if(coordView && game.worldMap)
			{
				var temp:Point;
				
				temp = game.worldMap.screen2World(e.localX, e.localY);
				coordView.setWorldPos(temp.x, temp.y);
				
				temp = game.worldMap.screen2Tile(e.localX, e.localY);
				coordView.setTilePos(temp.x, temp.y);
				
				coordView.setScreenPos(e.localX, e.localY);
			}
		}
		
		override public function dispose():void
		{
			if(mapDragger) mapDragger.removeEventListener(MouseEvent.MOUSE_MOVE, __mouseMoveHandler);
			
			DisposeUtil.free(mapDragger);
			mapDragger = null;
			
			coordView = null;
			
			materials = null;
			
			super.dispose();
		}
	}
}