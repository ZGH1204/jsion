package knightage.hall.tavern
{
	import flash.events.Event;
	
	import jsion.display.Label;
	import jsion.utils.DateUtil;
	
	import knightage.StaticRes;
	import knightage.timer.ITimer;
	import knightage.timer.TimerMgr;
	
	public class CountDown extends Label implements ITimer
	{
		private var m_seconds:int;
		
		public function CountDown()
		{
			super();
		}
		
		override protected function configUI():void
		{
			beginChanges();
			text = "00:00:00";
			embedFonts = true;
			textColor = StaticRes.WhiteColor;
			textFormat = StaticRes.HaiBaoEmbedTextFormat20;
			filters = StaticRes.TextFilters4;
			commitChanges();
		}
		
		public function setSeconds(value:int):void
		{
			m_seconds = value;
			
			if(m_seconds > 0)
			{
				TimerMgr.addTimer(this);
			}
			else
			{
				m_seconds = 0;
				
				TimerMgr.removeTimer(this);
				
				dispatchEvent(new Event(Event.COMPLETE));
			}
			
			refreshView();
		}
		
		public function elapsed():void
		{
			// TODO Auto Generated method stub
			m_seconds -= 1;
			
			if(m_seconds <= 0)
			{
				m_seconds = 0;
				
				TimerMgr.removeTimer(this);
				
				dispatchEvent(new Event(Event.COMPLETE));
			}
			
			refreshView();
		}
		
		private function refreshView():void
		{
			if(m_seconds < 0) m_seconds = 0;
			
			text = DateUtil.getTimeStr(m_seconds);
		}
		
		override public function dispose():void
		{
			TimerMgr.removeTimer(this);
			
			super.dispose();
		}
	}
}