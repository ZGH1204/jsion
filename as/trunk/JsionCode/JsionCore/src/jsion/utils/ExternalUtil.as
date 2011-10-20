package jsion.utils
{
	import flash.external.ExternalInterface;
	import flash.utils.Dictionary;

	/**
	 * 与外部交互工具
	 * @author Jsion
	 * 
	 */	
	public class ExternalUtil
	{
		public function ExternalUtil()
		{
		}
		
		/**
		 * 注册外部可调用函数
		 * @param methodName 外部调用函数名
		 * @param fn 外部可调用函数
		 * 
		 */		
		public static function add(methodName:String, fn:Function):void
		{
			ExternalInterface.addCallback(methodName, fn);
		}
		
		/**
		 * 执行外部函数
		 * @param method 外部函数名
		 * @param args 参数列表
		 */		
		public static function run(method:String, ...args):void
		{
			ExternalInterface.marshallExceptions = true;
			if (ExternalInterface.available)
			{
				try
				{
					if(args) args.unshift(method);
					else args = [method];
					
					ExternalInterface.call.apply(null, args);
				}
				catch(err:Error)
				{
					trace(err.getStackTrace());
				}
			}
		}
	}
}