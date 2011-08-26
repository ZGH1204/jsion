package jcore.org.timeline
{
	/**
	 * 时间轴全局唯一公共消息标识(4294966276 - 4294966285)
	 * @author Jsion
	 * 
	 */	
	public class TimeLineDefaultMsg
	{
		/**
		 * 通知Timer组件开始计时
		 * <p><b>消息标识：</b>4294966278</p>
		 */		
		public static const TimerStart:uint = 4294966276;
		
		/**
		 * 通知Timer组件停止计时
		 * <p><b>消息标识：</b>4294966279</p>
		 */		
		public static const TimerStop:uint = 4294966277;
		
		/**
		 * 设置间隔时间
		 * <p><b>wParm：</b>间隔时间,以毫秒为单位.</p>
		 * <p><b>消息标识：</b>4294966277</p>
		 */		
		public static const TimerDelay:uint = 4294966278;
		
		/**
		 * 每过一个指定间隔时刻时发送的消息
		 * <p><b>wParm：</b>真实间隔时间,以毫秒为单位,数据类型int.</p>
		 * <p><b>lParm：</b>真实间隔时间,以秒为单位,数据类型Number.</p>
		 * <p><b>消息标识：</b>4294966276</p>
		 */		
		public static const TimerTick:uint = 4294966279;
	}
}