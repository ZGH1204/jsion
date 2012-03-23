package jsion.tool.menus
{
	import jsion.tool.BaseFrame;
	import jsion.tool.pngpacker.PackerFrame;
	
	import org.aswing.JMenu;
	import org.aswing.JMenuBar;
	import org.aswing.JMenuItem;
	import org.aswing.event.AWEvent;
	
	public class MenuBox extends JMenuBar
	{
		public function MenuBox()
		{
			super();
			
			initialize();
		}
		
		private function initialize():void
		{
			var tool:JMenu = new JMenu("工具(&T)");
			
			var item:JMenuItem;
			
			
			item = new JMenuItem("资源打包器");
			item.setPreferredWidth(150);
			item.addActionListener(onItemClickHandler);
			tool.append(item);
			
			
			append(tool);
		}
		
		private function onItemClickHandler(e:AWEvent):void
		{
			var frame:BaseFrame = new PackerFrame();
			
			frame.show();
		}
	}
}