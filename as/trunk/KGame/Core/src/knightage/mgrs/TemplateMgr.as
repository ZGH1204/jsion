package knightage.mgrs
{
	import jsion.HashMap;
	import jsion.utils.XmlUtil;
	
	import knightage.templates.BuildTemplate;
	
	public class TemplateMgr
	{
		private static var m_buildTemplate:HashMap;
		
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
		}
		
		public static function findBuildTemplate(templateID:int):BuildTemplate
		{
			return m_buildTemplate.get(templateID);
		}
	}
}