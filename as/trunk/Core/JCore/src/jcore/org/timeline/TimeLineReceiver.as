package jcore.org.timeline
{
	import jcore.org.message.IMsgReceiver;
	import jcore.org.message.Message;
	import jcore.org.moduls.DefaultModule;
	import jcore.org.moduls.ModuleInfo;
	
	public class TimeLineReceiver extends DefaultModule
	{
		public function TimeLineReceiver()
		{
			super(new ModuleInfo());
		}
		
		override public function get id():String
		{
			return "TimeLineRcver";
		}
		
		override protected function install(msg:Message):Object
		{
			registeMsgHandleFn(TimeLineDefaultMsg.TimerStart, TimeLineMgr.startTimer);
			registeMsgHandleFn(TimeLineDefaultMsg.TimerStop, TimeLineMgr.stopTimer);
			registeMsgHandleFn(TimeLineDefaultMsg.TimerDelay, TimeLineMgr.setDelay);
			
			return super.install(msg);
		}
		
		override protected function uninstall(msg:Message):Object
		{
			removeMsgHandleFn(TimeLineDefaultMsg.TimerStart);
			removeMsgHandleFn(TimeLineDefaultMsg.TimerStop);
			removeMsgHandleFn(TimeLineDefaultMsg.TimerDelay);
			
			return super.uninstall(msg);
		}
	}
}