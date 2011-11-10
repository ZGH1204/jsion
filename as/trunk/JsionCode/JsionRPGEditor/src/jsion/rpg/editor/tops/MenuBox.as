package jsion.rpg.editor.tops
{
	import jsion.rpg.editor.controls.BaseFrame;
	
	import org.aswing.JCheckBoxMenuItem;
	import org.aswing.JMenu;
	import org.aswing.JMenuBar;
	import org.aswing.JMenuItem;
	import org.aswing.KeySequence;
	import org.aswing.KeyStroke;
	import org.aswing.event.AWEvent;
	
	public class MenuBox extends JMenuBar
	{
		private static const File_New:String = "新建(&N)";
		private static const File_Open:String = "打开(&O)";
		private static const File_Save:String = "保存(&S)";
		private static const File_SaveAs:String = "另存为(&A)...";
		private static const File_Save_Config:String = "生成服务器配置";
		
		private static const About:String = "关于(&A)";
		
		public function MenuBox()
		{
			super();
			
			initialize();
		}
		
		private function initialize():void
		{
			var file:JMenu = createRootMenu("文件(&F)");
			
			createMenuItem(file, File_New, KeyStroke.VK_CONTROL, KeyStroke.VK_N);
			
			createMenuItem(file, File_Open, KeyStroke.VK_CONTROL, KeyStroke.VK_O);
			
			createMenuItem(file, File_Save, KeyStroke.VK_CONTROL, KeyStroke.VK_S);
			
			createMenuItem(file, File_SaveAs);
			
			createMenuItem(file, File_Save_Config);
			
			
			
			
			
			var help:JMenu = createRootMenu("帮助(&H)");
			
			createMenuItem(help, About);
		}
		
		private function __itemClickHandler(e:AWEvent):void
		{
			var item:JMenuItem = e.currentTarget as JMenuItem;
			
			switch(item.getText())
			{
				case File_New:
					new BaseFrame().show();
					break;
				default:
					trace(item.getText());
					break;
			}
		}
		
		private function createRootMenu(label:String):JMenu
		{
			var menu:JMenu = new JMenu(label);
			
			append(menu);
			
			return menu;
		}
		
		private function createMenuItem(root:JMenu, label:String, pressed:KeyStroke = null, second:KeyStroke = null):JMenuItem
		{
			var item:JMenuItem = new JMenuItem(label);
			
			//item.setPreferredWidth(100);
			item.addActionListener(__itemClickHandler);
			root.append(item);
			
			if(pressed && second)
			{
				item.setAccelerator(new KeySequence(pressed, second));
			}
			
			return item;
		}
		
		private function createCheckMenuItem(root:JMenu, label:String, pressed:KeyStroke = null, second:KeyStroke = null):JMenuItem
		{
			var item:JMenuItem = new JCheckBoxMenuItem(label);
			
			//item.setPreferredWidth(100);
			item.addActionListener(__itemClickHandler);
			root.append(item);
			
			if(pressed && second)
			{
				item.setAccelerator(new KeySequence(pressed, second));
			}
			
			return item;
		}
	}
}