package jsion.rpg.objects
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import jsion.core.loaders.ImageLoader;
	import jsion.rpg.RPGGlobal;
	import jsion.rpg.StaticMethod;
	import jsion.utils.DisposeUtil;

	public class ViewObject
	{
		protected var m_frameWidth:int;
		
		protected var m_frameHeight:int;
		
		public var offsetX:int;
		
		public var offsetY:int;
		
		public var frameTotal:int;
		
		protected var m_fps:int;
		
		public var path:String = "";
		
		public var rootPath:String = "";
		
		
		
		protected var m_ready:Boolean;
		
		protected var m_needMirror:Boolean;
		
		protected var m_bitmapData:BitmapData;
		
		protected var m_bitmapDataMirror:BitmapData;
		
		protected var m_loader:ImageLoader;
		
		
		
		
		protected var m_loop:Boolean = true;
		
		protected var m_loopEnd:Boolean = false;
		
		protected var m_currentFrame:int = -1;
		
		protected var m_frameTimeSpan:int;
		
		protected var m_lastFrameTime:int;
		
		protected var m_renderRect:Rectangle;
		
		
		
		
		
		public function ViewObject(mirror:Boolean = false)
		{
			m_ready = false;
			m_needMirror = mirror;
			m_renderRect = new Rectangle();
		}
		
		public function get frameWidth():int
		{
			return m_frameWidth;
		}
		
		public function get frameHeight():int
		{
			return m_frameHeight;
		}

		public function get fps():int
		{
			return m_fps;
		}
		
		public function get loop():Boolean
		{
			return m_loop;
		}
		
		public function loadBitmapData():void
		{
			if(m_ready || m_bitmapData || m_loader) return;
			
			m_loader = new ImageLoader(path, {root: rootPath});
			
			m_loader.loadAsync(loadCallback);
		}
		
		private function loadCallback(loader:ImageLoader):void
		{
			if(m_loader.isComplete)
			{
				m_bitmapData = Bitmap(m_loader.content).bitmapData;
				
				if(m_frameWidth <= 0 || m_frameHeight <= 0)
				{
					m_frameWidth = m_bitmapData.width;
					m_frameHeight = m_bitmapData.height;
					frameTotal = 1;
					fps = 1;
				}
				
				if(m_needMirror)
				{
					m_bitmapDataMirror = new BitmapData(m_bitmapData.width, m_bitmapData.height, true, 0);
					
					var matrix:Matrix = new Matrix(-1);
					
					m_bitmapDataMirror.draw(m_bitmapData, matrix);
				}
				
				m_ready = true;
			}
			else
			{
				StaticMethod.t("图形资源加载失败", m_loader.uri);
			}
			
			DisposeUtil.free(m_loader);
			m_loader = null;
		}
		
		public function set frameWidth(value:int):void
		{
			m_frameWidth = value;
			m_renderRect.width = m_frameWidth;
		}
		
		public function set frameHeight(value:int):void
		{
			m_frameHeight = value;
			m_renderRect.height = m_frameHeight;
		}
		
		public function set fps(value:int):void
		{
			m_fps = value;
			
			m_currentFrame = -1;
			m_frameTimeSpan = 1000 / m_fps;
		}
		
		public function set loop(value:Boolean):void
		{
			m_loop = value;
			m_loopEnd = false;
			m_currentFrame = -1;
		}
		
		public function onEnterFrame():void
		{
			if((RPGGlobal.TIMER - m_lastFrameTime) >= m_frameTimeSpan && m_loopEnd == false)
			{
				m_currentFrame++;
				
				m_lastFrameTime = RPGGlobal.TIMER;
				
				if(m_currentFrame >= frameTotal) m_loop ? m_currentFrame = 0 : m_loopEnd = true;
			}
		}
		
		public function getRenderRect(line:int = 0):Rectangle
		{
			if(frameTotal == 1)
			{
				m_renderRect.x = 0;
				m_renderRect.y = 0;
			}
			else
			{
				m_renderRect.x = m_currentFrame * m_frameWidth;
				m_renderRect.y = line * m_frameHeight;
				
				if(m_renderRect.x > 0) m_renderRect.x -= offsetX;
				if(m_renderRect.y > 0) m_renderRect.y -= offsetY;
			}
			
			return m_renderRect;
		}
	}
}