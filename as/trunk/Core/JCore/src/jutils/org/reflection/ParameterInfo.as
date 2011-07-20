package jutils.org.reflection
{
	import jutils.org.util.StringUtil;

	public class ParameterInfo extends ReflectionInfo
	{
		public var index:int;
		public var type:String;
		public var optional:Boolean;
		
		override public function analyze():void
		{
			type = StringUtil.replace(type, "::", ".");
		}
	}
}