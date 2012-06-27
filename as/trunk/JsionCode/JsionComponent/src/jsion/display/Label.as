/**
 * 显示对象包
 */
package jsion.display
{
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import jsion.comps.CompGlobal;
	import jsion.comps.CompUtil;
	import jsion.comps.Component;
	import jsion.utils.StringUtil;
	
	/**
	 * 文本标签
	 * 支持CSS+Html显示
	 * 默认禁用鼠标事件
	 * @author Jsion
	 */	
	public class Label extends Component
	{
		public static const LEFT:String = CompGlobal.LEFT;
		public static const RIGHT:String = CompGlobal.RIGHT;
		public static const CENTER:String = CompGlobal.CENTER;
		public static const TOP:String = CompGlobal.TOP;
		public static const BOTTOM:String = CompGlobal.BOTTOM;
		public static const MIDDLE:String = CompGlobal.MIDDLE;
		
		/**
		 * 宽度属性变更
		 */		
		public static const WIDTH:String = Component.WIDTH;
		
		/**
		 * 高度属性变更
		 */		
		public static const HEIGHT:String = Component.HEIGHT;
		
		/**
		 * 文本字符串变更
		 */		
		public static const TEXT:String = "text";
		/**
		 * 文本公共颜色变更
		 */		
		public static const TEXTCOLOR:String = "textColor";
		/**
		 * Html模式变更
		 */		
		public static const HTML:String = "html";
		/**
		 * 是否启用嵌入字体变更
		 */		
		public static const EMBEDFONTS:String = "embedFonts";
		/**
		 * 文本字符样式变更
		 */		
		public static const TEXTFORMAT:String = "textFormat";
		/**
		 * CSS样式变更
		 */		
		public static const STYLESHEET:String = "styleSheet";
		
		/**
		 * 对齐方式
		 */		
		public static const ALIGN:String = "align";
		
		/**
		 * 文本抗锯齿发生变更
		 */		
		public static const ANTIALIAS:String = "antiAlias";
		
		
		private var m_text:String;
		
		private var m_html:Boolean;
		
		private var m_embedFonts:Boolean;
		
		private var m_textFormat:TextFormat;
		
		private var m_styleSheet:StyleSheet;
		
		private var m_textField:TextField;
		
		private var m_textColor:uint;
		
		
		
		private var m_hOffset:int;
		private var m_hAlign:String;
		
		private var m_vOffset:int;
		private var m_vAlign:String;
		
		private var m_tempRect:Rectangle;
		
		private var m_antiAliasType:String;
		
		private var m_thickness:int;
		
		private var m_sharpness:int;
		
		public function Label()
		{
			m_hAlign = CENTER;
			m_vAlign = MIDDLE;
			
			super();
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function initialize():void
		{
			super.initialize();
			
			m_text = "";
			m_textColor = 0;
			
			mouseEnabled = false;
			mouseChildren = false;
			
			m_tempRect = new Rectangle();
			
			m_antiAliasType = AntiAliasType.NORMAL;
			
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
		 * 文本对象的水平偏移量(仅设置了宽度或高度时有效)
		 */		
		public function get hOffset():int
		{
			return m_hOffset;
		}
		
		/** @private */
		public function set hOffset(value:int):void
		{
			if(m_hOffset != value)
			{
				m_hOffset = value;
				
				onPropertiesChanged(ALIGN);
			}
		}
		
		/**
		 * 文本对象的水平对齐方式(仅设置了宽度或高度时有效)
		 */		
		public function get hAlign():String
		{
			return m_hAlign;
		}
		
		/** @private */
		public function set hAlign(value:String):void
		{
			if(m_hAlign != value && (value == LEFT || value == RIGHT || value == CENTER))
			{
				m_hAlign = value;
				
				onPropertiesChanged(ALIGN);
			}
		}
		
		/**
		 * 文本对象的垂直偏移量(仅设置了宽度或高度时有效)
		 */		
		public function get vOffset():int
		{
			return m_vOffset;
		}
		
		/** @private */
		public function set vOffset(value:int):void
		{
			if(m_vOffset != value)
			{
				m_vOffset = value;
				
				onPropertiesChanged(ALIGN);
			}
		}
		
		/**
		 * 文本对象的垂直对齐方式(仅设置了宽度或高度时有效)
		 */		
		public function get vAlign():String
		{
			return m_vAlign;
		}
		
		/** @private */
		public function set vAlign(value:String):void
		{
			if(m_vAlign != value && (value == TOP || value == BOTTOM || value == MIDDLE))
			{
				m_vAlign = value;
				
				onPropertiesChanged(ALIGN);
			}
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
		 * 获取无标签的真实文本
		 */		
		public function get realText():String
		{
			return m_textField.text;
		}
		
		/**
		 * 设置文本颜色
		 * CSS样式会覆盖此设置
		 */		
		public function get textColor():uint
		{
			return m_textColor;
		}
		
		/** @private */
		public function set textColor(value:uint):void
		{
			if(m_textColor != value)
			{
				m_textColor = value;
				
				onPropertiesChanged(TEXTCOLOR);
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
		 * CSS样式表。
		 * 当使用CSS样式时无论是否开启 Html 属性都会替换掉所有标签并使用已定义的样式显示。
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
		 * 文本抗锯齿类型，可能的值：
		 * <ul>
		 * 	<li>AntiAliasType.NORMAL</li>
		 * 	<li>AntiAliasType.ADVANCED</li>
		 * </ul>
		 * @see flash.text.AntiAliasType
		 */		
		public function get antiAliasType():String
		{
			return m_antiAliasType;
		}
		
		/** @private */
		public function set antiAliasType(value:String):void
		{
			if(m_antiAliasType != value)
			{
				m_antiAliasType = value;
				
				onPropertiesChanged(ANTIALIAS);
			}
		}
		
		/**
		 * 自定义消除锯齿的粗细
		 */		
		public function get thickness():int
		{
			return m_thickness;
		}
		
		/** @private */
		public function set thickness(value:int):void
		{
			if(m_thickness != value)
			{
				m_thickness = value;
				
				onPropertiesChanged(ANTIALIAS);
			}
		}
		
		/**
		 * 自定义消除锯齿的清晰度
		 */		
		public function get sharpness():int
		{
			return m_sharpness;
		}
		
		/** @private */
		public function set sharpness(value:int):void
		{
			if(m_sharpness != value)
			{
				m_sharpness = value;
				
				onPropertiesChanged(ANTIALIAS);
			}
		}
		
		/**
		 * 解析CSS样式文本 会覆盖掉已定义样式的对应属性。
		 * 当使用CSS样式时无论是否开启 Html 属性都会替换掉所有标签并使用已定义的样式显示。
		 * @param cssText CSS样式文本
		 */		
		public function parseCSS(cssText:String):StyleSheet
		{
			if(m_styleSheet == null) m_styleSheet = new StyleSheet();
			
			m_styleSheet.parseCSS(cssText);
			
			styleSheet = m_styleSheet;
			
			return m_styleSheet;
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function onProppertiesUpdate():void
		{
			super.onProppertiesUpdate();
			
			m_textField.text = "";
			m_textField.textColor = m_textColor;
			m_textField.embedFonts = m_embedFonts;
			
			if(isChanged(TEXTFORMAT))
			{
				m_textField.styleSheet = null;
				
				m_textField.defaultTextFormat = m_textFormat;
				
				m_textField.styleSheet = m_styleSheet;
			}
			else if(isChanged(STYLESHEET))
			{
				m_textField.styleSheet = m_styleSheet;
			}
			
			m_textField.antiAliasType = m_antiAliasType;
			m_textField.thickness = m_thickness;
			m_textField.sharpness = m_sharpness;
			
			if(m_html) m_textField.htmlText = m_text;
			else m_textField.text = m_text;
			
			if(manualWidth == false) m_width = m_textField.width;
			
			if(manualHeight == false) m_height = m_textField.height;
			
			if(manualWidth || manualHeight)
			{
				m_tempRect.width = m_textField.width;
				m_tempRect.height = m_textField.height;
				
				CompUtil.layoutPosition(m_width, m_height, m_hAlign, m_hOffset, m_vAlign, m_vOffset, m_tempRect);
				
				m_tempRect.x = Math.max(m_tempRect.x, 0);
				m_tempRect.y = Math.max(m_tempRect.y, 0);
				
				m_textField.x = m_tempRect.x;
				m_textField.y = m_tempRect.y;
			}
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