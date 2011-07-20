package jutils.org.reflection
{
	import jutils.org.util.AppDomainUtil;
	import jutils.org.util.StringUtil;

	public class Activator
	{
		public static function createInstance(type:Type):Object
		{
			if(type == null || StringUtil.isNullOrEmpty(type.name)) return null;
			
			var cls:Class = AppDomainUtil.getClass(type.name);
			
			return new cls();
		}
	}
}