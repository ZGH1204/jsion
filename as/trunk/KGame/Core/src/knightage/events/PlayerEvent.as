package knightage.events
{
	import flash.events.Event;
	
	import jsion.IDispose;
	
	public class PlayerEvent extends Event implements IDispose
	{
		/**
		 * 建筑升级
		 */		
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
		
		/**
		 * 声望值发生变更
		 */		
		public static const PRESTIGE_CHANGED:String = "prestige";
		
		/**
		 * 豪华派对金币价格累加变更
		 */		
		public static const GRAND_PARTY_PRICE_CHANGED:String = "grandPartyPriceChange"
		
		/**
		 * 刷新酒馆英雄
		 */		
		public static const REFRESH_TAVERN_HERO:String = "refreshTavernHero";
		
		/**
		 * 雇佣英雄
		 */		
		public static const EMPLOY_HERO:String = "employHero";
		
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