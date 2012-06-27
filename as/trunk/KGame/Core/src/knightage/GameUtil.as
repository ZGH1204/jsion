package knightage
{
	import knightage.hall.build.BuildType;
	import knightage.mgrs.TemplateMgr;
	import knightage.player.GamePlayer;
	import knightage.templates.BuildTemplate;

	public class GameUtil
	{
		
		
		
		/**
		 * 获取玩家等级
		 */		
		public static function getPlayerLv(player:GamePlayer):int
		{
			var temp:BuildTemplate = getBuildTemplate(player, BuildType.Castle);
			
			if(temp) return temp.Lv;
			
			return 0;
		}
		
		/**
		 * 获取指定建筑类型一级对应的建筑模板
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
		 * 获取当前玩家指定建筑类型下一级的建筑模板
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
		 * 获取当前玩家城堡升下一级所需的经验值
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
	}
}