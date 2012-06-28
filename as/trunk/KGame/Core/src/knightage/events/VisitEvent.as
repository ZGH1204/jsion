package knightage.events
{
	import flash.events.Event;
	
	import jsion.IDispose;
	
	public class VisitEvent extends Event implements IDispose
	{
//		/**
//		 * 访问好友后回家
//		 */		
//		public static const BACK_HOME:String = "backHome";
		
		/**
		 * 访问好友
		 */		
		public static const VISIT_FRIEND:String = "visitFriend";
		
		/**
		 * 刷新酒馆英雄
		 */		
		public static const REFRESH_TAVERN_HERO:String = "refreshTavernHero";
		
		public var data:*;
		
		public function VisitEvent(type:String, data:*)
		{
			this.data = data;
			
			super(type);
		}
		
		override public function clone():Event
		{
			return new PlayerEvent(type, data);
		}
		
		public function dispose():void
		{
			data = null;
		}
	}
}