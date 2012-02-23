package knightage.login.scene
{
	import jsion.core.scenes.BaseScene;
	
	import knightage.core.scenes.KSceneType;
	
	public class LoginScene extends BaseScene
	{
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
//			graphics.clear();
//			graphics.beginFill(0xFF0000);
//			graphics.drawRect(0,0,100,100);
//			graphics.endFill();
		}
		
		override public function leaving(nextScene:BaseScene):void
		{
			t("Leaving login scene");
		}
	}
}