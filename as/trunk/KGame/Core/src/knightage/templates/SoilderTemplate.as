package knightage.templates
{
    public class SoilderTemplate extends TemplateInfo
    {

        /**
         * 士兵动作资源
         */
        public var Res:String;

        /**
         * 是否远程
         */
        public var isfar:String;

        /**
         * 士兵显示总人数 8人位置 4人位置 1人位置 
         */
        public var maxShow:int;

        /**
         * 兵系
         * 步兵：1
         * 枪兵：2
         * 骑兵：3
         * 射手：4
         * 法师：5
         */
        public var SoilderSys:int;

        /**
         * 需要卡片
         */
        public var NeedCard:int;

        /**
         * 转换兵种所需等级
         */
        public var NextLv:int;

        /**
         * 下一兵种ID
         */
        public var NextTID:int;

        /**
         * 刀伤害加成比例
         */
        public var WarHurt:Number;

        /**
         * 刀盾兵伤害加成比例
         */
        public var WarShieldHurt:Number;

        /**
         * 十字军伤害加成比例
         */
        public var CrusadersHurt:Number;

        /**
         * 狂剑士伤害加成比例
         */
        public var SwordmanHurt:Number;

        /**
         * 魔剑士伤害加成比例
         */
        public var DarkKnightHurt:Number;

        /**
         * 枪兵伤害加成比例
         */
        public var MarinesHurt:Number;

        /**
         * 长枪兵伤害加成比例
         */
        public var SpearmenHurt:Number;

        /**
         * 枪盾兵伤害加成比例
         */
        public var GunShieldHurt:Number;

        /**
         * 巨盾兵伤害加成比例
         */
        public var BigShieldHurt:Number;

        /**
         * 铁甲车伤害加成比例
         */
        public var ArmoredHurt:Number;

        /**
         * 骑兵伤害加成比例
         */
        public var CavalryHurt:Number;

        /**
         * 重骑兵伤害加成比例
         */
        public var HeavyRiderHurt:Number;

        /**
         * 圣骑士伤害加成比例
         */
        public var HolyRiderHurt:Number;

        /**
         * 狮鹫骑士伤害加成比例
         */
        public var GryphonRiderHurt:Number;

        /**
         * 龙骑士伤害加成比例
         */
        public var EragonHurt:Number;

        /**
         * 弓兵伤害加成比例
         */
        public var ArcherHurt:Number;

        /**
         * 长弓兵伤害加成比例
         */
        public var LongbowHurt:Number;

        /**
         * 弩兵伤害加成比例
         */
        public var CrossbowHurt:Number;

        /**
         * 掷矛兵伤害加成比例
         */
        public var SpearHurt:Number;

        /**
         * 骑射手伤害加成比例
         */
        public var HorseArcherHurt:Number;

        /**
         * 僧侣伤害加成比例
         */
        public var MonkHurt:Number;

        /**
         * 祭司伤害加成比例
         */
        public var PriestHurt:Number;

        /**
         * 巫师伤害加成比例
         */
        public var WizardHurt:Number;

        /**
         * 魔法师伤害加成比例
         */
        public var MagicianHurt:Number;

        /**
         * 牧师伤害加成比例
         */
        public var MinisterHurt:Number;

        /**
         * 技能ID
         */
        public var SkillID:int;

        /**
         * 需要花费的游戏币
         */
        public var GameCoins:int;

        /**
         * 说明
         */
        public var Describe:String;

    }
}