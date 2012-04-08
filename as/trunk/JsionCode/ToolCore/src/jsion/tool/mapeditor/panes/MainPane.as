package jsion.tool.mapeditor.panes
{
	import jsion.tool.mapeditor.MapFrame;
	
	import org.aswing.ASColor;
	import org.aswing.JPanel;
	import org.aswing.LayoutManager;
	import org.aswing.event.ResizedEvent;
	
	public class MainPane extends JPanel
	{
		private var m_frame:MapFrame;
		
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
		}
	}
}