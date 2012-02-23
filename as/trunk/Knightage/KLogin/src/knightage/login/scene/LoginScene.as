package knightage.login.scene
{
	import jsion.core.scenes.BaseScene;
	import jsion.utils.BrowserUtil;
	import jsion.utils.DisposeUtil;
	import jsion.utils.StringUtil;
	
	import knightage.core.Config;
	import knightage.core.net.SocketProxy;
	import knightage.core.scenes.KSceneType;
	import knightage.login.LoginController;
	
	public class LoginScene extends BaseScene
	{
		private var controller:LoginController;
		
		public function LoginScene()
		{
			super();
		}
		
		override public function getSceneType():String
		{
			return KSceneType.LOGIN;
		}
		
		override public function enter(preScene:BaseScene, data:Object=null):void
		{
			t("Enter login scene", data);
			
			controller = new LoginController(data as String);
			
			controller.connectServer();
		}
		
		override public function leaving(nextScene:BaseScene):void
		{
			t("Leaving login scene");
			
			DisposeUtil.free(controller);
			controller = null;
		}
	}
}