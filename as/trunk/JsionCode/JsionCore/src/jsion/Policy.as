package jsion
{
	import flash.system.Security;

	/**
	 * 跨域策略文件操作类
	 * @author Jsion
	 * 
	 */	
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