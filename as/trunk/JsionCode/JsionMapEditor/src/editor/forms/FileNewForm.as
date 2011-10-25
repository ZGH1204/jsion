package editor.forms
{
	import editor.JsionEditorWin;
	import editor.MapCut;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.ByteArray;
	
	import jsion.utils.JUtil;
	import jsion.utils.StringUtil;
	
	import org.aswing.AbstractButton;
	import org.aswing.ButtonGroup;
	import org.aswing.JButton;
	import org.aswing.JCheckBox;
	import org.aswing.JLabel;
	import org.aswing.JPanel;
	import org.aswing.JRadioButton;
	import org.aswing.JTextField;
	import org.aswing.SoftBoxLayout;
	
	public class FileNewForm extends JsionEditorWin
	{
		private var mapidTxt:JTextField;
		
		private var mapWidthTxt:JTextField;
		private var mapHeightTxt:JTextField;
		
		private var smallWidthTxt:JTextField;
		private var smallHeightTxt:JTextField;
		
		private var tileWidthTxt:JTextField;
		private var tileHeightTxt:JTextField;
		
		private var wayTileWidthTxt:JTextField;
		private var wayTileHeightTxt:JTextField;
		
		private var outputDirTxt:JTextField;
		private var browserBtn:JButton;
		
		private var mapPicTxt:JTextField;
		private var browserPicBtn:JButton;
		
		private var mapCutAtOnce:JCheckBox;
		
		private var codeType_PNG:JRadioButton;
		private var codeType_JPG:JRadioButton;
		
		public function FileNewForm(owner:JsionMapEditor)
		{
			mytitle = "新建地图";
			
			WinWidth = 300;
			WinHeight = 295;
			
			super(owner, true);
		}
		
		override protected function init():void
		{
			initMain();
			
			var pane:JPanel;
			
			mapidTxt = new JTextField(JsionEditor.mapConfig.MapID, 19);
			box.addRow(new JLabel("地图ＩＤ："), mapidTxt);
			
			mapWidthTxt = new JTextField(String(JsionEditor.mapConfig.MapWidth), 7);
			mapWidthTxt.setEditable(false);
			setTextAlignCenter(mapWidthTxt);
			mapHeightTxt = new JTextField(String(JsionEditor.mapConfig.MapHeight), 7);
			mapHeightTxt.setEditable(false);
			setTextAlignCenter(mapHeightTxt);
			pane = new JPanel(new SoftBoxLayout(SoftBoxLayout.X_AXIS));
			pane.appendAll(mapWidthTxt, new JLabel("px * "), mapHeightTxt, new JLabel("px"));
			box.addRow(new JLabel("地图大小："), pane);
			
			smallWidthTxt = new JTextField(String(JsionEditor.mapConfig.SmallMapWidth), 7);
			setTextAlignCenter(smallWidthTxt);
			smallHeightTxt = new JTextField(String(JsionEditor.mapConfig.SmallMapHeight), 7);
			setTextAlignCenter(smallHeightTxt);
			pane = new JPanel(new SoftBoxLayout(SoftBoxLayout.X_AXIS));
			pane.appendAll(smallWidthTxt, new JLabel("px * "), smallHeightTxt, new JLabel("px"));
			box.addRow(new JLabel("缩略地图："), pane);
			
			tileWidthTxt = new JTextField(String(JsionEditor.mapConfig.TileWidth), 7);
			setTextAlignCenter(tileWidthTxt);
			tileHeightTxt = new JTextField(String(JsionEditor.mapConfig.TileHeight), 7);
			setTextAlignCenter(tileHeightTxt);
			pane = new JPanel(new SoftBoxLayout(SoftBoxLayout.X_AXIS));
			pane.appendAll(tileWidthTxt, new JLabel("px * "), tileHeightTxt, new JLabel("px"));
			box.addRow(new JLabel("Tile大小："), pane);
			
			wayTileWidthTxt = new JTextField(String(JsionEditor.mapConfig.WayTileWidth), 7);
			setTextAlignCenter(wayTileWidthTxt);
			wayTileHeightTxt = new JTextField(String(JsionEditor.mapConfig.WayTileHeight), 7);
			setTextAlignCenter(wayTileHeightTxt);
			pane = new JPanel(new SoftBoxLayout(SoftBoxLayout.X_AXIS));
			pane.appendAll(wayTileWidthTxt, new JLabel("px * "), wayTileHeightTxt, new JLabel("px"));
			box.addRow(new JLabel("碰撞格子："), pane);
			
			browserBtn = new JButton("浏览");
			browserBtn.addActionListener(__browserClickHandler);
			outputDirTxt = new JTextField(JsionEditor.MAP_OUTPUT_ROOT, 16);
			outputDirTxt.setEditable(false);
			pane = new JPanel(new SoftBoxLayout(SoftBoxLayout.X_AXIS));
			pane.appendAll(outputDirTxt, browserBtn);
			box.addRow(new JLabel("输出目录："), pane);
			
			browserPicBtn = new JButton("浏览");
			browserPicBtn.addActionListener(__browserPicClickHandler);
			mapPicTxt = new JTextField("", 16);
			mapPicTxt.setEditable(false);
			pane = new JPanel(new SoftBoxLayout(SoftBoxLayout.X_AXIS));
			pane.appendAll(mapPicTxt, browserPicBtn);
			box.addRow(new JLabel("地图图片："), pane);
			
			mapCutAtOnce = new JCheckBox("立即切割");
			mapCutAtOnce.setHorizontalAlignment(AbstractButton.LEFT);
			mapCutAtOnce.setSelected(true);
			box.addRow(new JLabel("切割地图："), mapCutAtOnce);
			
			codeType_PNG = new JRadioButton("PNG");
			codeType_PNG.setHorizontalAlignment(AbstractButton.LEFT);
			codeType_PNG.setPreferredWidth(80);
			codeType_JPG = new JRadioButton("JPG");
			codeType_JPG.setHorizontalAlignment(AbstractButton.LEFT);
			codeType_JPG.setPreferredWidth(60);
			codeType_JPG.setSelected(true);
			var gp:ButtonGroup = new ButtonGroup();
			gp.appendAll(codeType_PNG, codeType_JPG);
			pane = new JPanel(new SoftBoxLayout(SoftBoxLayout.X_AXIS));
			pane.appendAll(codeType_PNG, codeType_JPG);
			box.addRow(new JLabel("编码类型："), pane);
			
			
			super.init();
			
			
			hasMapPic = false;
			
			mapidTxt.selectAll();
		}
		
		private function setTextAlignCenter(txt:JTextField):void
		{
			txt.setTextFormat(new TextFormat(null, null, null, null, null, null, null, null, TextFormatAlign.CENTER));
		}
		
		private function __browserPicClickHandler(e:Event):void
		{
			var file:File = new File();
			file.browseForOpen("请选择地图图片文件", [new FileFilter("图片文件", "*.jpg;*.jpeg;*.png")]);
			file.addEventListener(Event.SELECT, __browserPicSelectHandler, false, 0, true);
		}
		
		private function __browserPicSelectHandler(e:Event):void
		{
			var file:File = File(e.target);
			File(e.currentTarget).removeEventListener(Event.SELECT, __browserPicSelectHandler);
			mapPicTxt.setText(file.nativePath);
			
			var bytes:ByteArray = new ByteArray();
			var fs:FileStream = new FileStream();
			fs.open(file, FileMode.READ);
			fs.readBytes(bytes);
			fs.close();
			
			var loader:Loader = new Loader();
			loader.loadBytes(bytes);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, __picLoadCompleteHandler);
		}
		
		private function __picLoadCompleteHandler(e:Event):void
		{
			var li:LoaderInfo = LoaderInfo(e.currentTarget);
			li.removeEventListener(Event.COMPLETE, __picLoadCompleteHandler);
			var loader:Loader = li.loader;
			var bmp:Bitmap = loader.content as Bitmap;
			
			mapWidthTxt.setText(String(bmp.width));
			setTextAlignCenter(mapWidthTxt);
			mapHeightTxt.setText(String(bmp.height));
			setTextAlignCenter(mapHeightTxt);
			
			mapidTxt.selectAll();
			hasMapPic = true;
		}
		
		private function __browserClickHandler(e:Event):void
		{
			var file:File = new File();
			file.browseForDirectory("请选择输出目录");
			file.addEventListener(Event.SELECT, __browserSelectHandler, false, 0, true);
		}
		
		private function __browserSelectHandler(e:Event):void
		{
			File(e.currentTarget).removeEventListener(Event.SELECT, __browserSelectHandler);
			outputDirTxt.setText(File(e.target).nativePath);
		}
		
		override protected function onSubmit(e:Event):void
		{
			var mapFile:File = new File(mapPicTxt.getText());
			
			var mapid:String = StringUtil.trim(mapidTxt.getText());
			
			if(mapFile.exists == false || StringUtil.isNullOrEmpty(mapid)) return;
			
			var mapOutputRoot:String = outputDirTxt.getText();
			var copyToRoot:File = new File(JsionEditor.getMapRoot());
			copyToRoot.createDirectory();
			
			JsionEditor.MAP_NEWED_OPENED = true;
			JsionEditor.MAP_PIC_FILE = mapPicTxt.getText();
			JsionEditor.MAP_OUTPUT_ROOT = mapOutputRoot;
			JsionEditor.mapConfig.MapID = mapid;
			JsionEditor.mapConfig.MapWidth = int(mapWidthTxt.getText());
			JsionEditor.mapConfig.MapHeight = int(mapHeightTxt.getText());
			JsionEditor.mapConfig.SmallMapWidth = int(smallWidthTxt.getText());
			JsionEditor.mapConfig.SmallMapHeight = int(smallHeightTxt.getText());
			JsionEditor.mapConfig.TileWidth = int(tileWidthTxt.getText());
			JsionEditor.mapConfig.TileHeight = int(tileHeightTxt.getText());
			JsionEditor.mapConfig.WayTileWidth = int(wayTileWidthTxt.getText());
			JsionEditor.mapConfig.WayTileHeight = int(wayTileHeightTxt.getText());
			
			var extName:String = "." + JUtil.getExtension(mapFile.nativePath);
			var targetFile:File = new File(JsionEditor.getBigMapPicPath(extName));
			if(targetFile.exists) targetFile.deleteFile();
			
			copyFile(mapFile.nativePath, targetFile.nativePath);
			
			JsionEditor.MAP_PIC_FILE = targetFile.nativePath;
			
			if(mapCutAtOnce.isSelected())
			{
				var isPng:Boolean = codeType_PNG.isSelected();
				if(isPng) JsionEditor.MAP_TILES_EXTENSION = ".png";
				else JsionEditor.MAP_TILES_EXTENSION = ".jpg";
				new MapCut(mapEditor).startCutMapPic(JsionEditor.MAP_PIC_FILE, isPng);
				JsionEditor.saveMapConfig(null);
			}
			
			mapEditor.fileNewCallabck();
			
			super.onSubmit(e);
		}
		
		private function copyFile(sourceFile:String, targetFile:String):void
		{
			var file:File = new File(sourceFile);
			
			var bytes:ByteArray = new ByteArray();
			
			var fs:FileStream = new FileStream();
			fs.open(file, FileMode.READ);
			fs.readBytes(bytes);
			fs.close();
			
			bytes.position = 0;
			
			file = new File(targetFile);
			if(file.exists) file.deleteFile();
			
			fs = new FileStream();
			fs.open(file, FileMode.WRITE);
			fs.writeBytes(bytes);
			fs.close();
		}
		
		private var _hasMapPic:Boolean;
		
		protected function get hasMapPic():Boolean
		{
			return _hasMapPic;
		}
		
		protected function set hasMapPic(value:Boolean):void
		{
			_hasMapPic = value;
			bt_ok.setEnabled(_hasMapPic);
		}
		
		override public function dispose():void
		{
			
			mapidTxt = null;
			
			mapWidthTxt = null;
			mapHeightTxt = null;
			
			smallWidthTxt = null;
			smallHeightTxt = null;
			
			tileWidthTxt = null;
			tileHeightTxt = null;
			
			outputDirTxt = null;
			browserBtn = null;
			
			mapPicTxt = null;
			browserPicBtn = null;
			
			mapCutAtOnce = null;
			
			codeType_PNG = null;
			codeType_JPG = null;
			
			super.dispose();
		}
	}
}