package
{
	import flash.display.Stage;
	
	import jsion.core.modules.ModuleMgr;
	import jsion.utils.BrowserUtil;

	/**
	 * JsionCore类库的初始化函数
	 */	
	public function JsionCoreSetup(stage:Stage, config:XML):void
	{
		Policy.loadPolicyFile(config.Policys..policy);
		
		StageRef.setup(stage);
		
		Cache.setup(config);
		
		BrowserUtil.setup(stage.root);
		
		ModuleMgr.setup(config);
	}
}