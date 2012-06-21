package core.scene
{
	import jsion.scenes.BaseScene;
	import jsion.scenes.ISceneCreator;
	import jsion.utils.AppDomainUtil;
	import jsion.utils.StringUtil;

	public class SceneCreator implements ISceneCreator
	{
		public function SceneCreator()
		{
		}
		
		public function create(type:String):BaseScene
		{
			switch(type)
			{
				case SceneType.DEBUG_LOGIN:
					return tryCreate("DebugLoginScene");
					break;
				case SceneType.LOGIN:
					return tryCreate("LoginScene");
					break;
			}
			
			return null;
		}
		
		private function tryCreate(cls:String):BaseScene
		{
			if(StringUtil.isNullOrEmpty(cls)) return null;
			
			return AppDomainUtil.create(cls) as BaseScene;
		}
		
		public function createAsync(type:String, callback:Function):void
		{
			trace(">>>>>>>>>> createAsync");
		}
	}
}