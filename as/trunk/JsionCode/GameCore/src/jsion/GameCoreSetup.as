package jsion
{
	import flash.display.Stage;
	
	import jsion.utils.BrowserUtil;

	/**
	 * GameCore类库的初始化函数
	 */	
	public function GameCoreSetup(stage:Stage):void
	{
		StageRef.setup(stage);
		
		BrowserUtil.setup(stage);
	}
}