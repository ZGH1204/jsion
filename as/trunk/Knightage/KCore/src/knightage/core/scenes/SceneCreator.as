package knightage.core.scenes
{
	import jsion.core.scenes.BaseScene;
	import jsion.core.scenes.ISceneCreator;
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
//				case SLGSceneType.INNER_CITY:
//					return tryCreate("slg.innercity.InnerCityScene");
//					break;
//				
//				case SLGSceneType.MISSION:
//					return new MissionScene();
//					break;
//				
//				case SLGSceneType.FIGHTER:
//					return tryCreate("slg.fighter.FighterScene");
//					break;
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