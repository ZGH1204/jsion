package editor
{
	import editor.forms.FileNewForm;
	import editor.forms.FileOpenForm;
	
	import org.aswing.JButton;
	import org.aswing.JPanel;
	import org.aswing.JToggleButton;
	import org.aswing.LayoutManager;
	import org.aswing.LoadIcon;
	import org.aswing.SoftBoxLayout;
	import org.aswing.event.AWEvent;
	
	public class EditorTool extends JPanel
	{
		private static const NewMap:String = "新建";
		private static const OpenMap:String = "打开";
		private static const SaveMap:String = "保存";
		
		private static const FindPathGrid:String = "显示/隐藏寻路格子";
		
		private var mapEditor:JsionMapEditor;
		
		public function EditorTool(owner:JsionMapEditor)
		{
			mapEditor = owner;
			
			super(new SoftBoxLayout(SoftBoxLayout.X_AXIS, 5));
			
			var newMapBtn:JButton = new JButton(null, new LoadIcon("EditorUI/NewMap.png", 18, 14));
			newMapBtn.addActionListener(onNewMap);
			newMapBtn.setToolTipText(NewMap);
			
			var openMapBtn:JButton = new JButton(null, new LoadIcon("EditorUI/OpenMap.png", 18, 14));
			openMapBtn.addActionListener(onOpenMap);
			openMapBtn.setToolTipText(OpenMap);
			
			var saveMapBtn:JButton = new JButton(null, new LoadIcon("EditorUI/SaveMap.png", 18, 14));
			saveMapBtn.addActionListener(onSaveMap);
			saveMapBtn.setToolTipText(SaveMap);
			
			var showFindPathGridBtn:JToggleButton = new JToggleButton(null, new LoadIcon("EditorUI/ShowFindPathGrid.png", 18, 14));
			showFindPathGridBtn.setToolTipText(FindPathGrid);
			
			
			
			append(newMapBtn);
			append(openMapBtn);
			append(saveMapBtn);
			append(showFindPathGridBtn);
		}
		
		private function onNewMap(e:AWEvent):void
		{
			new FileNewForm(mapEditor).show();
		}
		
		private function onOpenMap(e:AWEvent):void
		{
			new FileOpenForm(mapEditor).show();
		}
		
		private function onSaveMap(e:AWEvent):void
		{
			JsionEditor.saveMapConfig(mapEditor);
		}
	}
}