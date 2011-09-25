package jsion.utils
{
	import flash.display.DisplayObject;

	public class InternetExplorerUtil
	{
		private static var _parameters:Object;
		
		public function InternetExplorerUtil()
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