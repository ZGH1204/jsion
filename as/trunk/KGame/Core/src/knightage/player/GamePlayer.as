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
		 * 等级
		 */		
		public var grade:int;
		
		/**
		 * 农田等级模板ID
		 */		
		public var farmlandTID:int;
		
		/**
		 * 民居等级模板ID
		 */		
		public var residenceTID:int;
		
		/**
		 * 兵营等级模板ID
		 */		
		public var barracksTID:int;
		
		/**
		 * 教堂等级模板ID
		 */		
		public var churchTID:int;
		
		/**
		 * 国库等级模板ID
		 */		
		public var treasuryTID:int;
		
		/**
		 * 训练场等级模板ID
		 */		
		public var trainingTID:int;
		
		/**
		 * 潘朵拉等级模板ID
		 */		
		public var pandoraTID:int;
		
		/**
		 * 铁匠铺等级模板ID
		 */		
		public var blacksmithTID:int;
		
		/**
		 * 占卜屋等级模板ID
		 */		
		public var divinationTID:int;
		
		/**
		 * 酒馆等级模板ID
		 */		
		public var pubTID:int;
		
		/**
		 * 市场等级模板ID
		 */		
		public var marketTID:int;
		
		/**
		 * 监狱等级模板ID
		 */		
		public var prisonTID:int;
		
		
		public var heroMode:HeroMode;
		
		public function GamePlayer()
		{
			heroMode = new HeroMode();
			
			super();
		}
	}
}