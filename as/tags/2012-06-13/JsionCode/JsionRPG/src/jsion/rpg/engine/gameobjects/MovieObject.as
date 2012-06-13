package jsion.rpg.engine.gameobjects
{
	import flash.geom.Rectangle;
	
	import jsion.rpg.engine.EngineGlobal;
	import jsion.rpg.engine.graphics.GraphicResource;
	
	public class MovieObject extends GameObject
	{
		protected var m_currentFrame:int = -1;
		
		protected var m_lastFrame:int;
		
		protected var m_playTimeSpan:int;
		
		protected var m_lastFrameTime:int;
		
		protected var m_loop:Boolean;
		
		/**
		 * 指示非循环播放是否结束
		 */		
		protected var m_loopEnd:Boolean;
		
		public function MovieObject()
		{
			m_loop = true;
			super();
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
		
		/**
		 * 是否循环播放
		 */
		public function get loop():Boolean
		{
			return m_loop;
		}
		
		/**
		 * @private
		 */
		public function set loop(value:Boolean):void
		{
			m_loop = value;
			m_loopEnd = false;
		}

		override public function set graphicResource(value:GraphicResource):void
		{
			super.graphicResource = value;
			
			m_currentFrame = -1;
			m_lastFrame = 0;
			m_playTimeSpan = 1000 / graphicResource.fps;
			m_lastFrameTime = 0;
		}
		
		override public function renderMe():void
		{
			onEnterFrame();
			
			super.renderMe();
		}
		
		protected function onEnterFrame():void
		{
			if((EngineGlobal.Timer - m_lastFrameTime) >= m_playTimeSpan && m_loopEnd == false)
			{
				m_lastFrame = m_currentFrame;
				
				m_lastFrameTime = EngineGlobal.Timer;
				
				m_currentFrame++;
				
				if(m_currentFrame >= graphicResource.frameTotal)
				{
					m_loop ? m_currentFrame = 0 : m_loopEnd = true;
				}
			}
		}
		
		override public function get renderRect():Rectangle
		{
			if(graphicResource.frameTotal == 1)
			{
				return super.renderRect;
			}
//			else if(graphicResource.bitmapData)
//			{
				m_tempRect.x = m_currentFrame * graphicResource.frameWidth;
				
				if(m_tempRect.x > 0) m_tempRect.x -= graphicResource.offsetX;
				
//				if(m_tempRect.x >= graphicResource.bitmapData.width)
//				{
//					m_tempRect.x = 0;
//					
//					m_tempRect.y += graphicResource.frameHeight;
//					
//					if(m_tempRect.y > 0) m_tempRect.y - graphicResource.offsetY;
//					
//					if(m_tempRect.y >= graphicResource.bitmapData.height) m_tempRect.y = 0;
//				}
				
				m_tempRect.width = graphicResource.frameWidth;
				m_tempRect.height = graphicResource.frameHeight;
//			}
//			else if(graphicResource.bitmapDataDefault)
//			{
//				m_tempRect.x = 0;
//				m_tempRect.y = 0;
//				m_tempRect.width = graphicResource.bitmapDataDefault.width;
//				m_tempRect.height = graphicResource.bitmapDataDefault.height;
//			}
//			else
//			{
//				m_tempRect.x = 0;
//				m_tempRect.y = 0;
//				m_tempRect.width = 0;
//				m_tempRect.height = 0;
//			}
			
			return m_tempRect;
		}
	}
}