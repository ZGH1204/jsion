package jsion.reflection
{
	import jsion.utils.StringUtil;

	/**
	 * 参数信息
	 * @author Jsion
	 * 
	 */	
	public class ParameterInfo extends ReflectionInfo
	{
		/**
		 * 参数索引
		 */		
		public var index:int;
		/**
		 * 参数类型
		 */		
		public var type:String;
		/**
		 * 是否为可选参数
		 */		
		public var optional:Boolean;
		
		/**
		 * @inheritDoc
		 */		
		override public function analyze():void
		{
			type = StringUtil.replace(type, "::", ".");
		}
	}
}