package knightage.mgrs
{
	import jsion.HashMap;
	import jsion.utils.XmlUtil;
	
	import knightage.templates.BuildTemplate;
	import knightage.templates.HeroTemplate;
	import knightage.templates.SoilderTemplate;
	
	public class TemplateMgr
	{
		private static var m_buildTemplate:HashMap;
		
		private static var m_heroTemplate:HashMap;
		
		private static var m_soilderTemplate:HashMap;
		
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
	}
}