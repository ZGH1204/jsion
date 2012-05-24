package jsion.core.reflection
{
	import flash.utils.Dictionary;

	/**
	 * 元数据信息
	 * @author Jsion
	 * 
	 */	
	public class MetaDataInfo extends ReflectionInfo
	{
		/**
		 * 元数据名称
		 */		
		public var name:String;
		
		/**
		 * 元数据参数列表
		 */		
		public var args:Dictionary;
		
		override public function analyze():void
		{
			
		}
	}
}