package jsion.display
{
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import jsion.comps.Component;
	import jsion.utils.DisposeUtil;
	import jsion.utils.StringUtil;
	
	/**
	 * 文本标签
	 * 支持CSS+Html显示
	 * 默认禁用鼠标事件
	 * @author Jsion
	 */	
	public class Label extends Component
	{
		public static const TEXT:String = "text";
		public static const HTML:String = "html";
		public static const EMBEDFONTS:String = "embedFonts";
		public static const TEXTFORMAT:String = "textFormat";
		public static const STYLESHEET:String = "styleSheet";
		
		private var m_text:String;
		
		private var m_html:Boolean;
		
		private var m_embedFonts:Boolean;
		
		private var m_textFormat:TextFormat;
		
		private var m_styleSheet:StyleSheet;
		
		private var m_textField:TextField;
		
		public function Label()
		{
			super();
			
			m_text = "";
			
			mouseEnabled = false;
			mouseChildren = false;
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function initialize():void
		{
			super.initialize();
			
			m_textField = new TextField();
			m_textField.type = TextFieldType.DYNAMIC;
			m_textField.autoSize = TextFieldAutoSize.LEFT;
			
			m_embedFonts = m_textField.embedFonts;
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function addChildren():void
		{
			super.addChildren();
			
			addChild(m_textField);
		}
		
		/**
		 * 要显示的文本对象 支持带xml标签的文本
		 * 其中xml标签可在styleSheet属性对象内定义CSS样式
		 */		
		public function get text():String
		{
			return m_text;
		}
		
		/** @private */
		public function set text(value:String):void
		{
			if(m_text != value && StringUtil.isNotNullOrEmpty(value))
			{
				m_text = value;
				
				onPropertiesChanged(TEXT);
			}
		}
		
		/**
		 * 是否启用Html模式显示
		 */		
		public function get html():Boolean
		{
			return m_html;
		}
		
		/** @private */
		public function set html(value:Boolean):void
		{
			if(m_html != value)
			{
				m_html = value;
				
				onPropertiesChanged(HTML);
			}
		}
		
		/**
		 * 获取或设置textFormat中字体是否为嵌入字体
		 */		
		public function get embedFonts():Boolean
		{
			return m_embedFonts;
		}
		
		/** @private */
		public function set embedFonts(value:Boolean):void
		{
			if(m_embedFonts != value)
			{
				m_embedFonts = value;
				
				onPropertiesChanged(EMBEDFONTS);
			}
		}
		
		/**
		 * 获取或设置描述字符格式的设置信息。
		 */		
		public function get textFormat():TextFormat
		{
			return m_textFormat;
		}
		
		/** @private */
		public function set textFormat(value:TextFormat):void
		{
			m_textFormat = value;
			
			onPropertiesChanged(TEXTFORMAT);
		}
		
		/**
		 * CSS样式表
		 */		
		public function get styleSheet():StyleSheet
		{
			return m_styleSheet;
		}
		
		/** @private */
		public function set styleSheet(value:StyleSheet):void
		{
			m_styleSheet = value;
			
			onPropertiesChanged(STYLESHEET);
		}
		
		/**
		 * 解析CSS样式文本 会覆盖掉已定义样式的对应属性
		 * @param cssText CSS样式文本
		 */		
		public function parseCSS(cssText:String):void
		{
			if(m_styleSheet == null) m_styleSheet = new StyleSheet();
			
			m_styleSheet.parseCSS(cssText);
			
			styleSheet = m_styleSheet;
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function onProppertiesUpdate():void
		{
			super.onProppertiesUpdate();
			
			m_textField.embedFonts = m_embedFonts;
			
			if(m_changeProperties.containsKey(TEXTFORMAT))
			{
				if(m_styleSheet != null) m_textField.styleSheet = null;
				
				m_textField.defaultTextFormat = m_textFormat;
				
				m_textField.styleSheet = m_styleSheet;
				
				if(m_html) m_textField.htmlText = m_text;
				else m_textField.text = m_text;
			}
			else if(m_changeProperties.containsKey(STYLESHEET))
			{
				m_textField.styleSheet = m_styleSheet;
				
				if(m_html) m_textField.htmlText = m_text;
				else m_textField.text = m_text;
			}
			else if(m_changeProperties.containsKey(TEXT) || 
					 m_changeProperties.containsKey(HTML))
			{
				if(m_html) m_textField.htmlText = m_text;
				else m_textField.text = m_text;
			}
			
			m_width = m_textField.width;
			m_height = m_textField.height;
		}
		
		/**
		 * 不支持设置宽度
		 * @throws Error 不支持设置宽度。
		 */		
		override public function set width(value:Number):void
		{
			throw new Error("Label 对象不支持设置宽度属性。");
		}
		
		/**
		 * 不支持设置高度
		 * @throws Error 不支持设置高度。
		 */		
		override public function set height(value:Number):void
		{
			throw new Error("Label 对象不支持设置高度属性。");
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function dispose():void
		{
			m_textField = null;
			m_textFormat = null;
			m_styleSheet = null;
			
			super.dispose();
		}
	}
}