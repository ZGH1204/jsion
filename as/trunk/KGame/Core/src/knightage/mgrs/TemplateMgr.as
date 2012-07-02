package knightage.mgrs
{
	import jsion.HashMap;
	import jsion.utils.ObjectUtil;
	import jsion.utils.XmlUtil;
	
	import knightage.player.heros.PlayerHero;
	import knightage.templates.BuildTemplate;
	import knightage.templates.HeroTemplate;
	import knightage.templates.PrestigeConfig;
	import knightage.templates.SoilderTemplate;
	import knightage.templates.TavernConfig;
	
	public class TemplateMgr
	{
		private static var m_buildTemplate:HashMap;
		
		private static var m_heroTemplate:HashMap;
		
		private static var m_soilderTemplate:HashMap;
		
		private static var m_tavernConfig:HashMap;
		
		private static var m_prestigeConfig:HashMap;
		
		public function TemplateMgr()
		{
		}
		
		public static function setup(template:XML):void
		{
			m_buildTemplate = new HashMap();
			
			var buildList:XMLList = template.ArrayOfBuildTemplate.BuildTemplate;
			
			for each(var buildXml:XML in buildList)
			{
				var buildTemplate:BuildTemplate = new BuildTemplate();
				
				XmlUtil.decodeWithProperty(buildTemplate, buildXml);
				
				m_buildTemplate.put(buildTemplate.TemplateID, buildTemplate);
			}
			
			
			
			m_heroTemplate = new HashMap();
			
			var heroList:XMLList = template.ArrayOfHeroTemplate.HeroTemplate;
			
			for each(var heroXml:XML in heroList)
			{
				var heroTemplate:HeroTemplate = new HeroTemplate();
				
				XmlUtil.decodeWithProperty(heroTemplate, heroXml);
				
				m_heroTemplate.put(heroTemplate.TemplateID, heroTemplate);
			}
			
			
			
			m_soilderTemplate = new HashMap();
			
			var soilderList:XMLList = template.ArrayOfSoilderTemplate.SoilderTemplate;
			
			for each(var soilderXml:XML in soilderList)
			{
				var soilderTemplate:SoilderTemplate = new SoilderTemplate();
				
				XmlUtil.decodeWithProperty(soilderTemplate, soilderXml);
				
				m_soilderTemplate.put(soilderTemplate.TemplateID, soilderTemplate);
			}
			
			
			
			m_tavernConfig = new HashMap();
			
			var tavernConfigList:XMLList = template.ArrayOfTavernConfig.TavernConfig;
			
			for each(var tavernConfigXml:XML in tavernConfigList)
			{
				var tavernConfig:TavernConfig = new TavernConfig();
				
				XmlUtil.decodeWithProperty(tavernConfig, tavernConfigXml);
				
				m_tavernConfig.put(tavernConfig.TemplateID, tavernConfig);
			}
			
			
			
			m_prestigeConfig = new HashMap();
			
			var prestigeConfigList:XMLList = template.ArrayOfPrestigeConfig.PrestigeConfig;
			
			for each(var prestigeConfigXml:XML in prestigeConfigList)
			{
				var prestigeConfig:PrestigeConfig = new PrestigeConfig();
				
				XmlUtil.decodeWithProperty(prestigeConfig, prestigeConfigXml);
				
				m_prestigeConfig.put(prestigeConfig.TemplateID, prestigeConfig);
			}
		}
		
		public static function findBuildTemplate(templateID:int):BuildTemplate
		{
			return m_buildTemplate.get(templateID);
		}
		
		public static function findHeroTemplate(templateID:int):HeroTemplate
		{
			return m_heroTemplate.get(templateID);
		}
		
		public static function findSoilderTemplate(templateID:int):SoilderTemplate
		{
			return m_soilderTemplate.get(templateID);
		}
		
		public static function findTavernConfig(lv:int):TavernConfig
		{
			return m_tavernConfig.get(lv);
		}
		
		public static function findPrestigeConfig(lv:int):PrestigeConfig
		{
			return m_prestigeConfig.get(lv);
		}
		
		public static function fillPlayerHero(hero:PlayerHero):void
		{
			var temp:HeroTemplate = findHeroTemplate(hero.templateID);
			
			ObjectUtil.copyToTarget(temp, hero);
		}
	}
}