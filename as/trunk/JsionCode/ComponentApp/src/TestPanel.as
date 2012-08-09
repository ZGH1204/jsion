package
{
	import flash.display.Sprite;
	
	import jsion.display.ITabPanel;
	
	public class TestPanel extends Sprite implements ITabPanel
	{
		private var m_color:uint;
		public function TestPanel(w:int = 700, h:int = 500)
		{
			m_color = Math.random() * 0xFFFFFF;
			
			graphics.clear();
			graphics.beginFill(m_color);
			graphics.drawRect(0, 0, w, h);
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
		
		public function createPanel():void
		{
			// TODO Auto Generated method stub
			
		}
		
	}
}