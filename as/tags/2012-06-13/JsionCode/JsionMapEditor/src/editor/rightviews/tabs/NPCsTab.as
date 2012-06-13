package editor.rightviews.tabs
{
	import editor.rightviews.ResourcePreviewer;
	
	import org.aswing.LayoutManager;
	
	public class NPCsTab extends LibTab
	{
		public function NPCsTab(editor:JsionMapEditor, previewer:ResourcePreviewer, layout:LayoutManager=null)
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