package jsion.rpg.editor.tops
{
	import jsion.rpg.editor.controls.FileNewFrame;
	import jsion.utils.StringUtil;
	
	import org.aswing.JButton;
	import org.aswing.JToolBar;
	import org.aswing.LoadIcon;
	import org.aswing.event.AWEvent;
	
	public class ToolBox extends JToolBar
	{
		private static const NewMapTipText:String = "新建";
		private static const OpenMapTipText:String = "打开";
		private static const SaveMapTipText:String = "保存";
		
		private var m_newMapBtn:JButton;
		
		public function ToolBox()
		{
			super(JToolBar.HORIZONTAL, 2);
			
			initialize();
		}
		
		private function initialize():void
		{
			m_newMapBtn = createButton("icons/NewMap.png", __newMapBtnClickHandler, NewMapTipText);
		}
		
		private function __newMapBtnClickHandler(e:AWEvent):void
		{
			new FileNewFrame().show();
		}
		
		private function createButton(iconPath:String, clickHandler:Function = null, toolTipText:String = null):JButton
		{
			var btn:JButton = new JButton(null, new LoadIcon(iconPath, 18, 14));
			
			if(StringUtil.isNotNullOrEmpty(toolTipText)) btn.setToolTipText(toolTipText);
			
			if(clickHandler != null) btn.addActionListener(clickHandler);
			
			append(btn);
			
			return btn;
		}
	}
}