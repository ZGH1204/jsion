package jsion
{
	import com.utils.ObjectHelper;

	public class Util
	{
		public static function parseXml(target:Object, xml:XML, parentXML:XML = null):void
		{
			if(parentXML != null)
			{
				ObjectHelper.copyPropertiesByXML(target, parentXML);
				
				var parentExtendXL:XMLList = parentXML.extend;
				for each(var parentExtendXml:XML in parentExtendXL)
				{
					ObjectHelper.copyPropertiesByXML(target, parentExtendXml);
				}
			}
			
			if(xml != null)
			{
				ObjectHelper.copyPropertiesByXML(target, xml);
				
				var xmlExtendXL:XMLList = xml.extend;
				for each(var xmlExtendXml:XML in xmlExtendXL)
				{
					ObjectHelper.copyPropertiesByXML(target, xmlExtendXml);
				}
			}
		}
	}
}