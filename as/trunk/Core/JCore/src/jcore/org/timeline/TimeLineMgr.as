package jcore.org.timeline
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import jcore.org.message.IMsgReceiver;
	import jcore.org.message.Message;
	import jcore.org.message.MessageMonitor;
	
	import jutils.org.util.InstanceUtil;

	public class TimeLineMgr
	{
		private static var setuped:Boolean;
		
		private static var currentTick:int;
		
		private static var timer:Timer;
		
		private static var msgReceiver:IMsgReceiver;
		
		public function TimeLineMgr()
		{
		}
		
		public static function setup(delay:Number = 1000):void
		{
			if(setuped) return;
			
			setuped = true;
			
			timer = new Timer(1000);
			timer.delay = delay;
			timer.reset();
			currentTick = getTimer();
			timer.addEventListener(TimerEvent.TIMER, __timerHandler);
			
			msgReceiver = new TimeLineReceiver();
			
			//MessageMonitor.registeMsgReceiver(TimeLineDefaultMsg.TimerStart
		}
		
		public static function startTimer(msg:Message):void
		{
			
		}
		
		public static function stopTimer(msg:Message):void
		{
			
		}
		
		public static function setDelay(msg:Message):void
		{
			
		}
		
		private static function __timerHandler(e:TimerEvent):void
		{
			var ticks:int = getTimer() - currentTick;
			var seconds:Number = ticks / 1000;
			
			currentTick += ticks;
			
			MessageMonitor.createAndPostMsg(TimeLineDefaultMsg.TimerTick, "TimeLineMgr", null, ticks, seconds);
		}
	}
}