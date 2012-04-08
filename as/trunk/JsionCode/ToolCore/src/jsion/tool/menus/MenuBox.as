package jsion.tool.menus
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;
	
	import jsion.rpg.RPGGlobal;
	import jsion.rpg.engine.datas.MapInfo;
	import jsion.tool.BaseFrame;
	import jsion.tool.ToolGlobal;
	import jsion.tool.compresses.CompressPane;
	import jsion.tool.mapeditor.CreateFrame;
	import jsion.tool.mapeditor.MapFrame;
	import jsion.tool.mgrs.FileMgr;
	import jsion.tool.piccuter.PicCuterFrame;
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
			
			item = new JMenuItem("切割图片");
			item.addActionListener(onCutPicHandler);
			tool.append(item);
			
			item = new JMenuItem("打开地图");
			item.addActionListener(onOpenMapHandler);
			tool.append(item);
			
			item = new JMenuItem("新建地图");
			item.addActionListener(onCreateMapHandler);
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
			ToolGlobal.dragDropCompress = PopUpManager.createPopUp(ToolGlobal.windowedApp, CompressPane, true);
		}
		
		private function onCutPicHandler(e:AWEvent):void
		{
			var frame:BaseFrame = new PicCuterFrame();
			
			frame.show();
		}
		
		private function onOpenMapHandler(e:AWEvent):void
		{
			FileMgr.openBrowse(onOpenMapCallback, [new FileFilter("地图信息文件", "*.map")]);
		}
		
		private function onOpenMapCallback(file:File):void
		{
			var bytes:ByteArray = new ByteArray();
			
			var fs:FileStream = new FileStream();
			
			fs.open(file, FileMode.READ);
			fs.readBytes(bytes);
			fs.close();
			
			var mapInfo:MapInfo = RPGGlobal.trans2MapInfo(bytes);
			showMapFrame(mapInfo);
		}
		
		private function showMapFrame(mapInfo:MapInfo):void
		{
			var frame:MapFrame = new MapFrame();
			frame.setMap(mapInfo);
			frame.show();
		}
		
		private function onCreateMapHandler(e:AWEvent):void
		{
			var frame:CreateFrame = new CreateFrame(true);
			
			frame.setCreateCallback(showMapFrame);
			
			frame.show();
		}
	}
}