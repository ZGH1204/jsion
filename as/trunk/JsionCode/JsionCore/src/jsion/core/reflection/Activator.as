package jsion.core.reflection
{
	import jsion.utils.*;

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