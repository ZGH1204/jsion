package jsion.tool.mapeditor.panes
{
	import jsion.tool.mapeditor.MapDragger;
	import jsion.tool.mapeditor.MapFrame;
	import jsion.tool.mapeditor.MapShower;
	import jsion.tool.mapeditor.datas.MapData;
	import jsion.utils.DisposeUtil;
	
	import org.aswing.JPanel;
	import org.aswing.event.ResizedEvent;
	
	public class MainPane extends JPanel
	{
		private var m_frame:MapFrame;
		
		private var m_mapDragger:MapDragger;
		
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
			trace("size:", width, height);
			
			if(width == 0 || height == 0) return;
			
			if(m_mapShower) m_mapShower.setCameraSize(width, height);
			
			if(m_mapDragger) m_mapDragger.drawRect(width, height);
		}
		
		public function setMap(mapInfo:MapData):void
		{
			DisposeUtil.free(m_mapShower);
			DisposeUtil.free(m_mapDragger);
			
			m_mapShower = new MapShower(1, 1);
			
			m_mapShower.setMapRoot(mapInfo.mapRoot);
			
			m_mapShower.setMapID(mapInfo.mapID);
			
			m_mapShower.start();
			
			addChild(m_mapShower);
			
			
			m_mapDragger = new MapDragger(m_mapShower);
			
			addChild(m_mapDragger);
		}
	}
}