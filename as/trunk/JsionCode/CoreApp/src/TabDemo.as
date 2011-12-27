package
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import jsion.components.ITab;
	import jsion.components.JButton;
	import jsion.components.JToggleButton;
	import jsion.components.RadioButton;
	
	public class TabDemo extends Sprite implements ITab
	{
		private var m_tabLabel:String;
		
		public function TabDemo(tabLabel:String, color:uint = 0x0)
		{
			m_tabLabel = tabLabel;
			
			super();
			
			graphics.clear();
			graphics.beginFill(color);
			graphics.drawRect(0, 0, 600, 300);
			graphics.endFill();
		}
		
		public function getTabButton():JToggleButton
		{
			var btn:JToggleButton = new JToggleButton(m_tabLabel);
			
			var sprite:Sprite = new Sprite();
			sprite.graphics.clear();
			sprite.graphics.beginFill(0x336699);
			sprite.graphics.drawRect(0, 0, 80, 25);
			sprite.graphics.endFill();
			btn.setUnSelectedStyle(RadioButton.UP_IMG, sprite);
			
			sprite = new Sprite();
			sprite.graphics.clear();
			sprite.graphics.beginFill(0xFF0000);
			sprite.graphics.drawRect(0, 0, 80, 25);
			sprite.graphics.endFill();
			btn.setSelectedStyle(JRadioButton.UP_IMG, sprite);
			
			return btn;
		}
		
		public function getTabPane():DisplayObject
		{
			return this;
		}
		
		public function onShowPane():void
		{
		}
	}
}