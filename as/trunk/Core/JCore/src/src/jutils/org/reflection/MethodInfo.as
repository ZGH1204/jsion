package jutils.org.reflection
{
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	
	import jutils.org.util.AppDomainUtil;
	import jutils.org.util.StringUtil;

	public class MethodInfo extends ReflectionInfo
	{
		public var name:String;
		public var declaredBy:String;
		public var returnType:String;
		public var parameters:Vector.<ParameterInfo>;
		public var metadatas:Dictionary;
		public var isStatic:Boolean = false;
		public var isInherit:Boolean = false;
		
		public function invoke(scope:Object, ...args):*
		{
			if(scope == null)
			{
				var cls:Class = AppDomainUtil.getClass(declaredBy);
				if(cls && cls.hasOwnProperty(name))
				{
					return cls[name].apply(null, args);
				}
				return null;
			}
			
			if(scope.hasOwnProperty(name) == false) return;
			
			return scope[name].apply(null, args);
		}
		
		override public function analyze():void
		{
			declaredBy = StringUtil.replace(declaredBy, "::", ".");
			returnType = StringUtil.replace(returnType, "::", ".");
		}
	}
}