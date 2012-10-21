package tool.pngpacker
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import jsion.IDispose;
	
	public class FPSTimer implements IDispose
	{
		private var m_packerWin:PNGPackerWindow;
		
		private var m_timer:Timer;
		
		public function FPSTimer(packerWin:PNGPackerWindow)
		{
			m_packerWin = packerWin;
			
			start();
		}
		
		public function start(fps:int = 30):void
		{
			resetTimer(fps);
		}
		
		protected function __timerHandler(e:TimerEvent):void
		{
			//trace("FPS");
			if(m_packerWin) m_packerWin.onFPSTimerHandler();
		}
		
		public function resetTimer(fps:Number):void
		{
			clearTimer();
			
			m_timer = new Timer(1000 / fps);
			
			m_timer.addEventListener(TimerEvent.TIMER, __timerHandler);
			
			m_timer.start();
		}
		
		public function clearTimer():void
		{
			if(m_timer)
			{
				m_timer.reset();
				m_timer.removeEventListener(TimerEvent.TIMER, __timerHandler);
				m_timer = null;
			}
		}
		
		public function dispose():void
		{
			clearTimer();
			
			m_packerWin = null;
		}
	}
}