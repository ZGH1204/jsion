package jsion.tool.mapeditor.panes
{
	import jsion.tool.mapeditor.MapFrame;
	
	import org.aswing.JPanel;
	import org.aswing.LayoutManager;
	
	public class BottomPane extends JPanel
	{
		private var m_frame:MapFrame;
		
		public function BottomPane(frame:MapFrame)
		{
			m_frame = frame;
			
			super();
			
			setPreferredHeight(1);
		}
	}
}