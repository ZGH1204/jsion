package knightage.registe
{
	import core.login.LoginMgr;
	import core.net.SocketProxy;
	
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import jsion.IDispose;
	import jsion.StageRef;
	import jsion.display.Label;
	import jsion.utils.DisposeUtil;
	import jsion.utils.StringUtil;
	
	import knightage.net.packets.RegistePacket;
	
	public class RegisteView extends Sprite implements IDispose
	{
		private var m_textField:TextField;
		
		private var m_titleLabel:Label;
		
		public function RegisteView()
		{
			super();
			
			initialize();
		}
		
		private function initialize():void
		{
			// TODO Auto Generated method stub
			m_textField = new TextField();
			m_textField.border = true;
			m_textField.borderColor = 0x336699;
			m_textField.background = true;
			m_textField.backgroundColor = 0xFFFFFF;
			m_textField.wordWrap = false;
			m_textField.multiline = false;
			m_textField.type = TextFieldType.INPUT;
			m_textField.width = 180;
			m_textField.height = 23;
			m_textField.x = (Config.GameWidth - m_textField.width) / 2;
			m_textField.y = (Config.GameHeight - m_textField.height) / 2;
			
			addChild(m_textField);
			
			StageRef.setFocus(m_textField);
			
			
			m_textField.addEventListener(KeyboardEvent.KEY_DOWN, __keyDownHandler);
			
			
			m_titleLabel = new Label();
			m_titleLabel.beginChanges();
			m_titleLabel.text = "请输入昵称完成初始化";
			m_titleLabel.textFormat = new TextFormat(null, 25);
			m_titleLabel.commitChanges();
			m_titleLabel.x = (Config.GameWidth - m_titleLabel.width) / 2;
			m_titleLabel.y = 100;
			addChild(m_titleLabel);
		}
		
		private function __keyDownHandler(e:KeyboardEvent):void
		{
			// TODO Auto-generated method stub
			if(e.keyCode == Keyboard.ENTER && m_textField && StringUtil.isNotNullOrEmpty(StringUtil.trim(m_textField.text)))
			{
				LoginMgr.nickName = m_textField.text;
				
				var pkg:RegistePacket = new RegistePacket();
				
				pkg.nickName = LoginMgr.nickName;
				
				SocketProxy.sendTCP(pkg);
			}
		}
		
		public function dispose():void
		{
			if(m_textField)
			{
				m_textField.removeEventListener(KeyboardEvent.KEY_DOWN, __keyDownHandler);
				DisposeUtil.free(m_textField);
				m_textField = null;
			}
			
			DisposeUtil.free(m_titleLabel);
			m_titleLabel = null;
		}
	}
}