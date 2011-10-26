package editor.rightviews
{
	
	import org.aswing.JPanel;
	import org.aswing.JTabbedPane;
	import editor.rightviews.tabs.BuildingsTab;
	import editor.rightviews.tabs.NPCsTab;
	import editor.rightviews.tabs.SurfaceTab;
	
	public class ResourceTabbed extends JTabbedPane
	{
		protected var mapEditor:JsionMapEditor;
		
		protected var buildingsTab:BuildingsTab;
		
		protected var npcsTab:NPCsTab;
		
		protected var surfaceTab:SurfaceTab;
		
		protected var resourcePreview:ResourcePreviewer;
		
		public function ResourceTabbed(editor:JsionMapEditor, previewer:ResourcePreviewer)
		{
			mapEditor = editor;
			resourcePreview = previewer;
			
			super();
			
			initialize();
		}
		
		protected function initialize():void
		{
			surfaceTab = new SurfaceTab(mapEditor, resourcePreview);
			append(surfaceTab, "地表");
			
			buildingsTab = new BuildingsTab(mapEditor, resourcePreview);
			append(buildingsTab, "建筑");
			
			npcsTab = new NPCsTab(mapEditor, resourcePreview);
			append(npcsTab, "NPC");
		}
		
		public function updateHeight(c:JPanel, subHeight:int):void
		{
			buildingsTab.setHeight(c.height - subHeight);
		}
	}
}