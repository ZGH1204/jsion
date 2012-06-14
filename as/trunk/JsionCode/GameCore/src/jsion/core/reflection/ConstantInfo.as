package jsion.core.reflection
{
	import flash.utils.Dictionary;
	
	import jsion.utils.StringUtil;
	
	/**
	 * 常量信息
	 * @author Jsion
	 * 
	 */	
	public class ConstantInfo extends ReflectionInfo
	{
		/**
		 * 常量名
		 */		
		public var name:String;
		/**
		 * 常量类型
		 */		
		public var type:String;
		/**
		 * 元数据信息表
		 */		
		public var metadatas:Dictionary;
		
		/**
		 * @inheritDoc
		 */		
		override public function analyze():void
		{
			type = StringUtil.replace(type, "::", ".");
		}
	}
}