package knightage.templates
{
    public class TavernConfig extends TemplateInfo
    {

        /**
         * 普通派对游戏币价格
         */
        public var CoinPartyPrice:int;

        /**
         * 豪华派对金币价格
         */
        public var GoldPartyPrice:int;

        /**
         * 豪华派对每次
         * 金币累加值
         */
        public var GrandGoldStep:int;

        /**
         * 举行普通派对时
         * 增加的声望值
         */
        public var Prestige:int;

        /**
         * 举行豪华派对时
         * 增加的声望值
         */
        public var GrandPrestige:int;

        /**
         * 品质1英雄的
         * 刷新概率
         */
        public var Quality1:int;

        /**
         * 品质2英雄的
         * 刷新概率
         */
        public var Quality2:int;

        /**
         * 品质3英雄的
         * 刷新概率
         */
        public var Quality3:int;

        /**
         * 品质4英雄的
         * 刷新概率
         */
        public var Quality4:int;

        /**
         * 品质5英雄的
         * 刷新概率
         */
        public var Quality5:int;

        /**
         * 品质6英雄的
         * 刷新概率
         */
        public var Quality6:int;

        /**
         * 6个品质的权重值总和
         * (程序计算 请填0)
         */
        public var Weight:int;

        /**
         * 开放的特殊英雄
         * 模板ID列表
         * (用空格隔开)
         */
        public var SpecialHeros:String;

    }
}