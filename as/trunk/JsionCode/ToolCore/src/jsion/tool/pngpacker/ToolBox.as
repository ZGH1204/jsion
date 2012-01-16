package jsion.tool.pngpacker
{
	import jsion.tool.pngpacker.frames.AddActionFrame;
	
	import org.aswing.FlowLayout;
	import org.aswing.JButton;
	import org.aswing.JPanel;
	import org.aswing.LayoutManager;
	import org.aswing.LoadIcon;
	import org.aswing.SoftBoxLayout;
	import org.aswing.event.AWEvent;
	
	public class ToolBox extends JPanel
	{
		private var m_frame:PNGPackerFrame;
		
		private var m_newActionBtn:JButton;
		
		public function ToolBox(frame:PNGPackerFrame)
		{
			m_frame = frame;
			
			super(new FlowLayout(FlowLayout.LEFT, 3, 3));
			
			m_newActionBtn = new JButton("新建动作", new LoadIcon("assets/NewPackage.png"));
			m_newActionBtn.addActionListener(onNewAction);
			append(m_newActionBtn);
		}
		
		private function onNewAction(e:AWEvent):void
		{
			var frame:AddActionFrame = new AddActionFrame(m_frame);
			
			frame.show();
		}
	}
}