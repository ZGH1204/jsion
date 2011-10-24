package editor
{
	import org.aswing.JButton;
	import org.aswing.JPanel;
	import org.aswing.LayoutManager;
	import org.aswing.SoftBoxLayout;
	import org.aswing.event.AWEvent;
	
	public class EditorTool extends JPanel
	{
		private static const FindPathGrid:String = "寻路格子";
		
		private var mapEditor:JsionMapEditor;
		
		public function EditorTool(owner:JsionMapEditor)
		{
			mapEditor = owner;
			
			super(new SoftBoxLayout(SoftBoxLayout.X_AXIS, 5));
			
			var btn:JButton;
			
			btn = new JButton(FindPathGrid);
			btn.addActionListener(onItemClick);
			append(btn);
		}
		
		private function onItemClick(e:AWEvent):void
		{
			var btn:JButton = e.currentTarget as JButton;
			
			switch(btn.getText())
			{
				case FindPathGrid:
					
					break;
				default:
					trace(btn.getText());
					break;
			}
		}
	}
}