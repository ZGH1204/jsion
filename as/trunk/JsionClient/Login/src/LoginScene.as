package
{
	import core.login.LoginMgr;
	
	import flash.events.MouseEvent;
	
	import jsion.debug.DEBUG;
	import jsion.display.Label;
	import jsion.scenes.BaseScene;
	import jsion.sounds.SoundMgr;
	import jsion.utils.DisposeUtil;
	
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
		
		private var label:Label;
		
		override public function enter(preScene:BaseScene, data:Object=null):void
		{
			DEBUG.debug("Enter login scene!");
			
			LoginMgr.account = data as String;
			
			label = new Label();
			
			label.beginChanges();
			label.html = true;
			label.text = "<j>字体嵌入测试文字</j>";
			label.parseCSS("j{fontFamily: \"MyFont1\";fontSize: 60;}");
			label.embedFonts = true;
			label.mouseEnabled = true;
			label.doubleClickEnabled = true;
			label.commitChanges();
			
			addChild(label);
			
			SoundMgr.play("064");
			
			label.addEventListener(MouseEvent.CLICK, __clickHandler);
			
			label.addEventListener(MouseEvent.DOUBLE_CLICK, __doubleClickHandler);
		}
		
		private function __clickHandler(e:MouseEvent):void
		{
			SoundMgr.play("008");
		}
		
		private function __doubleClickHandler(e:MouseEvent):void
		{
			SoundMgr.play("064");
		}
		
		override public function leaving(nextScene:BaseScene):void
		{
			DEBUG.debug("Leaving login scene!");
			
			if(label) label.removeEventListener(MouseEvent.CLICK, __clickHandler);
			
			DisposeUtil.free(label);
			label = null;
		}
	}
}