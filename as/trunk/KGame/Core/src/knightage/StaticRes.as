package knightage
{
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;

	public class StaticRes
	{
		/**
		 * TopUI等级背景图标
		 */		
		public static const LvIcon:LevelIcon = new LevelIcon(0, 0);
		
		/**
		 * TopUI游戏币小图标
		 */		
		public static const CoinIcon:GoldIcon = new GoldIcon(0, 0);
		
		/**
		 * TopUI金币小图标
		 */		
		public static const GoldsIcon:GoldIcon = new GoldIcon(0, 0);
		
		/**
		 * TopUI士兵小图标
		 */		
		public static const SolidersIcon:SoliderIcon = new SoliderIcon(0, 0);
		
		/**
		 * TopUI食物小图标
		 */		
		public static const FoodsIcon:FoodIcon = new FoodIcon(0, 0);
		
		
		
		
		/**
		 * 顶部UI数字显示滤镜
		 */		
		public static const TopUINumFilters:Array = [new GlowFilter(0x412419, 1, 4, 4, 8, 1)];
		
		/**
		 * 顶部UI数字显示颜色
		 */		
		public static const TopUINumColor:uint = 0xFFFFFF;
		
		/**
		 * 顶部UI数字显示文本样式
		 */		
		public static const TopUINumTextFormat:TextFormat = new TextFormat(null, 16);
	}
}