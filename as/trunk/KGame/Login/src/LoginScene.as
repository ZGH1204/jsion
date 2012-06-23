package
{
	import core.login.LoginMgr;
	
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	import jsion.StageRef;
	import jsion.comps.UIMgr;
	import jsion.debug.DEBUG;
	import jsion.display.Label;
	import jsion.scenes.BaseScene;
	import jsion.sounds.SoundMgr;
	import jsion.utils.DisposeUtil;
	
	import knightage.display.Alert;
	import knightage.display.Frame;
	import knightage.mgrs.PlayerMgr;
	
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
		
		private function testEmbedFont():void
		{
			label = new Label();
			
			label.beginChanges();
			label.html = true;
			label.text = "<j>字体嵌入测试文字</j>";
			label.parseCSS("j{fontFamily: \"MyFont1\";fontSize: 100;color: #FFFFFF;}");
			label.embedFonts = true;
			label.mouseEnabled = true;
			label.doubleClickEnabled = true;
			label.filters = [new GlowFilter(0x0, 1, 3, 3, 5, 1)];
			label.commitChanges();
			
			label.x = (StageRef.stageWidth - label.width) / 2;
			label.y = (StageRef.stageHeight - label.height) / 2;
			
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
		
		
		
		private var m_controller:LoginController;
		
		override public function enter(preScene:BaseScene, data:Object=null):void
		{
			DEBUG.debug("Enter login scene!");
			
			if(PlayerMgr.logined) return;
			
			LoginMgr.account = data as String;
			
			m_controller = new LoginController();
			
			m_controller.connectServer();
		}
		
		override public function leaving(nextScene:BaseScene):void
		{
			DEBUG.debug("Leaving login scene!");
			
			if(label) label.removeEventListener(MouseEvent.CLICK, __clickHandler);
			
			DisposeUtil.free(label);
			label = null;
			
			DisposeUtil.free(m_controller);
			m_controller = null;
		}
	}
}