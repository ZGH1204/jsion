package jsion.tool.pngpacker
{
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
		
		private var m_newPackageBtn:JButton;
		
		public function ToolBox(frame:PNGPackerFrame)
		{
			m_frame = frame;
			
			super(new FlowLayout(FlowLayout.LEFT, 3, 3));
			
			m_newPackageBtn = new JButton(null, new LoadIcon("assets/NewPackage.png"));
			m_newPackageBtn.addActionListener(onNewPackage);
			m_newPackageBtn.setToolTipText("新建资源包");
			append(m_newPackageBtn);
		}
		
		private function onNewPackage(e:AWEvent):void
		{
			
		}
	}
}