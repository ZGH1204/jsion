package jsion.tool.mapeditor
{
	import jsion.tool.BaseFrame;
	import jsion.tool.ToolGlobal;
	import jsion.tool.mapeditor.panes.TopPane;
	
	import org.aswing.BorderLayout;
	
	public class MapFrame extends BaseFrame
	{
		private var m_topPane:TopPane;
		
		public function MapFrame(modal:Boolean=false)
		{
			m_title = "地图编辑器";
			
			super(ToolGlobal.window, modal);
			
			m_content.setLayout(new BorderLayout(1,1));
			
			setSizeWH(600, 400);
			
			setMinimumWidth(600);
			setMinimumHeight(400);
			
			
			
			
			m_topPane = new TopPane(this);
			m_content.append(m_topPane, BorderLayout.NORTH);
		}
	}
}