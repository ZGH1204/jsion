package jsion
{
	/**
	 * 全局静态常量类
	 * @author Jsion
	 * 
	 */	
	public class Global
	{
		/**
		 * 动作个数
		 */		
		public static const ActionCount:int = 8;
		
		/**
		 * 方向个数
		 */		
		public static const DirCount:int = 8;
		
		/**
		 * 动作名称列表
		 */		
		public static const ActionNames:Array = ["待机动作", "行走动作", "奔跑动作", "攻击动作", "防御动作", "受伤动作", "技能动作", "死亡动作"];
		
		/**
		 * 方向名称列表
		 */		
		public static const DirNames:Array = ["上", "下", "左", "右", "左上", "右上", "左下", "右下"];
		
		/**
		 * 待机动作
		 */		
		public static const NormalMotion:int = 1;
		
		/**
		 * 行走动作
		 */		
		public static const WalkMotion:int = 2;
		
		/**
		 * 奔跑动作
		 */		
		public static const RunMotion:int = 3;
		
		/**
		 * 攻击动作
		 */		
		public static const AttackMotion:int = 4;
		
		/**
		 * 防御动作
		 */		
		public static const DefenseMotion:int = 5;
		
		/**
		 * 受伤动作
		 */		
		public static const HurtMotion:int = 6;
		
		/**
		 * 技能动作
		 */		
		public static const SkillMotion:int = 7;
		
		/**
		 * 死亡动作
		 */		
		public static const DieMotion:int = 8;
		
		
		
		
		/**
		 * 向上
		 */		
		public static const UpWard:int = 1;
		
		/**
		 * 向下
		 */		
		public static const DownWard:int = 2;
		
		/**
		 * 向左
		 */		
		public static const LeftWard:int = 3;
		
		/**
		 * 向右
		 */		
		public static const RightWard:int = 4;
		
		/**
		 * 左上方向
		 */		
		public static const LeftTopWard:int = 5;
		
		/**
		 * 右上方向
		 */		
		public static const RightTopWard:int = 6;
		
		/**
		 * 左下方向
		 */		
		public static const LeftBottomWard:int = 7;
		
		/**
		 * 右下方向
		 */		
		public static const RightBottomWard:int = 8;
	}
}