package jsion
{
	import flash.display.Stage;
	
	import jsion.utils.BrowserUtil;

	public function GameCoreSetup(stage:Stage):void
	{
		StageRef.setup(stage);
		
		BrowserUtil.setup(stage);
	}
}