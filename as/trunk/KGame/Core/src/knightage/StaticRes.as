package knightage
{
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;

	public class StaticRes
	{
		/**
		 * 城堡提升下一级所需要经验值列表
		 */		
		public static const CastleUpGradeExp:Array = [0, 100, 400, 900, 1600, 2500, 3600, 4900, 6400, 8100, 10000, 12100, 14400, 16900, 19600, 22500, 25600, 28900, 32400, 36100, 40000, 44100, 48400, 52900, 57600, 62500, 67600, 72900, 78400, 84100, 90000, 96100, 102400, 108900, 115600, 122500, 129600, 136900, 144400, 152100, 160000, 168100, 176400, 184900, 193600, 202500, 211600, 220900, 230400, 240100, 250000, 260100, 270400, 280900, 291600, 302500, 313600, 324900, 336400, 348100, 360000, 372100, 384400, 396900, 409600, 422500, 435600, 448900, 462400, 476100, 490000, 504100, 518400, 532900, 547600, 562500, 577600, 592900, 608400, 624100, 640000, 656100, 672400, 688900, 705600, 722500, 739600, 756900, 774400, 792100, 810000, 828100, 846400, 864900, 883600, 902500, 921600, 940900, 960400, 980100, 1000000];
		
		/**
		 * TopUI等级背景图标
		 */		
		public static const LvIcon:LevelIcon = new LevelIcon(0, 0);
		
		/**
		 * TopUI游戏币小图标
		 */		
		public static const CoinsIcon:CoinIcon = new CoinIcon(0, 0);
		
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
		 * TopUI军令小图标
		 */		
		public static const OrderIcon:OrdersIcon = new OrdersIcon(0, 0);
		
		/**
		 * 进度条资源
		 */		
		public static const ProgressBarBMD:ProgressBarAsset = new ProgressBarAsset(0, 0);
		
		
		
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