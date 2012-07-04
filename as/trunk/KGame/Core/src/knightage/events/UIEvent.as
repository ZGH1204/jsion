package knightage.events
{
	import flash.events.Event;
	
	public class UIEvent extends Event
	{
		/**
		 * 分页改变事件，
		 * data1参数表示当前页码(从1开始)，
		 * data2表示数据的起始索引值(从0开始的索引包含此索引位置的数据)，
		 * data3表示数据的结束索引值(从0开始的索引包含此索引位置的数据)。
		 * 如果通过 setDataList(Array) 方法设置了数据列表 则事件参数 data4 的值对应为当前页的数据列表。
		 */		
		public static const PAGE_CHANGED:String = "pageChanged";
		
		/**
		 * 选中的英雄变更
		 */		
		public static const HERO_SELECTED_CHANGED:String = "heroSelectedChanged";
		
		public var data1:*;
		public var data2:*;
		public var data3:*;
		public var data4:*;
		
		public function UIEvent(type:String, data1:* = null, data2:* = null, data3:* = null, data4:* = null)
		{
			this.data1 = data1;
			this.data2 = data2;
			this.data3 = data3;
			this.data4 = data4;
			
			super(type);
		}
		
		override public function clone():Event
		{
			return new UIEvent(type, data1, data2, data3, data4);
		}
	}
}