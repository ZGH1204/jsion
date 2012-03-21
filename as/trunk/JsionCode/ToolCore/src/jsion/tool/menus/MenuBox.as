package jsion.tool.menus
{
	import jsion.tool.BaseFrame;
	import jsion.tool.MainWindow;
	import jsion.tool.pngpacker.PNGPackerFrame;
	
	import org.aswing.JMenu;
	import org.aswing.JMenuBar;
	import org.aswing.JMenuItem;
	import org.aswing.JWindow;
	import org.aswing.event.AWEvent;
	
	public class MenuBox extends JMenuBar
	{
		private var m_owner:JWindow;
		
		public function MenuBox(owner:JWindow)
		{
			super();
			
			m_owner = owner;
			
			initialize();
		}
		
		private function initialize():void
		{
			var file:JMenu = new JMenu("工具(&T)");
			
			var item:JMenuItem;
			
			
			item = new JMenuItem("资源打包器");
			item.setPreferredWidth(150);
			item.addActionListener(onItemClickHandler);
			file.append(item);
			
			
			append(file);
		}
		
		private function onItemClickHandler(e:AWEvent):void
		{
			var frame:BaseFrame = new PNGPackerFrame(m_owner);
			
			frame.show();
		}
	}
}