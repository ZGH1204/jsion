package
{
	import flash.system.Security;

	/**
	 * 跨域策略文件操作类
	 * @author Jsion
	 * 
	 */	
	public class Policy
	{
		/**
		 * 加载跨域文件列表
		 * @param policys 由多个Xml节点组成的XMLList对象,无根节点,单个节点格式为：<br>
		 * &lt;policy file="crossdomain.xml" /&gt;
		 * 
		 */		
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