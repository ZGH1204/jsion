package jsion.tool.menus
{
	import jsion.tool.BaseFrame;
	import jsion.tool.MainWindow;
	import jsion.tool.pngpacker.PNGPackerFrame;
	import jsion.tool.respacker.PackerFrame;
	
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
			var tool:JMenu = new JMenu("工具(&T)");
			
			var item:JMenuItem;
			
			
			item = new JMenuItem("资源打包器(旧)");
			item.setPreferredWidth(150);
			item.addActionListener(onItemClickHandler);
			tool.append(item);
			
			item = new JMenuItem("资源打包器(新)");
			item.setPreferredWidth(150);
			item.addActionListener(onNewItemClickHandler);
			tool.append(item);
			
			
			append(tool);
		}
		
		private function onItemClickHandler(e:AWEvent):void
		{
			var frame:BaseFrame = new PNGPackerFrame(m_owner);
			
			frame.show();
		}
		
		private function onNewItemClickHandler(e:AWEvent):void
		{
			var frame:BaseFrame = new PackerFrame(m_owner);
			
			frame.show();
		}
	}
}