package editor
{
	import editor.forms.FileNewForm;
	
	import org.aswing.JMenu;
	import org.aswing.JMenuBar;
	import org.aswing.JMenuItem;
	import org.aswing.JPanel;
	import org.aswing.LayoutManager;
	import org.aswing.event.AWEvent;
	
	public class EditorMenu extends JPanel
	{
		private static const File_New:String = "新建地图";
		
		private static const Tool_Map_Cut:String = "地图切割器";
		
		private var bar:JMenuBar;
		
		private var mapEditor:JsionMapEditor;
		
		public function EditorMenu(owner:JsionMapEditor)
		{
			mapEditor = owner;
			
			super();
			
			
			bar = new JMenuBar();
			
			var file:JMenu = new JMenu("文件(&F)");
			
			
			var file_new:JMenuItem = new JMenuItem(File_New);
			file_new.addActionListener(__itemClickHandler);
			file.append(file_new);
			
			
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