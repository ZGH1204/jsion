package jsion.timer
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import jsion.utils.ArrayUtil;

	/**
	 * Timer管理器(每秒执行)
	 * @author Jsion
	 * 
	 */	
	public class TimerMgr
	{
		private static var m_timer:Timer;
		
		private static var m_readyList:Array;
		
		private static var m_list:Array;
		
		private static var m_removeList:Array;
		
		private static var m_elapsing:Boolean;
		
		public function TimerMgr()
		{
		}
		
		/**
		 * 初始化
		 */		
		public static function setup():void
		{
			if(m_list) return;
			
			m_readyList = [];
			m_list = [];
			m_removeList = [];
			
			m_elapsing = false;
			
			m_timer = new Timer(1000);
			
			m_timer.addEventListener(TimerEvent.TIMER, __timerHandler);
			
			start();
		}
		
		private static function __timerHandler(e:TimerEvent):void
		{
			// TODO Auto-generated method stub
			
			m_elapsing = true;
			
			var i:int;
			
			for(i = 0; i < m_list.length; i++)
			{
				if(ArrayUtil.containsValue(m_removeList, m_list[i]))
				{
					continue;
				}
				
				ITimer(m_list[i]).elapsed();
			}
			
			m_elapsing = false;
			
			for(i = 0; i < m_removeList.length; i++)
			{
				ArrayUtil.remove(m_list, m_removeList[i]);
			}
			
			ArrayUtil.removeAll(m_removeList);
			
			while(m_readyList.length > 0)
			{
				ArrayUtil.push(m_list, m_readyList.shift());
			}
		}
		
		/**
		 * 启动
		 */		
		public static function start():void
		{
			if(m_timer == null || m_timer.running) return;
			
			m_elapsing = false;
			
			m_timer.start();
		}
		
		/**
		 * 停止
		 */		
		public static function stop():void
		{
			if(m_timer == null || m_timer.running == false) return;
			
			m_timer.reset();
		}
		
		/**
		 * 暂停
		 */		
		public static function pause():void
		{
			if(m_timer == null || m_timer.running == false) return;
			
			m_timer.stop();
		}
		
		/**
		 * 继续
		 */		
		public static function resume():void
		{
			if(m_timer == null || m_timer.running) return;
			
			m_timer.start();
		}
		
		/**
		 * 添加执行器
		 * @param timer
		 * 
		 */		
		public static function addTimer(timer:ITimer):void
		{
			if(timer == null) return;
			
			if(m_timer && m_timer.running)
			{
				ArrayUtil.push(m_readyList, timer);
			}
			else
			{
				ArrayUtil.push(m_list, timer);
			}
		}
		
		/**
		 * 移除执行器
		 * @param timer
		 * 
		 */		
		public static function removeTimer(timer:ITimer):void
		{
			if(timer == null) return;
			
			if(m_elapsing)
			{
				ArrayUtil.push(m_removeList, timer);
			}
			else
			{
				ArrayUtil.remove(m_list, timer);
			}
		}
	}
}