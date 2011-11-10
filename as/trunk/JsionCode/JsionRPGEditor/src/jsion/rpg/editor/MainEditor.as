package jsion.rpg.editor
{
	import jsion.rpg.editor.tops.MenuBox;
	import jsion.rpg.editor.tops.ToolBox;
	
	import org.aswing.BorderLayout;
	import org.aswing.Container;
	import org.aswing.JPanel;
	import org.aswing.JWindow;
	import org.aswing.SoftBoxLayout;
	
	public class MainEditor extends JWindow
	{
		protected var m_content:Container;
		
		protected var m_topPanel:JPanel;
		
		protected var m_bottomPanel:JPanel;
		
		protected var m_leftPanel:JPanel;
		
		protected var m_rightPanel:JPanel;
		
		protected var m_mainPanel:JPanel;
		
		public function MainEditor(owner:*=null, modal:Boolean=false)
		{
			super(owner, modal);
			
			initialize();
			
			configTopUI();
			configBottomUI();
			configLeftUI();
			configRightUI();
			configMainUI();
		}
		
		private function initialize():void
		{
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
			
			
			m_bottomPanel.setPreferredHeight(1);
			m_leftPanel.setPreferredWidth(200);
			m_rightPanel.setPreferredWidth(1);
			
			
			
			m_content.append(m_topPanel, BorderLayout.NORTH);
			m_content.append(m_bottomPanel, BorderLayout.SOUTH);
			m_content.append(m_leftPanel, BorderLayout.WEST);
			m_content.append(m_rightPanel, BorderLayout.EAST);
			m_content.append(m_mainPanel, BorderLayout.CENTER);
		}
		
		private function configTopUI():void
		{
			m_topPanel.append(new MenuBox());
			m_topPanel.append(new ToolBox());
		}
		
		private function configBottomUI():void
		{
		}
		
		private function configLeftUI():void
		{
		}
		
		private function configRightUI():void
		{
		}
		
		private function configMainUI():void
		{
		}
	}
}