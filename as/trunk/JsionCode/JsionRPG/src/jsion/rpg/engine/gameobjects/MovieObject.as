package jsion.rpg.engine.gameobjects
{
	import flash.geom.Rectangle;
	
	import jsion.rpg.engine.EngineGlobal;

	public class MovieObject extends GameObject
	{
		protected var m_currentFrame:int;
		
		protected var m_lastFrame:int;
		
		protected var m_frameTotal:int;
		
		protected var m_loop:Boolean;
		
		protected var m_playEnd:Boolean;
		
		protected var m_playTimeSpan:int;
		
		protected var m_lastFrameTime:int;
		
		public function MovieObject()
		{
			m_lastFrameTime = EngineGlobal.Timer;
			super();
		}
		
		protected function onEnterFrame():void
		{
			if(m_graphics == null || m_graphics.fps == 0) return;
			
			if((EngineGlobal.Timer - m_lastFrameTime) >= m_playTimeSpan && m_playEnd == false)
			{
				m_lastFrameTime = EngineGlobal.Timer;
				m_lastFrame = m_currentFrame;
				
				m_currentFrame++;
				
				if(m_currentFrame >= m_graphics.getFrameTotal(Math.abs(m_direction)) - 1)
				{
					m_loop ? m_currentFrame = 0 : m_playEnd = true;
				}
			}
		}
		
		public function get currentFrame():int
		{
			return m_currentFrame;
		}
		
		public function set currentFrame(value:int):void
		{
			m_currentFrame = value;
		}
		
		public function get lastFrame():int
		{
			return m_lastFrame;
		}
		
		public function get playEnd():Boolean
		{
			return m_playEnd;
		}
		
		public function get loop():Boolean
		{
			return m_loop;
		}
		
		public function set loop(value:Boolean):void
		{
			m_loop = value;
		}
		
		override public function set graphics(value:GraphicResources):void
		{
			super.graphics = value;
			
			//if(m_graphics == null) return;
			
			m_playTimeSpan = 1000 / m_graphics.fps;
		}
		
		override public function get renderRect():Rectangle
		{
			if(m_graphics.hFrameTotal == 1) return super.renderRect;
			
			m_tempRect.x = m_currentFrame * m_graphics.frameWidth;
			m_tempRect.y = Math.abs(m_direction) * m_graphics.frameHeight;
			m_tempRect.width = m_graphics.frameWidth;
			m_tempRect.height = m_graphics.frameHeight;
			
			return m_tempRect;
		}
	}
}