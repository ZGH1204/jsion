package render.core.copies
{
	import flash.display.BitmapData;

	public class BaseGame
	{
		private var m_objects:Array;
		
		private var m_buffer:BitmapData;
		
		public function BaseGame(w:int, h:int)
		{
			m_objects = [];
			
			m_buffer = new BitmapData(w, h, true, 0);
		}
		
		public function get buffer():BitmapData
		{
			return m_buffer;
		}
		
		
		public function render():void
		{
			for each(var obj:GameObject in m_objects)
			{
				obj.render(m_buffer);
			}
		}
	}
}