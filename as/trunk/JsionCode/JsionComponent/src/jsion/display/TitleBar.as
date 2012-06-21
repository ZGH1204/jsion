package jsion.display
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.text.StyleSheet;
	import flash.text.TextFormat;
	
	import jsion.comps.CompGlobal;
	import jsion.comps.CompUtil;
	import jsion.comps.Component;
	import jsion.utils.DisposeUtil;
	import jsion.utils.StringUtil;
	
	public class TitleBar extends Component
	{
		public static const BACKGROUND:String = "background";
		
		public static const LABELALIGN:String = "labelAlign";
		
		public static const LABELCHANGE:String = "labelChange";
		
		public static const TITLEVIEW:String = "titleView";
		
		/**
		 * 水平左边对齐
		 */		
		public static const LEFT:String = CompGlobal.LEFT;
		
		/**
		 * 水平右边对齐
		 */		
		public static const RIGHT:String = CompGlobal.RIGHT;
		
		/**
		 * 水平居中对齐
		 */		
		public static const CENTER:String = CompGlobal.CENTER;
		
		/**
		 * 垂直顶部对齐
		 */		
		public static const TOP:String = CompGlobal.TOP;
		
		/**
		 * 垂直底部对齐
		 */		
		public static const BOTTOM:String = CompGlobal.BOTTOM;
		
		/**
		 * 垂直居中对齐
		 */		
		public static const MIDDLE:String = CompGlobal.MIDDLE;
		
		private var m_background:DisplayObject;
		
		private var m_titleLabel:Label;
		
		private var m_titleView:DisplayObject;
		
		private var m_hOffset:int;
		private var m_hAlign:String;
		
		private var m_vOffset:int;
		private var m_vAlign:String;
		
		public function TitleBar()
		{
			m_hAlign = CENTER;
			m_vAlign = MIDDLE;
			
			super();
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function beginChanges():void
		{
			m_titleLabel.beginChanges();
			
			super.beginChanges();
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function commitChanges():void
		{
			m_titleLabel.commitChanges();
			
			super.commitChanges();
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function initialize():void
		{
			super.initialize();
			
			m_titleLabel = new Label();
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function onProppertiesUpdate():void
		{
			super.onProppertiesUpdate();
			
			updateTitleBarSize();
			
			updateBackground();
			
			updateLabelPos();
		}
		
		private function updateTitleBarSize():void
		{
			// TODO Auto Generated method stub
			if(m_background == null)
			{
				if(m_titleView)
				{
					if(manualWidth == false)
					{
						m_width = Math.max(m_titleView.width, m_titleLabel.width);
					}
					else
					{
						m_width = m_titleLabel.width;
					}
					
					if(manualHeight == false)
					{
						m_height = Math.max(m_titleView.height, m_titleLabel.height);
					}
					else
					{
						m_height = m_titleLabel.height;
					}
				}
				else
				{
					if(manualWidth == false)
					{
						m_width = m_titleLabel.width;
					}
					
					if(manualHeight == false)
					{
						m_height = m_titleLabel.height;
					}
				}
			}
		}
		
		private function updateBackground():void
		{
			if(isChanged(BACKGROUND) || isChanged(WIDTH) || isChanged(HEIGHT))
			{
				if(m_background)
				{
					m_background.width = m_width;
					m_background.height = m_height;
				}
			}
		}
		
		private function updateLabelPos():void
		{
			// TODO Auto Generated method stub
			var rect:Rectangle = new Rectangle();
			
			rect.width = m_titleLabel.width;
			rect.height = m_titleLabel.height;
			CompUtil.layoutPosition(m_width, m_height, m_hAlign, m_hOffset, m_vAlign, m_vOffset, rect);
			m_titleLabel.x = rect.x;
			m_titleLabel.y = rect.y;
			
			if(m_titleView)
			{
				rect.width = m_titleView.width;
				rect.height = m_titleView.height;
				CompUtil.layoutPosition(m_width, m_height, m_hAlign, m_hOffset, m_vAlign, m_vOffset, rect);
				m_titleView.x = rect.x;
				m_titleView.y = rect.y;
			}
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function addChildren():void
		{
			super.addChildren();
			
			if(m_background) addChild(m_background);
			
			addChild(m_titleLabel);
			
			if(m_titleView) addChild(m_titleView);
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function dispose():void
		{
			DisposeUtil.free(m_background, m_freeBMD);
			m_background = null;
			
			DisposeUtil.free(m_titleView, m_freeBMD);
			m_titleView = null;
			
			m_titleLabel = null;
			
			super.dispose();
		}
		
		/**
		 * 指示当资源为 Bitmap 对象时，是否释放其 bitmapData 属性。
		 */		
		public function get freeBMD():Boolean
		{
			return m_freeBMD;
		}
		
		/** @private */
		public function set freeBMD(value:Boolean):void
		{
			m_freeBMD = value;
		}
		
		/**
		 * 标题背景资源显示对象
		 */		
		public function get background():DisplayObject
		{
			return m_background;
		}
		
		/** @private */
		public function set background(value:DisplayObject):void
		{
			if(m_background != value)
			{
				DisposeUtil.free(m_background, m_freeBMD);
				
				m_background = value;
				
				if(m_background)
				{
					if(manualWidth == false) m_width = m_background.width;
					if(manualHeight == false) m_height = m_background.height;
				}
				
				onPropertiesChanged(BACKGROUND);
			}
		}

		/**
		 * 标题文本或 titleView 的水平偏移量
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
				
				onPropertiesChanged(LABELALIGN);
			}
		}

		/**
		 * 标题文本或 titleView 的水平对齐方式，可能的值：
		 * <ul>
		 * 	<li>TitleBar.LEFT</li>
		 * 	<li>TitleBar.RIGHT</li>
		 * 	<li>TitleBar.CENTER</li>
		 * </ul>
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
				
				onPropertiesChanged(LABELALIGN);
			}
		}

		/**
		 * 标题文本或 titleView 的垂直偏移量
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
				
				onPropertiesChanged(LABELALIGN);
			}
		}

		/**
		 * 标题文本或 titleView 的垂直对齐方式，可能的值：
		 * <ul>
		 * 	<li>TitleBar.TOP</li>
		 * 	<li>TitleBar.BOTTOM</li>
		 * 	<li>TitleBar.MIDDLE</li>
		 * </ul>
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
				
				onPropertiesChanged(LABELALIGN);
			}
		}
		
		/**
		 * 标题显示对象
		 */		
		public function get titleView():DisplayObject
		{
			return m_titleView;
		}
		
		/** @private */
		public function set titleView(value:DisplayObject):void
		{
			if(m_titleView != value)
			{
				DisposeUtil.free(m_titleView, m_freeBMD);
				
				m_titleView = value;
				
				onPropertiesChanged(TITLEVIEW);
			}
		}

		
		
		//==============================	Label组件属性	==============================
		
		
		/**
		 * 要显示的文本对象 支持带xml标签的文本
		 * 其中xml标签可在styleSheet属性对象内定义CSS样式
		 */		
		public function get text():String
		{
			return m_titleLabel.text;
		}
		
		/** @private */
		public function set text(value:String):void
		{
			if(m_titleLabel.text != value && StringUtil.isNotNullOrEmpty(value))
			{
				m_titleLabel.text = value;
				
				onPropertiesChanged(LABELCHANGE);
			}
		}
		
		/**
		 * 获取无标签的真实文本
		 */		
		public function get realText():String
		{
			return m_titleLabel.realText;
		}
		
		/**
		 * 设置文本颜色
		 * CSS样式会覆盖此设置
		 */		
		public function get textColor():uint
		{
			return m_titleLabel.textColor;
		}
		
		/** @private */
		public function set textColor(value:uint):void
		{
			if(m_titleLabel.textColor != value)
			{
				m_titleLabel.textColor = value;
				
				onPropertiesChanged(LABELCHANGE);
			}
		}
		
		/**
		 * 是否启用Html模式显示
		 */		
		public function get html():Boolean
		{
			return m_titleLabel.html;
		}
		
		/** @private */
		public function set html(value:Boolean):void
		{
			if(m_titleLabel.html != value)
			{
				m_titleLabel.html = value;
				
				onPropertiesChanged(LABELCHANGE);
			}
		}
		
		/**
		 * 获取或设置textFormat中字体是否为嵌入字体
		 */		
		public function get embedFonts():Boolean
		{
			return m_titleLabel.embedFonts;
		}
		
		/** @private */
		public function set embedFonts(value:Boolean):void
		{
			if(m_titleLabel.embedFonts != value)
			{
				m_titleLabel.embedFonts = value;
				
				onPropertiesChanged(LABELCHANGE);
			}
		}
		
		/**
		 * 获取或设置描述字符格式的设置信息。
		 */		
		public function get textFormat():TextFormat
		{
			return m_titleLabel.textFormat;
		}
		
		/** @private */
		public function set textFormat(value:TextFormat):void
		{
			m_titleLabel.textFormat = value;
			
			onPropertiesChanged(LABELCHANGE);
		}
		
		/**
		 * CSS样式表。
		 * 当使用CSS样式时无论是否开启 Html 属性都会替换掉所有标签并使用已定义的样式显示。
		 */		
		public function get styleSheet():StyleSheet
		{
			return m_titleLabel.styleSheet;
		}
		
		/** @private */
		public function set styleSheet(value:StyleSheet):void
		{
			m_titleLabel.styleSheet = value;
			
			onPropertiesChanged(LABELCHANGE);
		}
		
		/**
		 * 解析CSS样式文本 会覆盖掉已定义样式的对应属性。
		 * 当使用CSS样式时无论是否开启 Html 属性都会替换掉所有标签并使用已定义的样式显示。
		 * @param cssText CSS样式文本
		 */		
		public function parseCSS(cssText:String):StyleSheet
		{
			var style:StyleSheet = m_titleLabel.parseCSS(cssText);
			
			onPropertiesChanged(LABELCHANGE);
			
			return style;
		}

		//==============================	Label组件属性	==============================
	}
}