package editor
{
	import org.aswing.JMenu;
	import org.aswing.JMenuBar;
	import org.aswing.JMenuItem;
	import org.aswing.JPanel;
	import org.aswing.LayoutManager;
	import org.aswing.event.AWEvent;
	
	public class EditorMenu extends JPanel
	{
		private var bar:JMenuBar;
		
		private var _root:JsionMapEditor;
		
		public function EditorMenu(owner:JsionMapEditor)
		{
			_root = owner;
			
			super();
			
			
			bar = new JMenuBar();
			
			var file:JMenu = new JMenu("文件(&F)");
			var file_new:JMenuItem = new JMenuItem("新建");
			var file_mapcut:JMenuItem = new JMenuItem("地图切割器");
			file.append(file_new);
			file.append(file_mapcut);
			
			file_new.addActionListener(__itemClickHandler);
			file_mapcut.addActionListener(__itemClickHandler);
			
			
			bar.append(file);
			
			
			
			append(bar);
		}
		
		private function __itemClickHandler(e:AWEvent):void
		{
			var item:JMenuItem = e.currentTarget as JMenuItem;
			
			switch(item.getText())
			{
				//case "新建":
				//	break;
				case "地图切割器":
					var win:MapCut = new MapCut(_root);
					win.show();
					break;
				default:
					trace(item.getText());
					break;
			}
		}
	}
}