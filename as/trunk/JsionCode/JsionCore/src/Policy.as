package
{
	import flash.system.Security;

	public class Policy
	{
		public static function loadPolicyFile(policys:XMLList):void
		{
			for each(var xml:XML in policys)
			{
				var file:String = String(xml.@file);
				Security.loadPolicyFile(file);
			}
		}
	}
}