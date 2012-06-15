package jsion.reflection
{
	import jsion.utils.*;

	/**
	 * 反射支持类
	 * @author Jsion
	 * 
	 */	
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