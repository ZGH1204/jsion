package knightage
{
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;

	public class StaticRes
	{
		/**
		 * 按钮点击时的音效
		 */		
		public static const ButtonClickSoundID:String = "008";
		
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
		
		/**
		 * 底部好友关系左侧按钮资源
		 */		
		public static const RelationButtonUpBMD:RelationButtonUpAsset = new RelationButtonUpAsset(0, 0);
		
		/**
		 * 底部UI数字显示颜色
		 */		
		public static const BottomUINumColor:uint = 0xFFFFFF;
		
		/**
		 * 底部UI数字显示文本样式
		 */		
		public static const BottomUINumTextFormat:TextFormat = new TextFormat(null, 16);
		/**
		 * 底部UI数字显示滤镜
		 */		
		public static const BottomUINumFilters:Array = [new GlowFilter(0x412419, 1, 4, 4, 8, 1)];
		
		/**
		 * 关系好友头像框背景
		 */		
		public static const RelationItemBackgroundBMD:RelationIconBGAsset = new RelationIconBGAsset(0, 0);
	}
}