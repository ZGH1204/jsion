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
	
	public class Label extends Component
	{
		public static const TEXT:String = "text";
		public static const EMBEDFONTS:String = "embedFonts";
		public static const TEXTFORMAT:String = "textFormat";
		public static const STYLESHEET:String = "styleSheet";
		
		private var m_text:String;
		
		private var m_embedFonts:Boolean;
		
		private var m_textFormat:TextFormat;
		
		private var m_styleSheet:StyleSheet;
		
		private var m_textField:TextField;
		
		public function Label()
		{
			super();
			
			m_text = "";
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			m_textField = new TextField();
			m_textField.type = TextFieldType.DYNAMIC;
			m_textField.autoSize = TextFieldAutoSize.LEFT;
			
			m_embedFonts = m_textField.embedFonts;
		}
		
		override protected function addChildren():void
		{
			addChild(m_textField);
		}
		
		public function get text():String
		{
			return m_text;
		}
		
		public function set text(value:String):void
		{
			if(m_text != value && StringUtil.isNotNullOrEmpty(value))
			{
				m_text = value;
				
				onPropertiesChanged(TEXT);
			}
		}
		
		public function get embedFonts():Boolean
		{
			return m_embedFonts;
		}
		
		public function set embedFonts(value:Boolean):void
		{
			if(m_embedFonts != value)
			{
				m_embedFonts = value;
				
				onPropertiesChanged(EMBEDFONTS);
			}
		}
		
		public function get textFormat():TextFormat
		{
			return m_textFormat;
		}
		
		public function set textFormat(value:TextFormat):void
		{
			m_textFormat = value;
			
			onPropertiesChanged(TEXTFORMAT);
		}
		
		public function get styleSheet():StyleSheet
		{
			return m_styleSheet;
		}
		
		public function set styleSheet(value:StyleSheet):void
		{
			m_styleSheet = value;
			
			onPropertiesChanged(STYLESHEET);
		}
		
		override protected function onProppertiesUpdate():void
		{
			super.onProppertiesUpdate();
			
			m_textField.embedFonts = m_embedFonts;
			
			if(m_changeProperties.containsKey(TEXTFORMAT))
			{
				if(m_styleSheet != null) m_textField.styleSheet = null;
				
				m_textField.defaultTextFormat = m_textFormat;
				
				m_textField.styleSheet = m_styleSheet;
				
				m_textField.htmlText = m_text;
			}
			else if(m_changeProperties.containsKey(STYLESHEET))
			{
				m_textField.styleSheet = m_styleSheet;
				
				m_textField.htmlText = m_text;
			}
			else if(m_changeProperties.containsKey(TEXT))
			{
				m_textField.htmlText = m_text;
			}
			
			m_width = m_textField.width;
			m_height = m_textField.height;
		}
		
		override public function dispose():void
		{
			m_textField = null;
			m_textFormat = null;
			m_styleSheet = null;
			
			super.dispose();
		}
	}
}