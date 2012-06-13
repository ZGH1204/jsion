package jsion.tool.mapeditor.panes
{
	import jsion.tool.mapeditor.MapFrame;
	import jsion.tool.mapeditor.panes.materials.CoordViewer;
	
	import org.aswing.JPanel;
	import org.aswing.LayoutManager;
	import org.aswing.SoftBoxLayout;
	
	public class RightPane extends JPanel
	{
		private var m_frame:MapFrame;
		
		public function RightPane(frame:MapFrame)
		{
			m_frame = frame;
			
			super(new SoftBoxLayout(SoftBoxLayout.Y_AXIS));
			
			setPreferredWidth(200);
		}
	}
}