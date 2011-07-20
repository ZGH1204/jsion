package jutils.org.reflection
{
	import flash.utils.Dictionary;
	
	import jutils.org.util.StringUtil;

	public class PropertyInfo extends ReflectionInfo
	{
		public var name:String;
		public var access:String;
		public var type:String;
		public var declaredBy:String;
		public var metadatas:Dictionary;
		public var isInheri:Boolean = false;
		
		override public function analyze():void
		{
			type = StringUtil.replace(type, "::", ".");
			declaredBy = StringUtil.replace(declaredBy, "::", ".");
		}
	}
}