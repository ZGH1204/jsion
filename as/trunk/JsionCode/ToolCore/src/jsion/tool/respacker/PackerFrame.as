package jsion.tool.respacker
{
	import jsion.tool.BaseFrame;
	import jsion.tool.respacker.areas.BottomPane;
	import jsion.tool.respacker.areas.LeftPane;
	import jsion.tool.respacker.areas.MainPane;
	import jsion.tool.respacker.areas.RenderPane;
	import jsion.tool.respacker.areas.TopPane;
	
	import org.aswing.BorderLayout;
	
	public class PackerFrame extends BaseFrame
	{
		protected var m_topPanel:TopPane;
		protected var m_leftPanel:LeftPane;
		protected var m_mainPanel:MainPane;
		protected var m_renderPanel:RenderPane;
		protected var m_bottomPanel:BottomPane;
		
		protected var m_controller:PackerController;
		
		public function PackerFrame(owner:*=null, modal:Boolean=false)
		{
			m_title = "资源打包器";
			
			super(owner, modal);
			
			m_content.setLayout(new BorderLayout(1,1));
			
			setMinimumWidth(700);
			setMinimumHeight(450);
			setSizeWH(700, 450);
			
			m_topPanel = new TopPane();
			m_leftPanel = new LeftPane();
			m_bottomPanel = new BottomPane();
			m_renderPanel = new RenderPane();
			m_mainPanel = new MainPane(m_renderPanel, m_bottomPanel);
			
			m_content.append(m_topPanel, BorderLayout.NORTH);
			m_content.append(m_leftPanel, BorderLayout.WEST);
			m_content.append(m_mainPanel, BorderLayout.CENTER);
			
			m_controller = new PackerController(this);
		}
		
		public function get topPane():TopPane
		{
			return m_topPanel;
		}
		
		public function get leftPane():LeftPane
		{
			return m_leftPanel;
		}

		public function get renderPane():RenderPane
		{
			return m_renderPanel;
		}

		public function get bottomPane():BottomPane
		{
			return m_bottomPanel;
		}
	}
}