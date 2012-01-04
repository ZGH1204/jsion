package jsion.tool.menus
{
	import jsion.tool.BaseFrame;
	import jsion.tool.MainWindow;
	
	import org.aswing.JMenu;
	import org.aswing.JMenuBar;
	import org.aswing.JMenuItem;
	import org.aswing.event.AWEvent;
	
	public class MenuBox extends JMenuBar
	{
		private var m_owner:MainWindow;
		
		public function MenuBox(owner:MainWindow)
		{
			super();
			
			m_owner = owner;
			
			initialize();
		}
		
		private function initialize():void
		{
			var file:JMenu = new JMenu("文件(&F)");
			
			var item:JMenuItem;
			
			
			item = new JMenuItem("新建..");
			item.setPreferredWidth(150);
			item.addActionListener(onItemClickHandler);
			file.append(item);
			
			
			append(file);
		}
		
		private function onItemClickHandler(e:AWEvent):void
		{
			var frame:BaseFrame = new BaseFrame(m_owner);
			
			frame.setSizeWH(300, 130);
			
			frame.show();
		}
	}
}