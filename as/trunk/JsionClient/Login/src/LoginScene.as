package
{
	import core.login.LoginMgr;
	
	import jsion.debug.DEBUG;
	import jsion.display.Label;
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
			
			var label:Label = new Label();
			
			label.beginChanges();
			label.html = true;
			label.text = "<j>字体嵌入测试文字</j>";
			label.parseCSS("j{fontFamily: \"MyFont1\";fontSize: 60;}");
			label.embedFonts = true;
			label.commitChanges();
			
			addChild(label);
		}
		
		override public function leaving(nextScene:BaseScene):void
		{
			DEBUG.debug("Leaving login scene!");
		}
	}
}