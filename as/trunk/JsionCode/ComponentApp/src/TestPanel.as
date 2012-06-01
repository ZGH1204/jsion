package
{
	import flash.display.Sprite;
	
	import jsion.display.ITabPanel;
	
	public class TestPanel extends Sprite implements ITabPanel
	{
		private var m_color:uint;
		public function TestPanel()
		{
			m_color = Math.random() * 0xFFFFFF;
			
			graphics.clear();
			graphics.beginFill(m_color);
			graphics.drawRect(0, 0, 700, 500);
			graphics.endFill();
		}
		
		public function showPanel():void
		{
			trace("showPanel", m_color);
		}
		
		public function hidePanel():void
		{
			trace("hidePanel", m_color);
		}
	}
}