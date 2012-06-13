package jsion.utils
{
	import flash.display.DisplayObject;

	/**
	 * 浏览器工具，只负责浏览器传递给Flash的参数读取。
	 * @author Jsion
	 */	
	public class BrowserUtil
	{
		private static var _parameters:Object;
		
		public function BrowserUtil()
		{
		}
		
		/**
		 * 初始化
		 */		
		public static function setup(root:DisplayObject):void
		{
			_parameters = root.root.loaderInfo.parameters;
		}
		
		/**
		 * 获取指定Key对应的值
		 * @param key 要获取值的Key
		 * @return 获取到的值
		 * 
		 */		
		public static function getVal(key:String):*
		{
			if(_parameters) return _parameters[key];
			return null;
		}
	}
}