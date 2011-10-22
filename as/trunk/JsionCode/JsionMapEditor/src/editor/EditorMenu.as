package editor
{
	import editor.forms.FileNewForm;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;
	
	import jsion.utils.StringUtil;
	import jsion.utils.XmlUtil;
	
	import org.aswing.JMenu;
	import org.aswing.JMenuBar;
	import org.aswing.JMenuItem;
	import org.aswing.JPanel;
	import org.aswing.LayoutManager;
	import org.aswing.event.AWEvent;
	
	public class EditorMenu extends JPanel
	{
		private static const File_New:String = "新建地图";
		
		private static const File_Open:String = "打开地图";
		
		private static const File_Save:String = "保存配置";
		
		private static const Tool_Map_Cut:String = "地图切割器";
		
		private var bar:JMenuBar;
		
		private var mapEditor:JsionMapEditor;
		
		public function EditorMenu(owner:JsionMapEditor)
		{
			mapEditor = owner;
			
			super();
			
			
			bar = new JMenuBar();
			
			var file:JMenu = new JMenu("文件(&F)");
			
			var file_item:JMenuItem;
			file_item = new JMenuItem(File_New);
			file_item.addActionListener(__itemClickHandler);
			file.append(file_item);
			
			file_item = new JMenuItem(File_Open);
			file_item.addActionListener(__itemClickHandler);
			file.append(file_item);
			
			file_item = new JMenuItem(File_Save);
			file_item.addActionListener(__itemClickHandler);
			file.append(file_item);
			
			
			bar.append(file);
			
			
			
			
			var tool:JMenu = new JMenu("工具(&T)");
			
			
			var file_mapcut:JMenuItem = new JMenuItem(Tool_Map_Cut);
			file_mapcut.addActionListener(__itemClickHandler);
			tool.append(file_mapcut);
			
			
			bar.append(tool);
			
			
			
			append(bar);
		}
		
		private function __itemClickHandler(e:AWEvent):void
		{
			var item:JMenuItem = e.currentTarget as JMenuItem;
			
			switch(item.getText())
			{
				case File_New:
					new FileNewForm(mapEditor).show();
					break;
				case File_Open:
					openMap();
					break;
				case File_Save:
					JsionEditor.saveMapConfig();
					mapEditor.msg("保存成功", 0);
					break;
				case Tool_Map_Cut:
					if(JsionEditor.MAP_NEWED_OPENED) new MapCut(mapEditor).show();
					else mapEditor.msg("未创建或打开地图");
					break;
				default:
					trace(item.getText());
					break;
			}
		}
		
		private function openMap():void
		{
			var file:File = new File();
			file.browseForOpen("打开地图配置", [new FileFilter("地图配置文件", "*.map")]);
			file.addEventListener(Event.SELECT, __openSelectHandler, false, 0, true);
		}
		
		private function __openSelectHandler(e:Event):void
		{
			File(e.currentTarget).removeEventListener(Event.SELECT, __openSelectHandler);
			var file:File = e.target as File;
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
		}
	}
}