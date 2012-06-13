package jsion.tool.mapeditor.panes
{
	import jsion.tool.mapeditor.MapFrame;
	
	import org.aswing.FlowLayout;
	import org.aswing.JButton;
	import org.aswing.JPanel;
	import org.aswing.LayoutManager;
	import org.aswing.SoftBoxLayout;
	import org.aswing.event.AWEvent;
	
	public class TopPane extends JPanel
	{
		private var m_frame:MapFrame;
		
		private var m_pane:JPanel;
		
		private var m_importBtn:JButton;
		
		public function TopPane(frame:MapFrame)
		{
			m_frame = frame;
			
			super(new SoftBoxLayout(SoftBoxLayout.X_AXIS));
			
			m_pane = new JPanel(new FlowLayout(FlowLayout.LEFT, 3, 3));
			
			
			m_importBtn = new JButton("导入建筑");
			m_importBtn.addActionListener(onImportHandler);
			m_pane.append(m_importBtn);
			
			
			append(m_pane);
			
			setPreferredHeight(30);
		}
		
		private function onImportHandler(e:AWEvent):void
		{
			
		}
	}
}