package editor.rightviews.tabs
{
	import editor.rightviews.ResourcePreviewer;
	
	import org.aswing.LayoutManager;
	
	public class SurfaceTab extends LibTab
	{
		public function SurfaceTab(editor:JsionMapEditor, previewer:ResourcePreviewer, layout:LayoutManager=null)
		{
			super(editor, previewer, layout);
		}
		
		override protected function initialize():void
		{
			parseResourcesByDirectory(JsionEditor.getNPCsRoot());
			
			super.initialize();
		}
	}
}