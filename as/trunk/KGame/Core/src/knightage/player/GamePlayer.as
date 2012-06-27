package knightage.player
{
	import jsion.IDispose;
	import jsion.utils.DisposeUtil;
	
	import knightage.player.heros.HeroMode;
	
	public class GamePlayer implements IDispose
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
		 * 酒馆上次刷新时间
		 */		
		public var lastRefreshTime:Date;
		
		/**
		 * 酒馆刷新出现的英雄1
		 */		
		public var lastHero1TID:int;
		
		/**
		 * 酒馆刷新出现的英雄2
		 */		
		public var lastHero2TID:int;
		
		/**
		 * 酒馆刷新出现的英雄3
		 */		
		public var lastHero3TID:int;
		
		/**
		 * 英雄Mode
		 */		
		public var heroMode:HeroMode;
		
		public function GamePlayer()
		{
			heroMode = new HeroMode();
			
			super();
		}
		
		public function dispose():void
		{
			DisposeUtil.free(heroMode);
			heroMode = null;
		}
	}
}