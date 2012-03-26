package jsion.tool.menus
{
	import jsion.tool.BaseFrame;
	import jsion.tool.ToolGlobal;
	import jsion.tool.compresses.CompressPane;
	import jsion.tool.pngpacker.PackerFrame;
	
	import mx.managers.PopUpManager;
	
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
			
			item = new JMenuItem("文件压缩");
			item.addActionListener(onCompressHandler);
			tool.append(item);
			
			append(tool);
		}
		
		private function onItemClickHandler(e:AWEvent):void
		{
			var frame:BaseFrame = new PackerFrame();
			
			frame.show();
		}
		
		private function onCompressHandler(e:AWEvent):void
		{
//			var pane:CompressPane = new CompressPane();
//			
//			pane.x = (ToolGlobal.windowedApp.width - pane.width) / 2;
//			pane.y = (ToolGlobal.windowedApp.height - pane.height) / 2;
//			
//			PopUpManager.addPopUp(pane, ToolGlobal.windowedApp, true);
			
			ToolGlobal.dragDropCompress = PopUpManager.createPopUp(ToolGlobal.windowedApp, CompressPane, true);
		}
	}
}