package jsion.core.reflection
{
	import flash.utils.Dictionary;
	
	import jsion.utils.*;

	/**
	 * 属性信息
	 * @author Jsion
	 * 
	 */	
	public class PropertyInfo extends ReflectionInfo
	{
		/**
		 * 属性名称
		 */		
		public var name:String;
		/**
		 * 访问级别
		 */		
		public var access:String;
		/**
		 * 属性类型
		 */		
		public var type:String;
		/**
		 * 声明类
		 */		
		public var declaredBy:String;
		/**
		 * 元数据列表
		 */		
		public var metadatas:Dictionary;
		/**
		 * 是否继承
		 */		
		public var isInheri:Boolean = false;
		
		/**
		 * @inheritDoc
		 */		
		override public function analyze():void
		{
			type = StringUtil.replace(type, "::", ".");
			declaredBy = StringUtil.replace(declaredBy, "::", ".");
		}
	}
}