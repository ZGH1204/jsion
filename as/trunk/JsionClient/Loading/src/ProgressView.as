package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import jsion.IDispose;
	import jsion.utils.DisposeUtil;
	
	public class ProgressView extends Sprite implements IDispose
	{
		private var m_asset:OtherLoadingAsset;
		
		private var m_width:int;
		
		private var m_targetWidth:int;
		
		public function ProgressView()
		{
			super();
			
			m_targetWidth = 0;
			
			m_asset = new OtherLoadingAsset();
			
			m_width = m_asset.loadingBar.width;
			
			m_asset.loadingBar.width = 1;
			
			addChild(m_asset);
		}
		
		private function __enterFrameHandler(e:Event):void
		{
			// TODO Auto-generated method stub
			
			if((m_targetWidth - m_asset.loadingBar.width) < 1)
			{
				m_asset.loadingBar.width = m_targetWidth;
				
				removeEventListener(Event.ENTER_FRAME, __enterFrameHandler);
				
				if(m_targetWidth == (m_width))
				{
					m_cur = 0;
					m_delay = 5;
					
					addEventListener(Event.ENTER_FRAME, __delayDispatchHandler);
				}
				
				return;
			}
			
			var temp:int = (m_targetWidth - m_asset.loadingBar.width) * .1;
			
			temp = Math.max(temp, 2);
			
			m_asset.loadingBar.width = m_asset.loadingBar.width + temp;
		}
		
		private var m_cur:int;
		private var m_delay:int;
		private var m_callback:Function;
		private function __delayDispatchHandler(e:Event):void
		{
			// TODO Auto-generated method stub
			m_cur++;
			
			if(m_cur > m_delay)
			{
				removeEventListener(Event.ENTER_FRAME, __delayDispatchHandler);
				
				if(m_callback != null) m_callback();
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		public function setCallback(callback:Function):void
		{
			m_callback = callback;
		}
		
		public function updateProgress(bytesLoaded:int, bytesTotal:int):void
		{
			m_targetWidth = bytesLoaded / bytesTotal * m_width;
			
			addEventListener(Event.ENTER_FRAME, __enterFrameHandler);
		}
		
		public function dispose():void
		{
			removeEventListener(Event.ENTER_FRAME, __enterFrameHandler);
			removeEventListener(Event.ENTER_FRAME, __delayDispatchHandler);
			
			DisposeUtil.free(m_asset);
			m_asset = null;
			
			m_callback = null;
		}
	}
}