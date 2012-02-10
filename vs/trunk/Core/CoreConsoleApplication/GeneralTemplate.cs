using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Serialization;
using GameBase;

namespace CoreConsoleApplication
{
    [Serializable]
    public class GeneralTemplate : Template
    {
        /// <summary>
        /// 头像
        /// </summary>
        [XmlAttribute]
        public string ImgUrl { get; set; }

        /// <summary>
        /// 介绍
        /// </summary>
        [XmlAttribute]
        public string Summary { get; set; }

        /// <summary>
        /// 武将品质
        /// </summary>
        [XmlAttribute]
        public int Quality { get; set; }

        /// <summary>
        /// 所属
        /// </summary>
        [XmlAttribute]
        public int Nation { get; set; }

        /// <summary>
        /// 可选兵种
        /// </summary>
        [XmlAttribute]
        public string[] Types { get; set; }

        /// <summary>
        /// 武力上限
        /// </summary>
        [XmlAttribute]
        public int ForceLimit { get; set; }

        /// <summary>
        /// 智力上限
        /// </summary>
        [XmlAttribute]
        public int BrainLimit { get; set; }

        /// <summary>
        /// 统帅上限
        /// </summary>
        [XmlAttribute]
        public int LeaderLimit { get; set; }

        /// <summary>
        /// 基础兵力
        /// </summary>
        [XmlAttribute]
        public int BaseSolider { get; set; }

        /// <summary>
        /// 基础物理攻击力
        /// </summary>
        [XmlAttribute]
        public int BasePhysicAttack { get; set; }

        /// <summary>
        /// 基础物理防御力
        /// </summary>
        [XmlAttribute]
        public int BasePhysicDefence { get; set; }

        /// <summary>
        /// 基础策略攻击力
        /// </summary>
        [XmlAttribute]
        public int BaseSpellAttack { get; set; }

        /// <summary>
        /// 基础策略防御力
        /// </summary>
        [XmlAttribute]
        public int BaseSpellDefence { get; set; }

        /// <summary>
        /// 基础物理暴击力
        /// </summary>
        [XmlAttribute]
        public int BasePhysicCritical { get; set; }

        /// <summary>
        /// 基础物理抗暴
        /// </summary>
        [XmlAttribute]
        public int BasePhysicResist { get; set; }

        /// <summary>
        /// 基础策略暴击力
        /// </summary>
        [XmlAttribute]
        public int BaseSpellCritical { get; set; }

        /// <summary>
        /// 基础策略抗暴
        /// </summary>
        [XmlAttribute]
        public int BaseSpellResist { get; set; }

        /// <summary>
        /// 基础命中
        /// </summary>
        [XmlAttribute]
        public int BaseHit { get; set; }

        /// <summary>
        /// 基础格挡
        /// </summary>
        [XmlAttribute]
        public int BaseBlock { get; set; }

        /// <summary>
        /// 物理暴击成长
        /// </summary>
        [XmlAttribute]
        public float PhysicCriticalGrowth { get; set; }

        /// <summary>
        /// 物理抗暴成长
        /// </summary>
        [XmlAttribute]
        public float PhysicResistGrowth { get; set; }

        /// <summary>
        /// 策略暴击成长
        /// </summary>
        [XmlAttribute]
        public float SpellCriticalGrowth { get; set; }

        /// <summary>
        /// 策略抗暴成长
        /// </summary>
        [XmlAttribute]
        public float SpellResistGrowth { get; set; }

        /// <summary>
        /// 命中成长
        /// </summary>
        [XmlAttribute]
        public float HitGrowth { get; set; }

        /// <summary>
        /// 格挡成长
        /// </summary>
        [XmlAttribute]
        public float BlockGrowth { get; set; }

        /// <summary>
        /// 主动技能ID
        /// </summary>
        [XmlAttribute]
        public int SkillID { get; set; }

        /// <summary>
        /// 被动技能ID
        /// </summary>
        [XmlAttribute]
        public int PassiveID { get; set; }

        ///// <summary>
        ///// 下一等级模板ID
        ///// </summary>
        //[XmlAttribute]
        //public int NextTemplateID { get; set; }
    }
}
