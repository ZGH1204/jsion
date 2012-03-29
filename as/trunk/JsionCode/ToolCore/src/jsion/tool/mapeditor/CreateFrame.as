package jsion.tool.mapeditor
{
	import flash.filesystem.File;
	import flash.net.FileFilter;
	
	import jsion.tool.BaseFrame;
	import jsion.tool.ToolGlobal;
	import jsion.tool.mgrs.FileMgr;
	
	import org.aswing.AbstractButton;
	import org.aswing.BorderLayout;
	import org.aswing.ButtonGroup;
	import org.aswing.JButton;
	import org.aswing.JLabel;
	import org.aswing.JPanel;
	import org.aswing.JRadioButton;
	import org.aswing.JTextField;
	import org.aswing.SoftBoxLayout;
	import org.aswing.event.AWEvent;
	
	public class CreateFrame extends BaseFrame
	{
		private var m_mapIDTxt:JTextField;
		private var m_mapNameTxt:JTextField;
		
		private var m_mapWidthTxt:JTextField;
		private var m_mapHeightTxt:JTextField;
		
		private var m_smallWidthTxt:JTextField;
		private var m_smallHeightTxt:JTextField;
		
		private var m_tileWidthTxt:JTextField;
		private var m_tileHeightTxt:JTextField;
		
		private var m_mapTileType:JRadioButton;
		private var m_mapLoopType:JRadioButton;
		
		private var m_loopPicTxt:JTextField;
		private var m_loopPicBtn:JButton;
		
		private var m_mapPicTxt:JTextField;
		private var m_mapPicBtn:JButton;
		
		/**
		 * 输出PNG编码图片文件
		 */		
		private var m_pngRadio:JRadioButton;
		
		/**
		 * 输出JPG编码图片文件
		 */		
		private var m_jpgRadio:JRadioButton;
		
		private var m_outPathTxt:JTextField;
		
		private var m_outPathBtn:JButton;
		
		public function CreateFrame(modal:Boolean=false)
		{
			m_title = "创建地图";
			
			super(ToolGlobal.window, modal);
			
			//m_content.setLayout(new SoftBoxLayout(SoftBoxLayout.Y_AXIS, 5));
			
			setSizeWH(375, 500);
			
			setResizable(false);
			
			buildForm();
			
			var pane:JPanel;
			
			//地图ID和名称
			m_mapIDTxt = new JTextField("1", 10);
			m_mapIDTxt.setRestrict("0-9");
			m_mapNameTxt = new JTextField("地图1", 10);
			
			pane = new JPanel(new SoftBoxLayout(SoftBoxLayout.X_AXIS));
			pane.appendAll(m_mapIDTxt, new JLabel(" 地图名称:"), m_mapNameTxt);
			
			m_box.addRow(new JLabel("地图ID:"), pane);
			
			
			//地图宽度和高度
			m_mapWidthTxt = new JTextField("0", 10);
			m_mapWidthTxt.setRestrict("0-9");
			m_mapHeightTxt = new JTextField("0", 10);
			m_mapHeightTxt.setRestrict("0-9");
			m_mapWidthTxt.setEnabled(false);
			m_mapHeightTxt.setEnabled(false);
			
			pane = new JPanel(new SoftBoxLayout(SoftBoxLayout.X_AXIS));
			pane.appendAll(m_mapWidthTxt, new JLabel(" 地图高度:"), m_mapHeightTxt);
			
			m_box.addRow(new JLabel("地图宽度:"), pane);
			
			
			
			//分块宽度和高度
			m_tileWidthTxt = new JTextField("100", 10);
			m_tileWidthTxt.setRestrict("0-9");
			m_tileHeightTxt = new JTextField("100", 10);
			m_tileHeightTxt.setRestrict("0-9");
			
			pane = new JPanel(new SoftBoxLayout(SoftBoxLayout.X_AXIS));
			pane.appendAll(m_tileWidthTxt, new JLabel(" 分块高度:"), m_tileHeightTxt);
			
			m_box.addRow(new JLabel("分块宽度:"), pane);
			
			
			
			//缩略宽度和高度
			m_smallWidthTxt = new JTextField("100", 10);
			m_smallWidthTxt.setRestrict("0-9");
			m_smallHeightTxt = new JTextField("100", 10);
			m_smallHeightTxt.setRestrict("0-9");
			
			pane = new JPanel(new SoftBoxLayout(SoftBoxLayout.X_AXIS));
			pane.appendAll(m_smallWidthTxt, new JLabel(" 缩略高度:"), m_smallHeightTxt);
			
			m_box.addRow(new JLabel("缩略宽度:"), pane);
			
			
			
			
			
			//循环背景图片
			m_loopPicTxt = new JTextField("", 23);
			m_loopPicTxt.setEditable(false);
			m_loopPicBtn = new JButton("浏览");
			m_loopPicBtn.setEnabled(false);
			m_loopPicBtn.addActionListener(onLoopPicBrowseHandler);
			
			pane = new JPanel(new SoftBoxLayout(SoftBoxLayout.X_AXIS));
			pane.appendAll(m_loopPicTxt, m_loopPicBtn);
			
			m_box.addRow(new JLabel("循环背景:"), pane);
			
			
			
			
			
			
			//大地图文件
			m_mapPicTxt = new JTextField("", 23);
			m_mapPicTxt.setEditable(false);
			m_mapPicBtn = new JButton("浏览");
			m_mapPicBtn.addActionListener(onMapPicBrowseHandler);
			
			pane = new JPanel(new SoftBoxLayout(SoftBoxLayout.X_AXIS));
			pane.appendAll(m_mapPicTxt, m_mapPicBtn);
			
			m_box.addRow(new JLabel("地图文件:"), pane);
			
			
			
			//输出目录
			m_outPathTxt = new JTextField(File.desktopDirectory.resolvePath("").nativePath, 23);
			m_outPathBtn = new JButton("浏览");
			m_outPathBtn.addActionListener(onOpenOutPathHandler);
			
			pane = new JPanel(new SoftBoxLayout(SoftBoxLayout.X_AXIS));
			pane.appendAll(m_outPathTxt, m_outPathBtn);
			
			m_box.addRow(new JLabel("输出目录:"), pane);
			
			
			
			
			
			//地图类型
			m_mapTileType = new JRadioButton("分块地图");
			//m_mapTileType.setHorizontalAlignment(AbstractButton.LEFT);
			m_mapTileType.setSelected(true);
			m_mapTileType.setPreferredWidth(140);
			m_mapTileType.addSelectionListener(onMapTypeSelectionHandler);
			m_mapLoopType = new JRadioButton("循环地图");
			//m_mapLoopType.setHorizontalAlignment(AbstractButton.LEFT);
			m_mapLoopType.setPreferredWidth(140);
			m_mapLoopType.addSelectionListener(onMapTypeSelectionHandler);
			
			var group:ButtonGroup = new ButtonGroup();
			group.appendAll(m_mapTileType, m_mapLoopType);
			
			pane = new JPanel(new SoftBoxLayout(SoftBoxLayout.X_AXIS));
			pane.appendAll(m_mapTileType, m_mapLoopType);
			
			m_box.addRow(new JLabel("地图类型:"), pane);
			
			
			
			
			
			//分块文件扩展名
			m_pngRadio = new JRadioButton("PNG     ");
			//m_pngRadio.setHorizontalAlignment(AbstractButton.LEFT);
			m_pngRadio.setPreferredWidth(135);
			
			m_jpgRadio = new JRadioButton("JPG      ");
			//m_jpgRadio.setHorizontalAlignment(AbstractButton.LEFT);
			m_jpgRadio.setPreferredWidth(145);
			m_jpgRadio.setSelected(true);
			
			group = new ButtonGroup();
			group.appendAll(m_pngRadio, m_jpgRadio);
			
			pane = new JPanel(new SoftBoxLayout(SoftBoxLayout.X_AXIS));
			pane.appendAll(m_pngRadio, m_jpgRadio);
			
			m_box.addRow(new JLabel("块扩展名:"), pane);
			
			
			
			
			
			
			buildFormButton();
			
			
			
		}
		
		private function onMapTypeSelectionHandler(e:AWEvent):void
		{
			if(JRadioButton(e.currentTarget).isSelected() == false) return;
			
			if(m_mapTileType.isSelected())
			{
				trace("tile");
				m_mapWidthTxt.setEnabled(false);
				m_mapHeightTxt.setEnabled(false);
				m_tileWidthTxt.setEnabled(true);
				m_tileHeightTxt.setEnabled(true);
				m_pngRadio.setEnabled(true);
				m_jpgRadio.setEnabled(true);
				m_loopPicTxt.setText("");
				m_loopPicBtn.setEnabled(false);
				m_mapPicBtn.setEnabled(true);
			}
			else
			{
				trace("loop");
				m_mapWidthTxt.setEnabled(true);
				m_mapHeightTxt.setEnabled(true);
				m_tileWidthTxt.setEnabled(false);
				m_tileHeightTxt.setEnabled(false);
				m_pngRadio.setEnabled(false);
				m_jpgRadio.setEnabled(false);
				m_loopPicBtn.setEnabled(true);
				m_mapPicTxt.setText("");
				m_mapPicBtn.setEnabled(false);
			}
		}
		
		private function onLoopPicBrowseHandler(e:AWEvent):void
		{
			FileMgr.openBrowse(onOpenCallback, [new FileFilter("支持的图片格式", "*.png;*.jpg;*.jpeg;*.bmp")]);
		}
		
		private function onOpenCallback(file:File):void
		{
			if(m_loopPicTxt) m_loopPicTxt.setText(file.nativePath);
		}
		
		private function onMapPicBrowseHandler(e:AWEvent):void
		{
			FileMgr.openBrowse(onOpenMapPicCallback, [new FileFilter("支持的图片格式", "*.png;*.jpg;*.jpeg;*.bmp")]);
		}
		
		private function onOpenMapPicCallback(file:File):void
		{
			if(m_mapPicTxt) m_mapPicTxt.setText(file.nativePath);
		}
		
		private function onOpenOutPathHandler(e:AWEvent):void
		{
			FileMgr.openBrowse(onOpenOutPathCallback, [new FileFilter("支持的图片格式", "*.png;*.jpg;*.jpeg;*.bmp")]);
		}
		
		private function onOpenOutPathCallback(file:File):void
		{
			if(m_outPathTxt) m_outPathTxt.setText(file.nativePath);
		}
	}
}