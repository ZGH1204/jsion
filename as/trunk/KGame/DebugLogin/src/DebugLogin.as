package
{
	import flash.display.Stage;
	
	import jsion.loaders.LoaderQueue;
	import jsion.scenes.SceneMgr;

	public function DebugLogin(stage:Stage, config:XML, queue:LoaderQueue):void
	{
		//stage.addChild(InstanceUtil.createSingletion(DebugLoginView) as DisplayObject);
		
		SceneMgr.setScene(SceneType.DEBUG_LOGIN);
	}
}