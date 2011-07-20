package jsion
{
	import com.managers.ModuleManager;
	import com.utils.ObjectHelper;
	import com.utils.StringHelper;
	
	import flash.display.DisplayObject;

	public class Util
	{
		public static function createDisplay(clsStr:String, x:Number = 0, y:Number = 0):DisplayObject
		{
			if(StringHelper.isNullOrEmpty(clsStr)) return null;
			
			var display:DisplayObject = ModuleManager.getInstance().create(clsStr) as DisplayObject;
			if(display)
			{
				display.x = x;
				display.y = y;
			}
			return display;
		}
		
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