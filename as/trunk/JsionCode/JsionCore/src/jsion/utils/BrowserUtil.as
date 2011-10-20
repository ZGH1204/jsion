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
		
		public static function setup(root:DisplayObject):void
		{
			_parameters = root.root.loaderInfo.parameters;
		}
		
		public static function getVal(key:String):*
		{
			if(_parameters) return _parameters[key];
			return null;
		}
	}
}