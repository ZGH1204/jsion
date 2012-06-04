package jsion.tool.mapeditor
{
	import jsion.tool.BaseFrame;
	import jsion.tool.ToolGlobal;
	import jsion.tool.mapeditor.datas.MapData;
	import jsion.tool.mapeditor.panes.BottomPane;
	import jsion.tool.mapeditor.panes.LeftPane;
	import jsion.tool.mapeditor.panes.MainPane;
	import jsion.tool.mapeditor.panes.RightPane;
	import jsion.tool.mapeditor.panes.TopPane;
	import jsion.tool.mapeditor.panes.materials.CoordViewer;
	
	import org.aswing.BorderLayout;
	
	public class MapFrame extends BaseFrame
	{
		private var m_topPane:TopPane;
		private var m_leftPane:LeftPane;
		private var m_mainPane:MainPane;
		private var m_rightPane:RightPane;
		private var m_bottomPane:BottomPane;
		
		public function MapFrame(modal:Boolean=false)
		{
			m_title = "地图编辑器";
			
			super(ToolGlobal.window, modal);
			
			m_content.setLayout(new BorderLayout(1,1));
			
			setSizeWH(860, 500);
			
			setMinimumWidth(800);
			setMinimumHeight(500);
			
			
			
			
			m_topPane = new TopPane(this);
			m_content.append(m_topPane, BorderLayout.NORTH);
			
			m_leftPane = new LeftPane(this);
			m_content.append(m_leftPane, BorderLayout.WEST);
			
			m_mainPane = new MainPane(this);
			m_content.append(m_mainPane, BorderLayout.CENTER);
			
			m_rightPane = new RightPane(this);
			m_content.append(m_rightPane, BorderLayout.EAST);
			
			m_bottomPane = new BottomPane(this);
			m_content.append(m_bottomPane, BorderLayout.SOUTH);
		}
		
		public function setMap(mapInfo:MapData):void
		{
			m_mainPane.setMap(mapInfo);
			
			m_rightPane.append(m_mainPane.materialsTabbed);
			
			m_rightPane.append(m_mainPane.coordViewer);
		}
	}
}