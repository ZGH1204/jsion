package knightage.player
{
	public class SelfPlayer extends GamePlayer
	{
		/**
		 * 帐号
		 */		
		public var account:String;
		
		/**
		 * 经验
		 */		
		public var experience:int;
		
		/**
		 * 军令
		 */		
		public var orders:int;
		
		/**
		 * 军令上限
		 */		
		public var ordersLimit:int;
		
		/**
		 * 游戏币
		 */		
		public var coins:int;
		
		/**
		 * 游戏币上限
		 */		
		public var coinsLimit:int;
		
		/**
		 * 金币
		 */		
		public var gold:int;
		
		/**
		 * 士气数量
		 */		
		public var soliders:int;
		
		/**
		 * 伤兵数量
		 */		
		public var hurtSoliders:int;
		
		/**
		 * 臣民数
		 */		
		public var peoples:int;
		
		/**
		 * 食物
		 */		
		public var foods:int;
		
		/**
		 * 军团个数
		 */		
		public var legions:int;
		
		/**
		 * 英雄数量
		 */		
		public var heros:int;
		
		/**
		 * 章节ID
		 */		
		public var chapterID:int;
		
		/**
		 * 关卡ID
		 */		
		public var missionsID:int;
		
		/**
		 * 当前阵型
		 */		
		public var currentTeam:int;
		
		/**
		 * 军团信息(军团编号,军团等级,英雄ID,英雄ID......|军团编号,军团等级,英雄ID,英雄ID......)
		 */		
		public var teamStr:String;
		
		/**
		 * 军功
		 */		
		public var exploit:int;
		
		public function SelfPlayer()
		{
			super();
		}
	}
}