package knightage
{
	import jsion.utils.ObjectUtil;
	
	import knightage.hall.build.BuildType;
	import knightage.mgrs.TemplateMgr;
	import knightage.player.GamePlayer;
	import knightage.player.heros.PlayerHero;
	import knightage.templates.BuildTemplate;
	import knightage.templates.PrestigeConfig;
	import knightage.templates.SoilderTemplate;
	import knightage.templates.TavernConfig;

	public class GameUtil
	{
		/**
		 * 获取玩家等级(即城堡等级)，未建造时返回 0。
		 */		
		public static function getPlayerLv(player:GamePlayer):int
		{
			return getBuildLv(player, BuildType.Castle);
		}
		
		/**
		 * 获取指定建筑类型对应的一级建筑模板
		 * @param type
		 * @return 
		 * 
		 */		
		public static function getBuildFirstLvTemplate(type:int):BuildTemplate
		{
			var tid:int = StaticConfig.BuildFirstLvTIDList[type];
			
			return TemplateMgr.findBuildTemplate(tid);
		}
		
		/**
		 * 获取当前玩家指定建筑类型的下一级建筑模板
		 * @param type
		 * @return 
		 * 
		 */		
		public static function getBuildNextTemplate(player:GamePlayer, type:int):BuildTemplate
		{
			var tid:int = getBuildTID(player, type);
			
			var temp:BuildTemplate = TemplateMgr.findBuildTemplate(tid);
			
			if(temp == null) return null;
			
			tid = temp.NextTemplateID;
			
			return TemplateMgr.findBuildTemplate(tid);
		}
		
		/**
		 * 获取当前玩家城堡升下一级的所需经验值
		 * @param type
		 * @return 
		 * 
		 */		
		public static function getCastleNextUpgradeExp(player:GamePlayer):int
		{
			var tid:int = getBuildTID(player, BuildType.Castle);
			
			var nextTemplate:BuildTemplate = getBuildNextTemplate(player, BuildType.Castle);
			
			if(tid == 0)
			{
				nextTemplate = getBuildFirstLvTemplate(BuildType.Castle);
			}
			
			if(nextTemplate)
			{
				return StaticConfig.CastleUpGradeExp[nextTemplate.Lv];
			}
			
			return int.MAX_VALUE;
		}
		
		/**
		 * 获取指定建筑等级,不存在时返回 0。
		 * @param player
		 * @param type
		 * @return 
		 * 
		 */		
		public static function getBuildLv(player:GamePlayer, type:int):int
		{
			var build:BuildTemplate = getBuildTemplate(player, type);
			
			if(build) return build.Lv;
			
			return 0;
		}
		
		/**
		 * 获取当前玩家指定建筑类型的建筑模板
		 * @param type
		 * @return 
		 * 
		 */		
		public static function getBuildTemplate(player:GamePlayer, type:int):BuildTemplate
		{
			var tid:int = getBuildTID(player, type);
			
			return TemplateMgr.findBuildTemplate(tid);
		}
		
		/**
		 * 获取当前玩家指定建筑类型的建筑模板ID
		 * @param type
		 * 
		 */		
		public static function getBuildTID(player:GamePlayer, type:int):int
		{
			var m_templateID:int;
			
			switch(type)
			{
				case BuildType.Castle:
					m_templateID = player.castleTID;
					break;
				case BuildType.Framland:
					m_templateID = player.farmlandTID;
					break;
				case BuildType.Tavern:
					m_templateID = player.tavernTID;
					break;
				case BuildType.College:
					m_templateID = player.collegeTID;
					break;
				case BuildType.Barracks:
					m_templateID = player.barracksTID;
					break;
				case BuildType.Training:
					m_templateID = player.trainingTID;
					break;
				case BuildType.Market:
					m_templateID = player.marketTID;
					break;
				case BuildType.Prison:
					m_templateID = player.prisonTID;
					break;
				case BuildType.Divine:
					m_templateID = player.divineTID;
					break;
				case BuildType.Pandora:
					m_templateID = player.pandoraTID;
					break;
				case BuildType.Efigy:
					m_templateID = player.efigyTID;
					break;
				case BuildType.Smithy:
					m_templateID = player.smithyTID;
					break;
			}
			
			return m_templateID;
		}
		
		public static function setBuildTID(player:GamePlayer, type:int, tid:int):void
		{
			switch(type)
			{
				case BuildType.Castle:
					player.castleTID = tid;
					break;
				case BuildType.Framland:
					player.farmlandTID = tid;
					break;
				case BuildType.Tavern:
					player.tavernTID = tid;
					break;
				case BuildType.College:
					player.collegeTID = tid;
					break;
				case BuildType.Barracks:
					player.barracksTID = tid;
					break;
				case BuildType.Training:
					player.trainingTID = tid;
					break;
				case BuildType.Market:
					player.marketTID = tid;
					break;
				case BuildType.Prison:
					player.prisonTID = tid;
					break;
				case BuildType.Divine:
					player.divineTID = tid;
					break;
				case BuildType.Pandora:
					player.pandoraTID = tid;
					break;
				case BuildType.Efigy:
					player.efigyTID = tid;
					break;
				case BuildType.Smithy:
					player.smithyTID = tid;
					break;
			}
		}
		
		
		/**
		 * 获取指定兵系默认兵种模板
		 * @param category
		 * @return 
		 * 
		 */		
		public static function getDefaultSoilderTemplateByCategory(category:int):SoilderTemplate
		{
			var tid:int = StaticConfig.DefaultSoilderTypeList[category];
			
			return TemplateMgr.findSoilderTemplate(tid);
		}
		
		/**
		 * 获取玩家当前酒馆等级下举行派对的价格
		 * @param player
		 * @return 
		 * 
		 */		
		public static function getPartyPrice(player:GamePlayer):int
		{
			var tavernLv:int = GameUtil.getBuildLv(player, BuildType.Tavern);
			
			var tavernConfig:TavernConfig = TemplateMgr.findTavernConfig(tavernLv);
			
			return tavernConfig.CoinPartyPrice;
		}
		
		/**
		 * 获取玩家当前酒馆等级下豪华派对的价格
		 * @param player
		 * @return 
		 * 
		 */		
		public static function getGrandPartyPrice(player:GamePlayer):int
		{
			var tavernLv:int = GameUtil.getBuildLv(player, BuildType.Tavern);
			
			var tavernConfig:TavernConfig = TemplateMgr.findTavernConfig(tavernLv);
			
			return tavernConfig.GoldPartyPrice;
		}
		
		/**
		 * 获取当前酒馆等级下豪华派对价格累加值
		 * @param player
		 * @return 
		 * 
		 */		
		public static function getGrandPartyPriceStep(player:GamePlayer):int
		{
			var tavernConfig:TavernConfig = TemplateMgr.findTavernConfig(getBuildLv(player, BuildType.Tavern));
			
			return tavernConfig.GrandGoldStep;
		}
		
		/**
		 * 获取普通派对增加的声望值
		 * @param player
		 * @return 
		 * 
		 */		
		public static function getPartyPrestige(player:GamePlayer):int
		{
			var tavernLv:int = getBuildLv(player, BuildType.Tavern);
			
			var tavernConfig:TavernConfig = TemplateMgr.findTavernConfig(tavernLv);
			
			return tavernConfig.Prestige;
		}
		
		/**
		 * 获取豪华派对增加的声望值
		 * @param player
		 * @return 
		 * 
		 */		
		public static function getGrandPartyPrestige(player:GamePlayer):int
		{
			var tavernLv:int = getBuildLv(player, BuildType.Tavern);
			
			var tavernConfig:TavernConfig = TemplateMgr.findTavernConfig(tavernLv);
			
			return tavernConfig.GrandPrestige;
		}
		
		/**
		 * 获取玩家当前声望升下一级所需要的经验值
		 * 为0时表示已升到最高级
		 * @param player
		 * 
		 */		
		public static function getPrestigeUpgradeExp(player:GamePlayer):int
		{
			var prestige:PrestigeConfig = TemplateMgr.findPrestigeConfig(player.prestigeLv);
			
			return prestige.Exp;
		}
		
		public static function createHero(templateID:int, playerID:int):PlayerHero
		{
			var hero:PlayerHero = new PlayerHero();
			
			hero.templateID = templateID;
			hero.TemplateID = templateID;
			
			TemplateMgr.fillPlayerHero(hero);
			
			return hero;
		}
	}
}