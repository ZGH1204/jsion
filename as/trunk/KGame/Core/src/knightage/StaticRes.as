package knightage
{
	import flash.display.BitmapData;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.text.StyleSheet;
	import flash.text.TextFormat;
	
	import jsion.Insets;

	public class StaticRes
	{
		/**
		 * 公共按钮点击时的音效
		 */		
		public static const ButtonClickSoundID:String = "008";
		
		/**
		 * 公共按钮默认CSS样式表
		 */		
		public static const ButtonDefaultStyle:StyleSheet = new StyleSheet();
		
		/**
		 * 公共按钮文本默认滤镜
		 */		
		public static const ButtonDefaultFilters:Array = [new GlowFilter(0x412419, 1, 4, 4, 8, 1)];
		
		/**
		 * 公共按钮文本默认样式
		 */		
		public static const ButtonDefaultTextFormat:TextFormat = new TextFormat(null, 15, null, true);
		
		
		
		
		
		
		
		
		
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
		 * 底部好友关系左侧按钮资源
		 */		
		public static const RelationButtonUpBMD:RelationButtonUpAsset = new RelationButtonUpAsset(0, 0);
		
		/**
		 * 关系好友头像框背景
		 */		
		public static const RelationItemBackgroundBMD:RelationIconBGAsset = new RelationIconBGAsset(0, 0);
		
		
		
		/**
		 * 建造建筑的按钮图片资源
		 */		
		public static const BuildCreateBMD:BuildCreateAsset = new BuildCreateAsset(0, 0);
		
		
		/**
		 * 升级建筑的按钮图片资源
		 */		
		public static const BuildUpgradeBMD:BuildUpgradeAsset = new BuildUpgradeAsset(0, 0);
		
		
		
		
		
		public static const ButtonDefaultSelectedUpFilters:Array = [new GlowFilter(0x9900CC, 1, 4, 4, 8, 1)];
		public static const ButtonDefaultSelectedOverFilters:Array = [new GlowFilter(0x9900CC, 1, 4, 4, 8, 1), new ColorMatrixFilter([1, 0, 0, 0, 25,   0, 1, 0, 0, 25,   0, 0, 1, 0, 25,   0, 0, 0, 1, 0])];
		
		
		/**
		 * 白色
		 */		
		public static const WhiteColor:int = 0xFFFFFF;
		
		/**
		 * 文本样式:14号，加粗。
		 */		
		public static const TextFormat14:TextFormat = new TextFormat(null, 14, null, true);
		
		/**
		 * 文本样式:15号，加粗。
		 */		
		public static const TextFormat15:TextFormat = new TextFormat(null, 15, null, true);
		
		/**
		 * 文本样式:18号，加粗。
		 */		
		public static const TextFormat18:TextFormat = new TextFormat(null, 18, null, true);
		
		/**
		 * 描边4像素8强度滤镜。
		 */		
		public static const TextFilters4:Array = [new GlowFilter(0x412419, 1, 4, 4, 8, 1)];
		
		/**
		 * 描边8像素10强度滤镜。
		 */		
		public static const TextFilters8:Array = [new GlowFilter(0x412419, 1, 8, 8, 10, 1)];
		
		/**
		 * 嵌入字体文本样式(字体大小：16，加粗。)
		 */		
		public static const WaWaEmbedTextFormat16:TextFormat = new TextFormat("MyFont1", 16, null, true);
		
		/**
		 * 嵌入字体文本样式(字体大小：22，加粗。)
		 */		
		public static const WaWaEmbedTextFormat22:TextFormat = new TextFormat("MyFont1", 22, null, true);
		
		
		
		/**
		 * 嵌入字体文本样式(字体大小：15。)
		 */		
		public static const HaiBaoEmbedTextFormat15:TextFormat = new TextFormat("MyFont2", 15, null);
		
		/**
		 * 嵌入字体文本样式(字体大小：20。)
		 */		
		public static const HaiBaoEmbedTextFormat20:TextFormat = new TextFormat("MyFont2", 20, null);
		
		
		
		
		/**
		 * 酒馆英雄信息背景资源
		 */		
		public static const TavernHeroInfoBackgroundBMD:TavernHeroPropAsset = new TavernHeroPropAsset(0, 0);
		
		
		/**
		 * 英雄界面棕色背景图片资源
		 */		
		public static const HeroBackgroundBMD:HeroBackgroundAsset = new HeroBackgroundAsset(0, 0);
		/**
		 * 英雄界面棕色背景图片九宫格划分参数
		 */		
		public static const HeroBackgroundInsets:Insets = new Insets(20, 20, 20, 20);
		
		/**
		 * 装备背景框
		 */		
		public static const EquipItemBackgroundBMD:EquipItemBackgroundAsset = new EquipItemBackgroundAsset(0, 0);
		
		
		/**
		 * 英雄列表背景图片资源
		 */		
		public static const HeroListBackgroundBMD:HeroListBackgroundAsset = new HeroListBackgroundAsset(0, 0);
		/**
		 * 英雄列表背景图片九宫格参数
		 */		
		public static const HeroListBackgroundInset:Insets = new Insets(20, 20, 20, 20);
		
		
		/**
		 * 英雄列表Item背景图片资源
		 */		
		public static const HeroListItemBGBMD:HeroListItemAsset = new HeroListItemAsset(0, 0);
		
		/**
		 * 向左的翻页箭头
		 */		
		public static const LeftArrowBMD:LeftArrowAsset = new LeftArrowAsset(0, 0);
		/**
		 * 向右的翻页箭头
		 */		
		public static const RightArrowBMD:RightArrowAsset = new RightArrowAsset(0, 0);
		/**
		 * 英雄兵种背景框图片资源
		 */		
		public static const HeroSoliderBackgroundBMD:SoliderItemBackgroundAsset = new SoliderItemBackgroundAsset(0, 0);
	}
}