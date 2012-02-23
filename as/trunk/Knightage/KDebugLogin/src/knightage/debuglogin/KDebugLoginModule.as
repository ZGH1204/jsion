package knightage.debuglogin
{
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	
	import jsion.StageRef;
	import jsion.core.messages.Msg;
	import jsion.core.modules.BaseModule;
	import jsion.core.modules.ModuleInfo;
	import jsion.core.scenes.SceneMgr;
	import jsion.utils.DisposeUtil;
	import jsion.utils.StringUtil;
	
	import knightage.core.MsgFlag;
	import knightage.core.net.SocketProxy;
	import knightage.core.net.packets.LoginPacket;
	import knightage.core.scenes.KSceneType;
	
	public class KDebugLoginModule extends BaseModule
	{
		private var inputTxt:TextField;
		
		public function KDebugLoginModule(info:ModuleInfo)
		{
			super(info);
		}
		
		override public function startup():void
		{
			registeReceive(MsgFlag.StartGame, onStartGame);
		}
		
		private function onStartGame(msg:Msg):void
		{
			removeReceive(MsgFlag.StartGame);
			
			inputTxt = new TextField();
			inputTxt.border = true;
			inputTxt.borderColor = 0x336699;
			inputTxt.background = true;
			inputTxt.backgroundColor = 0xFFFFFF;
			inputTxt.wordWrap = false;
			inputTxt.multiline = false;
			inputTxt.type = TextFieldType.INPUT;
			inputTxt.width = 180;
			inputTxt.height = 23;
			inputTxt.x = (StageRef.stageWidth - inputTxt.width) / 2;
			inputTxt.y = (StageRef.stageHeight - inputTxt.height) / 2;
//			inputTxt.embedFonts = true;
//			inputTxt.defaultTextFormat = new TextFormat("MyFont1");
			
			StageRef.addChild(inputTxt);
			
			inputTxt.addEventListener(KeyboardEvent.KEY_DOWN, __keyDownHandler);
			StageRef.addEventListener(MouseEvent.CLICK, __stageClickHandler);
			
			StageRef.setFocus(inputTxt);
		}
		
		private var account:String;
		
		private function __keyDownHandler(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.ENTER && inputTxt && StringUtil.isNotNullOrEmpty(StringUtil.trim(inputTxt.text)))
			{
				account = StringUtil.trim(inputTxt.text);
				
				inputTxt.removeEventListener(KeyboardEvent.KEY_DOWN, __keyDownHandler);
				StageRef.removeEventListener(MouseEvent.CLICK, __stageClickHandler);
				DisposeUtil.free(inputTxt);
				inputTxt = null;
				
//				var pkg:LoginPacket = new LoginPacket();
//				pkg.account = account;
//				SocketProxy.send(pkg);
				
				SceneMgr.setScene(KSceneType.LOGIN, account);
			}
		}
		
		private function __stageClickHandler(e:MouseEvent):void
		{
			StageRef.setFocus(inputTxt);
		}
	}
}