package jsion.tool.mapeditor.panes
{
	import jsion.tool.mapeditor.MapFrame;
	
	import org.aswing.JPanel;
	import org.aswing.LayoutManager;
	
	public class RightPane extends JPanel
	{
		private var m_frame:MapFrame;
		
		public function RightPane(frame:MapFrame)
		{
			m_frame = frame;
			
			super();
			
			setPreferredWidth(1);
		}
	}
}