package jsion.display
{
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;

	public class Input extends Label
	{
		public function Input()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			m_textField.type = TextFieldType.INPUT;
			m_textField.autoSize = TextFieldAutoSize.NONE;
			
			m_textField.width = 100;
			m_textField.height = 26;
			
			m_width = m_textField.width;
			m_height = m_textField.height;
		}
		
		override protected function updateViewSize():void
		{
			m_textField.width = m_width;
			m_textField.height = m_height;
		}
		
		/**
		 * 文本对象的水平偏移量(仅设置了宽度或高度时有效)
		 */		
		override public function get hOffset():int
		{
			throw new Error("组件不支持此属性");
		}
		
		/** @private */
		override public function set hOffset(value:int):void
		{
			throw new Error("组件不支持此属性");
		}
		
		/**
		 * 文本对象的水平对齐方式(仅设置了宽度或高度时有效)
		 */		
		override public function get hAlign():String
		{
			throw new Error("组件不支持此属性");
		}
		
		/** @private */
		override public function set hAlign(value:String):void
		{
			throw new Error("组件不支持此属性");
		}
		
		/**
		 * 文本对象的垂直偏移量(仅设置了宽度或高度时有效)
		 */		
		override public function get vOffset():int
		{
			throw new Error("组件不支持此属性");
		}
		
		/** @private */
		override public function set vOffset(value:int):void
		{
			throw new Error("组件不支持此属性");
		}
		
		/**
		 * 文本对象的垂直对齐方式(仅设置了宽度或高度时有效)
		 */		
		override public function get vAlign():String
		{
			throw new Error("组件不支持此属性");
		}
		
		/** @private */
		override public function set vAlign(value:String):void
		{
			throw new Error("组件不支持此属性");
		}
	}
}