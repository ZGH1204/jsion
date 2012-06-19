package
{
	import core.login.LoginMgr;
	
	import jsion.debug.DEBUG;
	import jsion.scenes.BaseScene;
	
	public class LoginScene extends BaseScene
	{
		public function LoginScene()
		{
			super();
		}
		
		override public function getSceneType():String
		{
			return SceneType.LOGIN;
		}
		
		override public function enter(preScene:BaseScene, data:Object=null):void
		{
			DEBUG.debug("Enter login scene!");
			
			LoginMgr.account = data as String;
		}
		
		override public function leaving(nextScene:BaseScene):void
		{
			DEBUG.debug("Leaving login scene!");
		}
	}
}