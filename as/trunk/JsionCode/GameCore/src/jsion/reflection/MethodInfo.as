package jsion.reflection
{
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	
	import jsion.utils.*;

	/**
	 * 方法信息
	 * @author Jsion
	 * 
	 */	
	public class MethodInfo extends ReflectionInfo
	{
		/**
		 * 方法名称
		 */		
		public var name:String;
		/**
		 * 声明类
		 */		
		public var declaredBy:String;
		/**
		 * 返回类型
		 */		
		public var returnType:String;
		/**
		 * 参数列表
		 */		
		public var parameters:Vector.<ParameterInfo>;
		/**
		 * 元数据列表
		 */		
		public var metadatas:Dictionary;
		/**
		 * 是否是静态方法
		 */		
		public var isStatic:Boolean = false;
		/**
		 * 是否继承
		 */		
		public var isInherit:Boolean = false;
		
		/**
		 * 反射执行
		 * @param scope 执行时的this对象
		 * @param args 参数列表
		 * @return 方法返回值
		 * 
		 */		
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
		
		/**
		 * @inheritDoc
		 */		
		override public function analyze():void
		{
			declaredBy = StringUtil.replace(declaredBy, "::", ".");
			returnType = StringUtil.replace(returnType, "::", ".");
		}
	}
}