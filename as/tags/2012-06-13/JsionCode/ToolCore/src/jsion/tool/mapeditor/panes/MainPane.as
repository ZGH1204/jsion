package jsion.tool.mapeditor.panes
{
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
		
		private var m_mapShower:MapShower;
		
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
			if(width == 0 || height == 0) return;
			
			trace("size:", width, height);
			
			if(m_mapShower) m_mapShower.setCameraSize(width, height);
		}
		
		public function setMap(mapInfo:MapData):void
		{
			DisposeUtil.free(m_mapShower);
			
			m_mapShower = new MapShower(m_frame);
			
			m_mapShower.setRoot(mapInfo.mapRoot);
			m_mapShower.setMapID(mapInfo.mapID);
			
			addChild(m_mapShower);
			
			addChild(m_mapShower.mapDragger);
			
			m_mapShower.start();
		}
		
		public function get mapShower():MapShower
		{
			return m_mapShower;
		}

		public function get coordView():CoordViewer
		{
			return m_mapShower.coordView;
		}

		public function get materialsTabbed():MaterialsTabbed
		{
			return m_mapShower.materials;
		}
		
		public function dispose():void
		{
			DisposeUtil.free(m_mapShower);
			m_mapShower = null;
			
			m_frame = null;
		}
	}
}