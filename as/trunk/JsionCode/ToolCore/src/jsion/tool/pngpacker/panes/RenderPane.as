package jsion.tool.pngpacker.panes
{
	import jsion.tool.pngpacker.PNGPackerFrame;
	
	import org.aswing.FlowLayout;
	import org.aswing.JPanel;
	import org.aswing.LayoutManager;
	import org.aswing.border.TitledBorder;
	
	public class RenderPane extends JPanel
	{
		private var m_frame:PNGPackerFrame;
		
		public function RenderPane(frame:PNGPackerFrame)
		{
			m_frame = frame;
			
			super(new FlowLayout(FlowLayout.CENTER));
			
			setBorder(new TitledBorder(null, "预览", TitledBorder.TOP, TitledBorder.LEFT, 10));
		}
	}
}