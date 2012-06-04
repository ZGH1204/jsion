package jsion.tool.mapeditor.panes
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import jsion.tool.mapeditor.MapDragger;
	import jsion.tool.mapeditor.MapFrame;
	import jsion.tool.mapeditor.MapShower;
	import jsion.tool.mapeditor.datas.MapData;
	import jsion.tool.mapeditor.panes.materials.CoordViewer;
	import jsion.tool.mapeditor.panes.materials.MaterialsTabbed;
	import jsion.utils.DisposeUtil;
	
	import org.aswing.JPanel;
	import org.aswing.event.ResizedEvent;
	
	public class MainPane extends JPanel
	{
		private var m_frame:MapFrame;
		
		private var m_mapDragger:MapDragger;
		
		private var m_mapShower:MapShower;
		
		private var m_coordViewer:CoordViewer;
		
		private var m_materialsTabbed:MaterialsTabbed;
		
		public function MainPane(frame:MapFrame)
		{
			m_frame = frame;
			
			super();
			
//			setBackground(new ASColor(0x336699));
//			setOpaque(true);
			
			addEventListener(ResizedEvent.RESIZED, __resizeHandler, false, 0, true);
		}
		
		private function __resizeHandler(e:ResizedEvent):void
		{
			trace("size:", width, height);
			
			if(width == 0 || height == 0) return;
			
			if(m_mapShower) m_mapShower.setCameraSize(width, height);
			
			if(m_mapDragger) m_mapDragger.drawRect(width, height);
			
			if(m_materialsTabbed) m_materialsTabbed.height = height - 100;
		}
		
		public function setMap(mapInfo:MapData):void
		{
			if(m_mapDragger) m_mapDragger.removeEventListener(MouseEvent.MOUSE_MOVE, __mouseMoveHandler);
			
			DisposeUtil.free(m_mapShower);
			DisposeUtil.free(m_materialsTabbed);
			DisposeUtil.free(m_mapDragger);
			
			m_mapShower = new MapShower(1, 1);
			
			m_mapShower.setMapRoot(mapInfo.mapRoot);
			
			m_mapShower.setMapID(mapInfo.mapID);
			
			m_mapShower.start();
			
			addChild(m_mapShower);
			
			
			m_mapDragger = new MapDragger(m_mapShower);
			
			m_mapDragger.addEventListener(MouseEvent.MOUSE_MOVE, __mouseMoveHandler);
			
			addChild(m_mapDragger);
			
			
			m_coordViewer = new CoordViewer();
			
			m_materialsTabbed = new MaterialsTabbed(m_frame);
		}
		
		private function __mouseMoveHandler(e:MouseEvent):void
		{
			if(m_coordViewer && m_mapShower.game.worldMap)
			{
				var temp:Point;
				
				temp = m_mapShower.game.worldMap.screen2World(e.localX, e.localY);
				m_coordViewer.setWorldPos(temp.x, temp.y);
				
				temp = m_mapShower.game.worldMap.screen2Tile(e.localX, e.localY);
				m_coordViewer.setTilePos(temp.x, temp.y);
				
				m_coordViewer.setScreenPos(e.localX, e.localY);
			}
		}

		public function get mapDragger():MapDragger
		{
			return m_mapDragger;
		}

		public function get coordViewer():CoordViewer
		{
			return m_coordViewer;
		}

		public function get materialsTabbed():MaterialsTabbed
		{
			return m_materialsTabbed;
		}


	}
}