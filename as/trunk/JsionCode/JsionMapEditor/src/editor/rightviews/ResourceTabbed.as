package editor.rightviews
{
	
	import editor.rightviews.tabs.BuildingsTab;
	import editor.rightviews.tabs.NPCsTab;
	import editor.rightviews.tabs.SurfaceTab;
	
	import org.aswing.JPanel;
	import org.aswing.JTabbedPane;
	import org.aswing.border.TitledBorder;
	
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
			
			
			setBorder(new TitledBorder(null, '预览', TitledBorder.TOP, TitledBorder.LEFT, 10));
		}
		
//		public function updateHeight(c:JPanel, subHeight:int):void
//		{
//			surfaceTab.setHeight(c.height - subHeight);
//			buildingsTab.setHeight(c.height - subHeight);
//			npcsTab.setHeight(c.height - subHeight);
//		}
	}
}