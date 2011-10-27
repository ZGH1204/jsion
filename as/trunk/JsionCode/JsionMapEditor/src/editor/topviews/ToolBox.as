package editor.topviews
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
	
	public class ToolBox extends JPanel
	{
		private static const NewMap:String = "新建";
		private static const OpenMap:String = "打开";
		private static const SaveMap:String = "保存";
		
		private static const TileGrid:String = "显示/隐藏网格";
		private static const FindPathGrid:String = "显示/隐藏碰撞格子";
		private static const EditPathGrid:String = "编辑碰撞格子";
		private static const SmallMapTip:String = "小地图";
		
		private var newMapBtn:JButton;
		
		private var openMapBtn:JButton;
		
		private var saveMapBtn:JButton;
		
		private var showTileGridBtn:JToggleButton;
		
		private var mapEditor:JsionMapEditor;
		
		private var showFindPathGridBtn:JToggleButton;
		
		private var editPathGridBtn:JToggleButton;
		
		private var smallMapBtn:JToggleButton;
		
		public function ToolBox(owner:JsionMapEditor)
		{
			mapEditor = owner;
			
			super(new SoftBoxLayout(SoftBoxLayout.X_AXIS, 5));
			
			newMapBtn = new JButton(null, new LoadIcon("EditorUI/NewMap.png", 18, 14));
			newMapBtn.addActionListener(onNewMap);
			newMapBtn.setToolTipText(NewMap);
			
			openMapBtn = new JButton(null, new LoadIcon("EditorUI/OpenMap.png", 18, 14));
			openMapBtn.addActionListener(onOpenMap);
			openMapBtn.setToolTipText(OpenMap);
			
			saveMapBtn = new JButton(null, new LoadIcon("EditorUI/SaveMap.png", 18, 14));
			saveMapBtn.addActionListener(onSaveMap);
			saveMapBtn.setToolTipText(SaveMap);
			
			showTileGridBtn = new JToggleButton(null, new LoadIcon("EditorUI/ShowTileGrid.png", 18, 14));
			showTileGridBtn.addActionListener(onTileGrid);
			showTileGridBtn.setToolTipText(TileGrid);
			
			showFindPathGridBtn = new JToggleButton(null, new LoadIcon("EditorUI/ShowFindPathGrid.png", 18, 14));
			showFindPathGridBtn.addActionListener(onFindPathGrid);
			showFindPathGridBtn.setToolTipText(FindPathGrid);
			
			editPathGridBtn = new JToggleButton(null, new LoadIcon("EditorUI/DrawPathGrid.png", 18, 14));
			editPathGridBtn.addActionListener(onEditPathGrid);
			editPathGridBtn.setToolTipText(EditPathGrid);
			
			smallMapBtn = new JToggleButton(null, new LoadIcon("EditorUI/SmallMap.png", 18, 14));
			smallMapBtn.addActionListener(onSmallMapShow);
			smallMapBtn.setToolTipText(SmallMapTip);
			
			append(newMapBtn);
			append(openMapBtn);
			append(saveMapBtn);
			append(showTileGridBtn);
			append(showFindPathGridBtn);
			append(editPathGridBtn);
			append(smallMapBtn);
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
		
		private function onTileGrid(e:AWEvent):void
		{
			var btn:JToggleButton = e.currentTarget as JToggleButton;
			
			mapEditor.gameMap.assistant.setTileGridVisible(btn.isSelected());
		}
		
		private function onFindPathGrid(e:AWEvent):void
		{
			var btn:JToggleButton = e.currentTarget as JToggleButton;
			
			mapEditor.gameMap.assistant.setWayTileGridVisible(btn.isSelected());
			
			if(btn.isSelected() == false && editPathGridBtn.isSelected()) editPathGridBtn.doClick();
		}
		
		private function onEditPathGrid(e:AWEvent):void
		{
			var btn:JToggleButton = e.currentTarget as JToggleButton;
			
			mapEditor.gameMap.assistant.setWayTileGridEditable(btn.isSelected());
			
			if(btn.isSelected() && showFindPathGridBtn.isSelected() == false) showFindPathGridBtn.doClick();
		}
		
		private function onSmallMapShow(e:AWEvent):void
		{
			var btn:JToggleButton = e.currentTarget as JToggleButton;
			
			if(btn.isSelected())
			{
				mapEditor.showSmallMap();
			}
			else
			{
				mapEditor.hideSmallMap();
			}
		}
		
		public function updateBoxBtns():void
		{
			showTileGridBtn.setSelected(false);
			
			showFindPathGridBtn.setSelected(false);
			
			editPathGridBtn.setSelected(false);
			
			smallMapBtn.setSelected(false);
			
		}
	}
}