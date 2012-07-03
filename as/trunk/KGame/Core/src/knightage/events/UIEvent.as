package knightage.events
{
	import flash.events.Event;
	
	public class UIEvent extends Event
	{
		/**
		 * 分页改变事件，data1参数表示当前页码(从1开始)，data2表示数据的起始索引值(从0开始)，data3表示数据的结束索引值(从0开始)。
		 */		
		public static const PAGE_CHANGED:String = "pageChanged";
		
		public var data1:*;
		public var data2:*;
		public var data3:*;
		
		public function UIEvent(type:String, data1:* = null, data2:* = null, data3:* = null)
		{
			this.data1 = data1;
			this.data2 = data2;
			this.data3 = data3;
			
			super(type);
		}
		
		override public function clone():Event
		{
			return new UIEvent(type, data1, data2, data3);
		}
	}
}