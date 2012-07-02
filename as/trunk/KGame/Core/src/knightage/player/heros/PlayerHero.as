package knightage.player.heros
{
	import knightage.templates.HeroTemplate;

	public class PlayerHero extends HeroTemplate
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
		 * 当前兵种
		 */		
		public var curSoliderType:int;
		
		/**
		 * 带兵数
		 */		
		public var soliders:int;
		
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
		
		
		
		/**
		 * 攻击力培养保存后的加成值
		 */		
		public var cultivateAttack:int;
		
		/**
		 * 防御力培养保存后的加成值
		 */		
		public var cultivateDefense:int;
		
		/**
		 * 暴击培养保存后的加成值
		 */		
		public var cultivateCrit:int;
		
		
		/**
		 * 攻击力上一次培养未保存的加成值
		 */		
		public var lastCultAttack:int;
		
		/**
		 * 防御力上一次培养未保存的加成值
		 */		
		public var lastCultDefense:int;
		
		/**
		 * 暴击上一次培养未保存的加成值
		 */		
		public var lastCultCrit:int;
	}
}