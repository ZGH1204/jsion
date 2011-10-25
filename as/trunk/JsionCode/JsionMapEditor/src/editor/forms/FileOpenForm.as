package editor.forms
{
	import editor.JsionEditorWin;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;
	
	import jsion.utils.RandomUtil;
	import jsion.utils.StringUtil;
	import jsion.utils.XmlUtil;
	
	import org.aswing.JButton;
	import org.aswing.JLabel;
	import org.aswing.JTextField;
	import org.aswing.event.AWEvent;
	
	public class FileOpenForm extends JsionEditorWin
	{
		private static const FormW:int = 300;
		
		private static const FormH:int = 275;
		
		private var filePathTxt:JTextField;
		
		public function FileOpenForm(owner:JsionMapEditor)
		{
			mytitle = "打开地图";
			
			WinWidth = 300;
			WinHeight = 100;
			
			super(owner, true);
		}
		
		override protected function init():void
		{
			initMain();
			
			filePathTxt = new JTextField("", 17);
			filePathTxt.setEditable(false);
			
			var browserBtn:JButton = new JButton("浏览");
			browserBtn.addActionListener(onBrowserClickHandler);
			
			box.addRow(new JLabel("配置文件："), filePathTxt, browserBtn);
			
			super.init();
		}
		
		private function onBrowserClickHandler(e:AWEvent):void
		{
			var file:File = new File(File.desktopDirectory.nativePath);
			file.browseForOpen("打开地图配置", [new FileFilter("地图配置文件", "*.map")]);
			file.addEventListener(Event.SELECT, __openSelectHandler, false, 0, true);
		}
		
		private function __openSelectHandler(e:Event):void
		{
			File(e.currentTarget).removeEventListener(Event.SELECT, __openSelectHandler);
			var file:File = e.target as File;
			filePathTxt.setText(file.nativePath);
			
			
		}
		
		override protected function onSubmit(e:Event):void
		{
			var file:File = new File(filePathTxt.getText());
			
			var bytes:ByteArray = new ByteArray();
			var fs:FileStream = new FileStream();
			fs.open(file, FileMode.READ);
			fs.readBytes(bytes);
			fs.close();
			
			bytes.position = 0;
			
			var str:String = bytes.readUTFBytes(bytes.bytesAvailable);
			
			var xml:XML = new XML(str);
			
			XmlUtil.decodeWithProperty(JsionEditor.mapConfig, xml);
			
			
			
			JsionEditor.MAP_OUTPUT_ROOT = StringUtil.replace(file.nativePath, "\\" + JsionEditor.mapConfig.MapID + "\\config.map", "");
			
			JsionEditor.MAP_PIC_FILE = JsionEditor.MAP_OUTPUT_ROOT + "\\" + JsionEditor.mapConfig.MapID + "\\" + JsionEditor.BIGMAP_FILE_NAME;
			if(new File(JsionEditor.MAP_PIC_FILE + ".png").exists) JsionEditor.MAP_PIC_FILE += ".png";
			else if(new File(JsionEditor.MAP_PIC_FILE + ".jpg").exists) JsionEditor.MAP_PIC_FILE += ".jpg";
			else JsionEditor.MAP_PIC_FILE = "";
			
			JsionEditor.MAP_TILES_EXTENSION = JsionEditor.mapConfig.TileExtension;
			
			JsionEditor.MAP_NEWED_OPENED = true;
			
			JsionEditor.mapWayConfig = [];
			
			var xWayCount:int = JsionEditor.mapConfig.MapWidth / JsionEditor.mapConfig.WayTileWidth;
			if((JsionEditor.mapConfig.MapWidth % JsionEditor.mapConfig.WayTileWidth) != 0) xWayCount++;
			
			var yWayCount:int = JsionEditor.mapConfig.MapHeight / JsionEditor.mapConfig.WayTileHeight;
			if((JsionEditor.mapConfig.MapHeight % JsionEditor.mapConfig.WayTileHeight) != 0) yWayCount++;
			
			JsionEditor.mapWayConfig.length = yWayCount;
			
			var tmp:int;
			
			for(var j:int = 0; j < yWayCount; j++)
			{
				JsionEditor.mapWayConfig[j] = [];
				JsionEditor.mapWayConfig[j].length = xWayCount;
				for(var i:int = 0; i < xWayCount; i++)
				{
					tmp = RandomUtil.randomRange(0, 100);
					if(tmp > 60)
					{
						JsionEditor.mapWayConfig[j][i] = 1;
					}
					else
					{
						JsionEditor.mapWayConfig[j][i] = 0;
					}
				}
			}
			
			mapEditor.fileOpenCallback(file.nativePath);
			
			super.onSubmit(e);
		}
	}
}