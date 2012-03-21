package render.core.copies
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;

	public class BaseGame
	{
		protected var m_objects:Array;
		
		protected var m_bitmapData:BitmapData;
		
		protected var m_buffer:BitmapData;
		
		protected var m_started:Boolean;
		
		private var m_sprite:Sprite;
		
		public function BaseGame(w:int, h:int)
		{
			m_started = false;
			
			m_objects = [];
			
			m_bitmapData = new BitmapData(w, h, true, 0);
			m_buffer = new BitmapData(w, h, true, 0);
			
			m_sprite = new Sprite();
		}
		
		public function get bitmapData():BitmapData
		{
			return m_bitmapData;
		}
		
		public function addObject(obj:GameObject):void
		{
			if(m_objects.indexOf(obj) == -1)
			{
				m_objects.push(obj);
			}
		}
		
		public function start():void
		{
			if(m_started == false)
			{
				m_started = true;
				
				m_sprite.addEventListener(Event.ENTER_FRAME, __enterFrameHandler);
			}
		}
		
		public function stop():void
		{
			if(m_started)
			{
				m_sprite.removeEventListener(Event.ENTER_FRAME, __enterFrameHandler);
			}
		}
		
		private function __enterFrameHandler(e:Event):void
		{
			render();
		}
		
		public function render():void
		{
			var obj:GameObject;
			
			m_objects.sortOn("zIndex", Array.NUMERIC);
			
			m_bitmapData.lock();
			
			for each(obj in m_objects)
			{
				obj.clear(m_bitmapData, m_buffer);
			}
			
			for each(obj in m_objects)
			{
				obj.render(m_bitmapData, m_buffer);
			}
			
			m_bitmapData.unlock();
		}
	}
}