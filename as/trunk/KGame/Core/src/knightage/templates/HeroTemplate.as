package knightage.templates
{
    public class HeroTemplate extends TemplateInfo
    {

        /**
         * 头像
         */
        public var HeadImg:String;

        /**
         * 半身像
         */
        public var BustImg:String;

        /**
         * 
         */
        public var Shape:String;

        /**
         * 性别
         * 男：1
         * 女：0
         */
        public var Sex:int;

        /**
         * 类型
         */
        public var HeroType:int;

        /**
         * 品质
         */
        public var Quality:int;

        /**
         * 基础带兵数
         */
        public var BasicTroops:int;

        /**
         * 基础怒气
         */
        public var BasicAnger:int;

        /**
         * 基础攻击
         */
        public var BasicAttack:int;

        /**
         * 基础防御
         */
        public var BasicDefense:int;

        /**
         * 基础速度
         */
        public var BasicVelocity:int;

        /**
         * 基础暴击
         */
        public var BasicCrit:int;

        /**
         * 基础格挡
         */
        public var BasicParry:int;

        /**
         * 基础闪避
         */
        public var BasicDodge:int;

        /**
         * 带兵成长
         */
        public var TroopsGrowth:int;

        /**
         * 攻击成长
         */
        public var AttackGrowth:int;

        /**
         * 防御成长
         */
        public var DefenseGrowth:int;

        /**
         * 兵系类型
         */
        public var SoliderType:int;

        /**
         * 擅长兵种
         */
        public var GoodAtSolider:int;

        /**
         * 增强属性类型
         */
        public var EnhancedType:int;

        /**
         * 增强属性比例
         */
        public var EnhancedPro:int;

        /**
         * 怒气成长
         */
        public var AngerGrowth:int;

        /**
         * 闪避成长
         */
        public var DodgeGrowth:int;

        /**
         * 速度成长
         */
        public var VelocityGrowth:int;

        /**
         * 暴击成长
         */
        public var CritGrowth:int;

        /**
         * 格挡成长
         */
        public var ParryGrowth:int;

        /**
         * 是否特殊英雄
         * 不是：0
         * 　是：1
         */
        public var IsSpecialHero:int;

    }
}