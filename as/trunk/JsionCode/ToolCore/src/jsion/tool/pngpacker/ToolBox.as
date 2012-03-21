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
		private var m_delActionBtn:JButton;
		
		public function ToolBox(frame:PNGPackerFrame)
		{
			m_frame = frame;
			
			super(new FlowLayout(FlowLayout.LEFT, 3, 3));
			
			m_newActionBtn = new JButton("添加", new LoadIcon("assets/NewPackage.png"));
			m_newActionBtn.addActionListener(onNewAction);
			m_newActionBtn.setToolTipText("添加一个动作的方向");
			append(m_newActionBtn);
			
			m_delActionBtn = new JButton("删除", new LoadIcon("assets/NewPackage.png"));
			m_delActionBtn.addActionListener(onDelAction);
			m_delActionBtn.setToolTipText("删除一个动作的方向");
			m_delActionBtn.setEnabled(false);
			append(m_delActionBtn);
		}
		
		private function onNewAction(e:AWEvent):void
		{
			var frame:AddActionFrame = new AddActionFrame(m_frame);
			
			frame.show();
		}
		
		private function onDelAction(e:AWEvent):void
		{
			m_frame.delSelected();
		}
		
		public function setDelBtnEnabled(b:Boolean):void
		{
			m_delActionBtn.setEnabled(b);
		}
	}
}