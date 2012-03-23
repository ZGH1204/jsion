package jsion.tool.pngpacker
{
	import flash.filesystem.File;
	
	import jsion.tool.BaseFrame;
	import jsion.tool.ToolGlobal;
	import jsion.tool.pngpacker.data.DirectionInfo;
	import jsion.tool.pngpacker.data.PackerModel;
	import jsion.tool.pngpacker.panes.BottomPane;
	import jsion.tool.pngpacker.panes.LeftPane;
	import jsion.tool.pngpacker.panes.MainPane;
	import jsion.tool.pngpacker.panes.RenderPane;
	import jsion.tool.pngpacker.panes.TopPane;
	import jsion.utils.DisposeUtil;
	
	import org.aswing.BorderLayout;
	import org.aswing.tree.TreePath;
	
	public class PackerFrame extends BaseFrame
	{
		protected var m_topPanel:TopPane;
		protected var m_leftPanel:LeftPane;
		protected var m_mainPanel:MainPane;
		protected var m_renderPanel:RenderPane;
		protected var m_bottomPanel:BottomPane;
		
		private var m_packerData:PackerModel;
		
		public function PackerFrame()
		{
			m_title = "资源打包";
			
			m_packerData = new PackerModel();
			
			super(ToolGlobal.window);
			
			m_content.setLayout(new BorderLayout(1,1));
			
			setMinimumWidth(700);
			setMinimumHeight(450);
			setSizeWH(700, 450);
			
			configUI();
		}
		
		public function get packerData():PackerModel
		{
			return m_packerData;
		}
		
		private function configUI(): void
		{
			m_topPanel = new TopPane(this);
			m_leftPanel = new LeftPane(this);
			m_bottomPanel = new BottomPane(this);
			m_renderPanel = new RenderPane(this);
			m_mainPanel = new MainPane(m_renderPanel, m_bottomPanel);
			
			m_content.append(m_topPanel, BorderLayout.NORTH);
			m_content.append(m_leftPanel, BorderLayout.WEST);
			m_content.append(m_mainPanel, BorderLayout.CENTER);
		}
		
		public function setCurrent(dirInfo:DirectionInfo, path:TreePath):void
		{
			m_topPanel.setDelBtnEnabled(true);
			
			m_leftPanel.setCurrent(dirInfo.action, dirInfo, path);
			
			m_bottomPanel.setDirInfo(dirInfo);
			
			m_renderPanel.setDirInfo(dirInfo);
		}
		
		public function clearCurrent():void
		{
			m_topPanel.setDelBtnEnabled(false);
			
			m_leftPanel.clearCurrent();
			
			m_bottomPanel.setDirInfo();
			
			m_renderPanel.setDirInfo();
		}
		
		public function setSelected(dirInfo:DirectionInfo):void
		{
			m_topPanel.setDelBtnEnabled(true);
			
			m_leftPanel.setSelected(dirInfo);
			
			m_bottomPanel.setDirInfo(dirInfo);
			
			m_renderPanel.setDirInfo(dirInfo);
		}
		
		public function delSelected():void
		{
			m_topPanel.setDelBtnEnabled(false);
			
			m_leftPanel.delSelected();
			
			m_bottomPanel.setDirInfo();
			
			m_renderPanel.setDirInfo();
		}
		
		public function refreshTree():void
		{
			m_leftPanel.refreshTree();
		}
		
		public function read(f:File):void
		{
			DisposeUtil.free(m_packerData);
			
			m_packerData.clear();
			
			var dir:DirectionInfo = m_packerData.read(f);
			
			m_leftPanel.updateUI();
			
			setSelected(dir);
		}
	}
}