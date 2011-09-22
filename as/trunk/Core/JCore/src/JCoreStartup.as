package
{
	import flash.display.Stage;
	import flash.system.Security;
	
	import jcore.org.timeline.TimeLineMgr;
	
	import jutils.org.util.InternetExplorerUtil;

	/**
	 * <p>核心库初始化</p>
	 * @param stage 舞台对象
	 * @param config 配置文件
	 * @author Jsion
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion JUtils 1
	 */	
	public function JCoreStartup(stage:Stage, config:XML):void
	{
		var policys:XMLList = config.Policys..policy;
		
		for each(var xml:XML in policys)
		{
			var file:String = String(xml.@file);
			Security.loadPolicyFile(file);
		}
		
		StageRef.setup(stage);
		
		Cache.setup(config);
		
		TimeLineMgr.setup();
		
		InternetExplorerUtil.setup(stage.root);
		
		LayerMgr.setup();
	}
}