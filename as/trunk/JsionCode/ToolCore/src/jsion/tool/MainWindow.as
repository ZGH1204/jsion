package jsion.tool
{
	import org.aswing.BorderLayout;
	import org.aswing.Container;
	import org.aswing.JPanel;
	import org.aswing.JWindow;
	import org.aswing.SoftBoxLayout;

	public class MainWindow extends JWindow
	{
		protected var m_content:Container;
		
		protected var m_topPanel:JPanel;
		
		protected var m_bottomPanel:JPanel;
		
		protected var m_leftPanel:JPanel;
		
		protected var m_rightPanel:JPanel;
		
		protected var m_mainPanel:JPanel;
		
		
		public function MainWindow(owner:* = null, modal:Boolean = false)
		{
			super(owner, modal);
			
			init();
			
			initTop();
			initBottom();
			initLeft();
			initRight();
			initMain();
		}
		
		protected function init():void
		{
			setMinimumWidth(800);
			setMinimumHeight(600);
			
			
			
			m_content = getContentPane();
			m_content.setLayout(new BorderLayout(1, 1));
			
			
			
			m_topPanel = new JPanel(new SoftBoxLayout(SoftBoxLayout.Y_AXIS));
			m_bottomPanel = new JPanel(new SoftBoxLayout(SoftBoxLayout.Y_AXIS));
			m_leftPanel = new JPanel(new SoftBoxLayout(SoftBoxLayout.Y_AXIS));
			m_rightPanel = new JPanel(new SoftBoxLayout(SoftBoxLayout.Y_AXIS));
			m_mainPanel = new JPanel();
			
			m_topPanel.setOpaque(true);
			m_bottomPanel.setOpaque(true);
			m_leftPanel.setOpaque(true);
			m_rightPanel.setOpaque(true);
			m_mainPanel.setOpaque(true);
			
			
			m_bottomPanel.setPreferredHeight(28);
			m_leftPanel.setPreferredWidth(200);
			m_rightPanel.setPreferredWidth(200);
			
			
			
			m_content.append(m_topPanel, BorderLayout.NORTH);
			m_content.append(m_bottomPanel, BorderLayout.SOUTH);
			m_content.append(m_leftPanel, BorderLayout.WEST);
			m_content.append(m_rightPanel, BorderLayout.EAST);
			m_content.append(m_mainPanel, BorderLayout.CENTER);
		}
		
		protected function initTop():void
		{
		}
		
		protected function initBottom():void
		{
		}
		
		protected function initLeft():void
		{
		}
		
		protected function initRight():void
		{
		}
		
		protected function initMain():void
		{
		}
	}
}