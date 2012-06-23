package knightage.player.heros
{
	public class PlayerHero
	{
		/**
		 * 玩家ID
		 */		
		public var playerID:int;
		
		/**
		 * 英雄ID
		 */		
		public var heroID:int;
		
		/**
		 * 英雄模板ID
		 */		
		public var templateID:int;
		
		/**
		 * 等级
		 */		
		public var lv:int;
		
		/**
		 * 兵系
		 */		
		public var soliderCategory:int;
		
		/**
		 * 当前兵种
		 */		
		public var curSoliderType:int;
		
		/**
		 * 信仰
		 */		
		public var faith:int;
		
		/**
		 * 是否在阵形中
		 */		
		public var isAtTeam:Boolean;
		
		/**
		 * 阵形编号
		 */		
		public var teamNum:int;
		
		/**
		 * 在阵形中的索引位置
		 */		
		public var teamIndex:int;
		
		/**
		 * 带兵数
		 */		
		public var soliders:int;
		
		/**
		 * 士气
		 */		
		public var morale:int;
		
		/**
		 * 攻击力
		 */		
		public var attack:int;
		
		/**
		 * 防御力
		 */		
		public var defense:int;
		
		/**
		 * 先手值
		 */		
		public var speed:int;
		
		/**
		 * 暴击
		 */		
		public var crit:int;
		
		/**
		 * 格挡
		 */		
		public var parry:int;
		
		/**
		 * 闪避
		 */		
		public var dodge:int;
	}
}