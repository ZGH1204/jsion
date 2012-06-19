package
{
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	
	import jsion.IDispose;
	import jsion.StageRef;
	import jsion.scenes.SceneMgr;
	import jsion.utils.DepthUtil;
	import jsion.utils.DisposeUtil;
	import jsion.utils.StringUtil;
	
	public class DebugLoginView extends Sprite implements IDispose
	{
		private var account:String;
		
		private var m_textField:TextField;
		
		public function DebugLoginView()
		{
			super();
			
			initialize();
		}
		
		private function initialize():void
		{
			DepthUtil.bringToTop(this);
			
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
			StageRef.addEventListener(MouseEvent.CLICK, __stageClickHandler);
		}
		
		private function __keyDownHandler(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.ENTER && m_textField && StringUtil.isNotNullOrEmpty(StringUtil.trim(m_textField.text)))
			{
				account = StringUtil.trim(m_textField.text);
				
				m_textField.removeEventListener(KeyboardEvent.KEY_DOWN, __keyDownHandler);
				StageRef.removeEventListener(MouseEvent.CLICK, __stageClickHandler);
				
				DisposeUtil.free(m_textField);
				m_textField = null;
				
				SceneMgr.setScene(SceneType.LOGIN, account);
			}
		}
		
		private function __stageClickHandler(e:MouseEvent):void
		{
			StageRef.setFocus(m_textField);
		}
		
		public function dispose():void
		{
			if(m_textField) m_textField.removeEventListener(KeyboardEvent.KEY_DOWN, __keyDownHandler);
			
			StageRef.removeEventListener(MouseEvent.CLICK, __stageClickHandler);
			
			StageRef.setFocus(StageRef.stage);
			
			DisposeUtil.free(m_textField);
			m_textField = null;
		}
	}
}