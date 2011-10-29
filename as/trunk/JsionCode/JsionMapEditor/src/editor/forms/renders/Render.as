package editor.forms.renders
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import jsion.core.loaders.ImageLoader;
	import jsion.rpg.engine.EngineGlobal;
	import jsion.utils.DisposeUtil;
	import jsion.utils.PathUtil;

	public class Render
	{
		public var bitmapData:BitmapData;
		
		public var renderer:Renderer;
		
		protected var m_renderInfo:RenderInfo;
		
		protected var m_currentFrame:int = -1;
		
		protected var m_currentFrameRight:int;
		
		protected var m_currentFrameBottom:int;
		
		protected var m_lastFrame:int;
		
		protected var m_playTimeSpan:int;
		
		protected var m_lastFrameTime:int;
		
		protected var m_destPoint:Point = new Point();
		
		protected var m_renderRect:Rectangle = new Rectangle();
		
		protected var m_tempRect:Rectangle = new Rectangle();
		
		public function Render()
		{
		}
		
		public function render(bmd:BitmapData):void
		{
			if(bitmapData && (EngineGlobal.Timer - m_lastFrameTime) >= m_playTimeSpan)
			{
				m_currentFrame++;
				
				if(m_currentFrame >= m_renderInfo.frameTotal)
				{
					m_currentFrame = 0;
				}
				
				
				m_renderRect.x = m_currentFrame * m_renderRect.width;
				if(m_renderRect.x >= bitmapData.width)
				{
					m_renderRect.x = 0;
					
					m_renderRect.y += m_renderRect.height;
				}
				
				
				bmd.copyPixels(bitmapData, m_renderRect, m_destPoint, null, null, true);
			}
		}
		
		public function get startRect():Rectangle
		{
			m_tempRect.x = 0;
			m_tempRect.y = 0;
			m_tempRect.width = m_renderRect.width;
			m_tempRect.height = m_renderRect.height;
			
			return m_tempRect;
		}
		
		public function get renderInfo():RenderInfo
		{
			return m_renderInfo;
		}
		
		public function set renderInfo(value:RenderInfo):void
		{
			m_renderInfo = value;
			
			m_currentFrame = -1;
			m_lastFrame = 0;
			m_playTimeSpan = 1000 / m_renderInfo.fps;
			m_lastFrameTime = EngineGlobal.Timer;
			
			m_renderRect.x = 0;
			m_renderRect.y = 0;
			m_renderRect.width = m_renderInfo.frameWidth;
			m_renderRect.height = m_renderInfo.frameHeight;
			
			m_destPoint.x = (renderer.width - m_renderInfo.frameWidth) / 2;
			m_destPoint.y = (renderer.height - m_renderInfo.frameHeight) / 2;
			
			//TODO:可以设置成默认位图数据
			DisposeUtil.free(bitmapData);
			bitmapData = null;
			
			var file:File = new File(PathUtil.combinPath(JsionEditor.getMapAssetRoot(), m_renderInfo.path));
			
			if(file.exists == false)
			{
				throw new Error("资源不存在");
				return;
			}
			
			var bytes:ByteArray = new ByteArray();
			
			var fs:FileStream = new FileStream();
			
			fs.open(file, FileMode.READ);
			fs.readBytes(bytes);
			fs.close();
			
			new ImageLoader(file.nativePath).loadAsync(loadCallback);
		}
		
		private function loadCallback(loader:ImageLoader):void
		{
			bitmapData = Bitmap(loader.content).bitmapData;
			
			DisposeUtil.free(loader);
		}
	}
}