package jsion.chat
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextFieldType;
	
	import jsion.IDispose;
	import jsion.utils.DisposeUtil;
	
	public class ChatField extends Sprite implements IDispose
	{
		/**
		 * 用于指定动态类型的ChatField。
		 */
		public static const DYNAMIC:String = TextFieldType.DYNAMIC;
		/**
		 * 用于指定输入类型的ChatField。
		 */
		public static const INPUT:String = TextFieldType.INPUT;	
		
		private var m_width:int;
		private var m_height:int;
		
		private var m_textRenderer:TextRenderer;
		
		public function ChatField()
		{
			super();
			
			m_textRenderer = new TextRenderer();
			addChild(m_textRenderer);
		}
		
		public function get type():String
		{
			return m_textRenderer.type;
		}
		
		public function set type(value:String):void
		{
			m_textRenderer.type = value;
			
			if(value == INPUT)
			{
				m_textRenderer.addEventListener(Event.CHANGE, __textChangeHandler);
			}
		}
		
		private function __textChangeHandler(e:Event):void
		{
			
		}
		
		public function setSize(w:int, h:int):void
		{
			m_width = w;
			m_height = h;
		}
		
		public function dispose():void
		{
			if(m_textRenderer) m_textRenderer.removeEventListener(Event.CHANGE, __textChangeHandler);
			
			DisposeUtil.free(m_textRenderer);
			m_textRenderer = null;
		}
	}
}