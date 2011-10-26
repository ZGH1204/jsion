package editor.tabs
{
	import editor.ResourcePreviewer;
	
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
	
	import org.aswing.LayoutManager;
	import org.aswing.VectorListModel;
	import org.aswing.event.ListItemEvent;
	
	public class BuildingsTab extends LibTab
	{
		public function BuildingsTab(editor:JsionMapEditor, previewer:ResourcePreviewer, layout:LayoutManager=null)
		{
			super(editor, previewer, layout);
		}
		
		override protected function initialize():void
		{
			parseResourcesByDirectory(JsionEditor.getBuildingsRoot());
			
			super.initialize();
		}
	}
}