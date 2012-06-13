package editor.rightviews.tabs
{
	import editor.events.LibTabEvent;
	import editor.rightviews.ResourcePreviewer;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import jsion.core.loaders.ImageLoader;
	import jsion.utils.ArrayUtil;
	import jsion.utils.DisposeUtil;
	import jsion.utils.JUtil;
	import jsion.utils.PathUtil;
	
	import org.aswing.JList;
	import org.aswing.JPanel;
	import org.aswing.JScrollPane;
	import org.aswing.LayoutManager;
	import org.aswing.VectorListModel;
	import org.aswing.event.ListItemEvent;
	
	public class LibTab extends JPanel
	{
		private static const PreviewDelay:int = 8;
		
		protected var mapEditor:JsionMapEditor;
		
		public var module:VectorListModel;
		
		protected var list:JList;
		
		protected var fileList:Array;
		
		protected var delayFrame:int = -1;
		
		protected var overFilename:String;
		
		protected var rootDirectory:String;
		
		protected var resourcePreview:ResourcePreviewer;
		
		public function LibTab(editor:JsionMapEditor, previewer:ResourcePreviewer, layout:LayoutManager = null)
		{
			mapEditor = editor;
			resourcePreview = previewer;
			
			super(layout);
			
			initialize();
		}
		
		protected function initialize():void
		{
			list = new JList(module);
			list.setVisibleCellWidth(JsionEditor.mapConfig.SmallMapWidth);
			list.setVisibleRowCount(10);
			
//			var count:int = module.size();
//			for (var i:int = 0; i < count; i++)
//			{
//				list.getCellByIndex(i).getCellComponent().doubleClickEnabled = true;
//			}
			
			list.addEventListener(ListItemEvent.ITEM_CLICK, __itemClickHandler);
			list.addEventListener(ListItemEvent.ITEM_MOUSE_DOWN, __itemMouseDownHandler);
			list.addEventListener(ListItemEvent.ITEM_DOUBLE_CLICK, __itemDoubleClickHandler);
			append(new JScrollPane(list));
			
			JUtil.addEnterFrame(__enterFrameHandler);
		}
		
		private function __enterFrameHandler(e:Event):void
		{
			if(delayFrame > 0)
			{
				delayFrame--;
			}
			else if(delayFrame == 0)
			{
				delayFrame = -1;
				
				var file:File = new File(PathUtil.combinPath(rootDirectory, overFilename));
				
				if(file.exists == false || file.isDirectory) return;
				
				var bytes:ByteArray = new ByteArray();
				var fs:FileStream = new FileStream();
				fs.open(file, FileMode.READ);
				fs.readBytes(bytes);
				fs.close();
				
				new ImageLoader(file.nativePath).loadAsync(previewLoadCallback);
			}
		}
		
		private function previewLoadCallback(loader:ImageLoader):void
		{
			var bmd:BitmapData = Bitmap(loader.content).bitmapData;
			
			resourcePreview.draw(bmd);
			
			DisposeUtil.free(loader);
			
			dispatchEvent(new LibTabEvent(LibTabEvent.SELECT_FILE, overFilename, bmd));
		}
		
		protected function parseResourcesByDirectory(directory:String):void
		{
			var file:File = new File(directory);
			
			module = new VectorListModel();
			
			if(file.exists == false)
			{
				return;
			}
			
			rootDirectory = directory;
			
			if(fileList != null) ArrayUtil.removeAll(fileList);
			fileList = file.getDirectoryListing();
			
			for(var i:int = 0; i < fileList.length; i++)
			{
				var f:File = fileList[i] as File;
				
				if(f.isDirectory)
				{
					i--;
					fileList.splice(i, 1);
					continue;
				}
				
				module.append(f.name);
			}
		}
		
		private function __itemClickHandler(e:ListItemEvent):void
		{
			onItemClickHandler(e);
		}
		
		private function __itemMouseDownHandler(e:ListItemEvent):void
		{
			onItemMouseDownHandler(e);
		}
		
		private function __itemDoubleClickHandler(e:ListItemEvent):void
		{
			onItemDoubleClickHandler(e);
		}
		
		protected function onItemClickHandler(e:ListItemEvent):void
		{
		}
		
		protected function onItemMouseDownHandler(e:ListItemEvent):void
		{
			var filename:String = e.getCell().getCellValue();
			
			//if(overFilename == filename) return;
			
			overFilename = filename;
			
			delayFrame = PreviewDelay;
		}
		
		protected function onItemDoubleClickHandler(e:ListItemEvent):void
		{
			var filename:String = e.getCell().getCellValue();
			
			dispatchEvent(new LibTabEvent(LibTabEvent.DOUBLE_CLICK, filename, null));
		}
	}
}