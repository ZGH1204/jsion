package jutils.org.reflection
{
	import flash.utils.Dictionary;
	
	import jutils.org.util.StringUtil;

	public class ConstantInfo extends ReflectionInfo
	{
		public var name:String;
		public var type:String;
		public var metadatas:Dictionary;
		
		override public function analyze():void
		{
			type = StringUtil.replace(type, "::", ".");
		}
	}
}