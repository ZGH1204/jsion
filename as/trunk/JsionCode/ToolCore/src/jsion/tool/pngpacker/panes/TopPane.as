package jsion.tool.pngpacker.panes
{
	import jsion.tool.pngpacker.PNGPackerFrame;
	import jsion.tool.pngpacker.ToolBox;
	
	import org.aswing.JPanel;
	import org.aswing.LayoutManager;
	import org.aswing.SoftBoxLayout;
	
	public class TopPane extends JPanel
	{
		private var m_frame:PNGPackerFrame;
		
		private var m_toolBox:ToolBox;
		
		public function TopPane(frame:PNGPackerFrame)
		{
			m_frame = frame;
			
			super(new SoftBoxLayout(SoftBoxLayout.Y_AXIS));
			
			setPreferredHeight(30);
			
			m_toolBox = new ToolBox(m_frame);
			append(m_toolBox);
		}
		
		public function setDelBtnEnabled(b:Boolean):void
		{
			m_toolBox.setDelBtnEnabled(b);
		}
	}
}