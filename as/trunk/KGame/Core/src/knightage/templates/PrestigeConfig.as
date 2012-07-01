package knightage.templates
{
    public class PrestigeConfig extends TemplateInfo
    {

        /**
         * 声望升下一级
         * 所需经验值
         */
        public var Exp:int;

        /**
         * 达到声望等级对
         * 超级英雄刷出的
         * 概率加成
         */
        public var Probability:int;

        /**
         * 升级时获得的
         * 物品列表
         * (用空格隔开)
         */
        public var Goods:String;

    }
}