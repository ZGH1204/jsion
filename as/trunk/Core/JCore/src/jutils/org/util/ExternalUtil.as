package jutils.org.util
{
	import flash.external.ExternalInterface;
	import flash.utils.Dictionary;

	public class ExternalUtil
	{
		public function ExternalUtil()
		{
		}
		
		public static function add(methodName:String, fn:Function):void
		{
			ExternalInterface.addCallback(methodName, fn);
		}
		
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