package jsion.tool.mapeditor.panes
{
	import jsion.tool.mapeditor.MapFrame;
	
	import org.aswing.ASColor;
	import org.aswing.JPanel;
	import org.aswing.SoftBoxLayout;
	
	public class LeftPane extends JPanel
	{
		private var m_frame:MapFrame;
		
		public function LeftPane(frame:MapFrame)
		{
			m_frame = frame;
			
			super(new SoftBoxLayout(SoftBoxLayout.Y_AXIS));
			
			setPreferredWidth(1);
//			setBackground(new ASColor(0x336699));
//			setOpaque(true);
		}
	}
}