package knightage.events
{
	import flash.events.Event;
	
	import jsion.IDispose;
	
	public class PlayerEvent extends Event implements IDispose
	{
		public static const BUILD_UPGRADE:String = "buildUpgrade";
		
		/**
		 * 玩家经验池发生变更
		 */		
		public static const EXP_CHANGED:String = "expChanged";
		
		/**
		 * 玩家游戏币发生变更
		 */		
		public static const COIN_CHANGED:String = "coinChanged";
		
		/**
		 * 玩家金币发生变更
		 */		
		public static const GOLD_CHANGED:String = "goldChanged";
		
		/**
		 * 玩家总士兵数发生变更
		 */		
		public static const SOLIDER_CHANGED:String = "soliderChanged";
		
		/**
		 * 玩家食物发生变更
		 */		
		public static const FOOD_CHANGED:String = "foodChanged";
		
		/**
		 * 玩家军令数发生变更
		 */		
		public static const ORDER_CHANGED:String = "orderChanged";
		
		public var data:*;
		
		public function PlayerEvent(type:String, data:*)
		{
			this.data = data;
			
			super(type, bubbles, cancelable);
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