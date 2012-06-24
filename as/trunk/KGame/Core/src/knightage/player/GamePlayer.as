package knightage.player
{
	import flash.events.IEventDispatcher;
	
	import jsion.events.JsionEventDispatcher;
	
	import knightage.player.heros.HeroMode;
	
	public class GamePlayer extends JsionEventDispatcher
	{
		/**
		 * 玩家ID
		 */		
		public var playerID:int;
		
		/**
		 * 昵称
		 */		
		public var nickName:String;
		
		/**
		 * 城堡等级模板ID(即人物等级)
		 */		
		public var castleTID:int;
		
		/**
		 * 农田等级模板ID
		 */		
		public var farmlandTID:int;
		
		/**
		 * 酒馆等级模板ID
		 */		
		public var tavernTID:int;
		
		/**
		 * 兵营等级模板ID
		 */		
		public var barracksTID:int;
		
		/**
		 * 训练场等级模板ID
		 */		
		public var trainingTID:int;
		
		/**
		 * 市场等级模板ID
		 */		
		public var marketTID:int;
		
		/**
		 * 监狱等级模板ID
		 */		
		public var prisonTID:int;
		
		/**
		 * 占卜屋等级模板ID
		 */		
		public var divineTID:int;
		
		/**
		 * 潘朵拉等级模板ID
		 */		
		public var pandoraTID:int;
		
		/**
		 * 铁匠铺等级模板ID
		 */		
		public var smithyTID:int;
		
		/**
		 * 研究学院等级模板ID
		 */		
		public var collegeTID:int;
		
		/**
		 * 雕像等级模板ID
		 */		
		public var efigyTID:int;
		
		/**
		 * 英雄Mode
		 */		
		public var heroMode:HeroMode;
		
		public function GamePlayer()
		{
			heroMode = new HeroMode();
			
			super();
		}
	}
}