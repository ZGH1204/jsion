package editor
{
	import editor.forms.FileNewForm;
	import editor.forms.FileOpenForm;
	
	import org.aswing.JMenu;
	import org.aswing.JMenuBar;
	import org.aswing.JMenuItem;
	import org.aswing.JPanel;
	import org.aswing.event.AWEvent;
	
	public class EditorMenu extends JPanel
	{
		private static const File_New:String = "新建...";
		
		private static const File_Open:String = "打开...";
		
		private static const File_Save:String = "保存";
		
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
			file_item.setPreferredWidth(150);
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
			file_mapcut.setPreferredWidth(150);
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
					new FileOpenForm(mapEditor).show();
					break;
				case File_Save:
					JsionEditor.saveMapConfig(mapEditor);
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
	}
}