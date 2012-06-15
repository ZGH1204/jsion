package jsion.tool.mapeditor
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;
	
	import jsion.loaders.BitmapDataLoader;
	import jsion.rpg.RPGGlobal;
	import jsion.rpg.engine.datas.MapInfo;
	import jsion.tool.BaseFrame;
	import jsion.tool.ToolGlobal;
	import jsion.tool.mapeditor.datas.MapData;
	import jsion.tool.mgrs.FileMgr;
	import jsion.tool.piccuter.PicCuterFrame;
	import jsion.utils.DisposeUtil;
	import jsion.utils.ScaleUtil;
	import jsion.utils.StringUtil;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.graphics.codec.JPEGEncoder;
	
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
		
		private var m_imageLoader:BitmapDataLoader;
		
		private var m_bitmapData:BitmapData;
		
		private var m_loader:Loader;
		
		private var m_frame:PicCuterFrame;
		
		private var m_createCallback:Function;
		
		private var m_jpgEncoder:JPEGEncoder;
		
		public function CreateFrame(modal:Boolean=false)
		{
			m_title = "创建地图";
			
			m_jpgEncoder = new JPEGEncoder(100);
			
			super(ToolGlobal.window, modal);
			
			//m_content.setLayout(new SoftBoxLayout(SoftBoxLayout.Y_AXIS, 5));
			
			setSizeWH(375, 305);
			
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
			m_smallHeightTxt.setToolTipText("此设置暂时无效");
			m_smallHeightTxt.setEnabled(false);
			
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
			m_outPathTxt = new JTextField(File.desktopDirectory.resolvePath("Maps").nativePath, 23);
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
				m_smallWidthTxt.setEnabled(true);
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
				m_smallWidthTxt.setEnabled(false);
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
			
			m_okBtn.setEnabled(false);
			
			DisposeUtil.free(m_imageLoader);
			m_imageLoader = new BitmapDataLoader(file.nativePath);
			m_imageLoader.loadAsync(mapImageLoadCallback);
		}
		
		private function mapImageLoadCallback(loader:BitmapDataLoader):void
		{
			m_okBtn.setEnabled(true);
			
			m_bitmapData = BitmapData(loader.data).clone();
			
			if(m_mapWidthTxt) m_mapWidthTxt.setText(m_bitmapData.width.toString());
			if(m_mapHeightTxt) m_mapHeightTxt.setText(m_bitmapData.height.toString());
		}
		
		private function onOpenOutPathHandler(e:AWEvent):void
		{
			FileMgr.openBrowse(onOpenOutPathCallback, [new FileFilter("支持的图片格式", "*.png;*.jpg;*.jpeg;*.bmp")]);
		}
		
		private function onOpenOutPathCallback(file:File):void
		{
			if(m_outPathTxt) m_outPathTxt.setText(file.nativePath);
		}
		
		override protected function onSubmit(e:Event):void
		{
			if(m_mapTileType.isSelected())
			{
				if(StringUtil.isNullOrEmpty(m_mapPicTxt.getText()))
				{
					Alert.show("请选择地图文件", "提示");
					return;
				}
			}
			else
			{
				if(StringUtil.isNullOrEmpty(m_loopPicTxt.getText()))
				{
					Alert.show("请选择循环背景", "提示");
					return;
				}
				
				if(int(m_mapWidthTxt.getText()) <= 0 ||
					int(m_mapHeightTxt.getText()) <= 0)
				{
					Alert.show("请填写地图大小", "提示");
					return;
				}
			}
			
			//此地图的资源输出目录
			var outFile:File = new File(m_outPathTxt.getText());
			outFile = outFile.resolvePath(m_mapIDTxt.getText());
			if(outFile.exists)
			{
				Alert.show("地图已存在，创建时将删除现有地图信息和资源，是否创建？", "提示", Alert.YES | Alert.NO, null, alertCloseCallback, null, Alert.YES);
				return;
			}
			
			createMap();
		}
		
		private function createMap():void
		{
			//此地图的资源输出目录
			var outFile:File = new File(m_outPathTxt.getText());
			outFile = outFile.resolvePath(m_mapIDTxt.getText());
			outFile.createDirectory();
			
			//读取要创建的地图信息
			var mapInfo:MapData = createMapInfo();
			
			//将地图信息保存到输出目录
			saveMapInfoFile(mapInfo, outFile.resolvePath(mapInfo.mapID + ".map"));
			
			if(mapInfo.mapType == MapInfo.TileMap)
			{
				//复制大地图文件到输出目录
				var mapImgFile:File = new File(m_mapPicTxt.getText());
				var mapImgBackFile:File = outFile.resolvePath("big." + mapImgFile.extension);
				FileMgr.copy2Target(mapImgFile, mapImgBackFile);
				
				//制作缩略图并保存到输出目录
				makeSmallMap(m_bitmapData, mapInfo, outFile.resolvePath("small.jpg"));
				
				
				//切割地图并保存到输出目录
				showCutFrame(outFile.resolvePath("tiles").nativePath, mapImgBackFile.nativePath);
			}
			else
			{
				var loopFile:File = new File(m_loopPicTxt.getText());
				
				var bytes:ByteArray = new ByteArray();
				
				var fs:FileStream = new FileStream();
				fs.open(loopFile, FileMode.READ);
				fs.readBytes(bytes);
				fs.close();
				
				DisposeUtil.free(m_loader);
				m_loader = new Loader();
				m_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, __loopFileCompleteHandler);
				m_loader.loadBytes(bytes);
			}
		}
		
		private function alertCloseCallback(e:CloseEvent):void
		{
			//此地图的资源输出目录
			var outFile:File = new File(m_outPathTxt.getText());
			outFile = outFile.resolvePath(m_mapIDTxt.getText());
			
			if(e.detail == Alert.YES)
			{
				outFile.deleteDirectory(true);
				
				createMap();
			}
		}
		
		private function __loopFileCompleteHandler(e:Event):void
		{
			m_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, __loopFileCompleteHandler);
			
			var bmd:BitmapData = Bitmap(m_loader.content).bitmapData;
			
			var bytes:ByteArray = m_jpgEncoder.encode(bmd);
			
			var outFile:File = new File(m_outPathTxt.getText());
			outFile = outFile.resolvePath(m_mapIDTxt.getText());
			outFile = outFile.resolvePath("loop.jpg");
			
			var fs:FileStream = new FileStream();
			fs.open(outFile, FileMode.WRITE);
			fs.writeBytes(bytes);
			fs.close();
			
			DisposeUtil.free(m_loader);
			m_loader = null;
			
			fireCompleteEvent();
			
			super.onSubmit(e);
		}
		
		public function createMapInfo():MapData
		{
			var mapInfo:MapData = new MapData();
			
			if(m_mapTileType.isSelected())
			{
				mapInfo.mapType = MapInfo.TileMap;
			}
			else
			{
				mapInfo.mapType = MapInfo.LoopMap;
			}
			
			if(m_pngRadio.isSelected())
			{
				mapInfo.tileExt = ".png";
			}
			else
			{
				mapInfo.tileExt = ".jpg";
			}
			
			mapInfo.mapID = int(m_mapIDTxt.getText());
			mapInfo.mapName = m_mapNameTxt.getText();
			mapInfo.mapWidth = int(m_mapWidthTxt.getText());
			mapInfo.mapHeight = int(m_mapHeightTxt.getText());
			mapInfo.smallWidth = int(m_smallWidthTxt.getText());
			mapInfo.smallHeight = int(m_smallHeightTxt.getText());
			mapInfo.tileWidth = int(m_tileWidthTxt.getText());
			mapInfo.tileHeight = int(m_tileHeightTxt.getText());
			mapInfo.mapRoot = m_outPathTxt.getText();
			
			return mapInfo;
		}
		
		public function makeSmallMap(bmd:BitmapData, mapInfo:MapInfo, smallMapFile:File):void
		{
			var scale:Number = ScaleUtil.calcScaleFullSize(bmd.width, bmd.height, mapInfo.smallWidth, 0);
			
			var rltWidth:int = bmd.width * scale;
			var rltHeight:int = bmd.height * scale;
			
			var smallBmd:BitmapData = new BitmapData(mapInfo.smallWidth, rltHeight, true, 0);//JsionEditor.mapConfig.SmallMapHeight, true, 0);
			
			var matrix:Matrix = new Matrix();
			matrix.scale(scale, scale);
			
			smallBmd.draw(bmd, matrix);
			
			var bytes:ByteArray = m_jpgEncoder.encode(smallBmd);
			
			if(smallMapFile.exists) smallMapFile.deleteFile();
			
			var fs:FileStream = new FileStream();
			fs.open(smallMapFile, FileMode.WRITE);
			fs.writeBytes(bytes);
			fs.close();
		}
		
		public function showCutFrame(outPath:String, picPatch:String):void
		{
			if(m_frame) return;
			
			m_frame = new PicCuterFrame(true);
			
			if(m_pngRadio.isSelected())
			{
				m_frame.setEncodePNG();
			}
			else
			{
				m_frame.setEncodeJPG();
			}
			
			m_frame.setButtonsEnabled(false);
			m_frame.setPNGAndJPGEnabled(false);
			m_frame.setTileSizeEditable(false);
			
			m_frame.setOutPath(outPath);
			m_frame.setTileWidth(int(m_tileWidthTxt.getText()));
			m_frame.setTileHeight(int(m_tileHeightTxt.getText()));
			m_frame.setPicPath(picPatch);
			
			m_frame.show();
			
			m_frame.autoStartCut();
			
			m_frame.addEventListener(Event.COMPLETE, __cutCompleteHandler);
		}
		
		private function __cutCompleteHandler(e:Event):void
		{
			m_frame.removeEventListener(Event.COMPLETE, __cutCompleteHandler);
			m_frame = null;
			
			fireCompleteEvent();
			
			super.onSubmit(e);
		}
		
		public function saveMapInfoFile(mapInfo:MapInfo, mapFile:File):void
		{
			var bytes:ByteArray = RPGGlobal.trans2Bytes(mapInfo);
			
			var fs:FileStream = new FileStream();
			fs.open(mapFile, FileMode.WRITE);
			fs.writeBytes(bytes);
			fs.close();
		}
		
		public function setCreateCallback(fn:Function):void
		{
			m_createCallback = fn;
		}
		
		protected function fireCompleteEvent():void
		{
			if(m_createCallback != null)m_createCallback(createMapInfo());
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		override public function dispose():void
		{
			DisposeUtil.free(m_imageLoader);
			m_imageLoader = null;
			
			if(m_frame) m_frame.removeEventListener(Event.COMPLETE, __cutCompleteHandler);
			m_frame = null;
			
			m_mapIDTxt = null;
			m_mapNameTxt = null;
			
			m_mapWidthTxt = null;
			m_mapHeightTxt = null;
			
			m_smallWidthTxt = null;
			m_smallHeightTxt = null;
			
			m_tileWidthTxt = null;
			m_tileHeightTxt = null;
			
			m_mapTileType = null;
			m_mapLoopType = null;
			
			m_loopPicTxt = null;
			m_loopPicBtn = null;
			
			m_mapPicTxt = null;
			m_mapPicBtn = null;
			
			m_pngRadio = null;
			m_jpgRadio = null;
			
			m_outPathTxt = null;
			
			m_outPathBtn = null;
			
			m_bitmapData = null;
			
			m_createCallback = null;
			
			m_jpgEncoder = null;
			
			super.dispose();
		}
	}
}