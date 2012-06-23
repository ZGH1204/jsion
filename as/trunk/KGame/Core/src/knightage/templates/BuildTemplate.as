package knightage.templates
{
    public class BuildTemplate extends TemplateInfo
    {

        /**
         * 图片地址
         */
        public var profileURL:String;

        /**
         * 建筑类型
         */
        public var BuildType:int;

        /**
         * 等级
         */
        public var Lv:int;

        /**
         * 产量
         */
        public var Yield:int;

        /**
         * 单次消耗游戏币
         */
        public var SingleNeed:int;

        /**
         * 升级所需游戏币
         */
        public var NeedMoney:int;

        /**
         * 升级所需城堡等级
         */
        public var NeedCastleLv:int;

        /**
         * 下一级模板ID
         */
        public var NextTemplateID:int;

        /**
         * x坐标
         */
        public var PosX:int;

        /**
         * y坐标
         */
        public var PosY:int;

        /**
         * 建筑描述
         */
        public var Description:String;

    }
}