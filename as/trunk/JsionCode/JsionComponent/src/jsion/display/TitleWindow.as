package jsion.display
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.text.StyleSheet;
	import flash.text.TextFormat;
	
	import jsion.comps.CompUtil;
	import jsion.utils.StringUtil;

	/**
	 * 带标题的窗体
	 * @author Jsion
	 * 
	 */	
	public class TitleWindow extends Window
	{
		public static const TITLEBARALIGN:String = "titleBarAlign";
		
		public static const TITLEBARCHANGE:String = "titleBarChange";
		
		/**
		 * 水平左边对齐
		 */		
		public static const LEFT:String = TitleBar.LEFT;
		
		/**
		 * 水平右边对齐
		 */		
		public static const RIGHT:String = TitleBar.RIGHT;
		
		/**
		 * 水平居中对齐
		 */		
		public static const CENTER:String = TitleBar.CENTER;
		
		/**
		 * 垂直顶部对齐
		 */		
		public static const TOP:String = TitleBar.TOP;
		
		/**
		 * 垂直底部对齐
		 */		
		public static const BOTTOM:String = TitleBar.BOTTOM;
		
		/**
		 * 垂直居中对齐
		 */		
		public static const MIDDLE:String = TitleBar.MIDDLE;
		
		
		/** @private */
		protected var m_titleBar:TitleBar;
		
		/** @private */
		protected var m_titleBarHOffset:int;
		/** @private */
		protected var m_titleBarHAlign:String;
		
		/** @private */
		protected var m_titleBarVOffset:int;
		/** @private */
		protected var m_titleBarVAlign:String;
		
		/** @private */
		protected var m_dragger:TitleDragger;
		
		public function TitleWindow(modal:Boolean = true)
		{
			super(modal);
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function beginChanges():void
		{
			m_titleBar.beginChanges();
			
			super.beginChanges();
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function commitChanges():void
		{
			m_titleBar.commitChanges();
			
			super.commitChanges();
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function initialize():void
		{
			super.initialize();
			
			m_titleBarVAlign = TOP;
			m_titleBarHAlign = CENTER;
			
			m_titleBar = new TitleBar();
			m_titleBar.mouseEnabled = false;
			m_titleBar.mouseChildren = false;
			
			m_dragger = new TitleDragger(this);
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function onProppertiesUpdate():void
		{
			super.onProppertiesUpdate();
			
			updateTitleBar();
		}
		
		private function updateTitleBar():void
		{
			// TODO Auto Generated method stub
			if(isChanged(WIDTH) || isChanged(HEIGHT) || isChanged(TITLEBARALIGN) || isChanged(TITLEBARCHANGE))
			{
				var rect:Rectangle = new Rectangle();
				
				rect.width = m_titleBar.width;
				rect.height = m_titleBar.height;
				CompUtil.layoutPosition(m_width, m_height, m_titleBarHAlign, m_titleBarHOffset, m_titleBarVAlign, m_titleBarVOffset, rect);
				m_titleBar.x = rect.x;
				m_titleBar.y = rect.y;
				
				m_dragger.drawTrigger(m_titleBar.x, m_titleBar.y, m_titleBar.width, m_titleBar.height);
			}
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function addChildren():void
		{
			super.addChildren();
			
			addChild(m_dragger);
			
			addChild(m_titleBar);
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function dispose():void
		{
			m_dragger = null;
			
			m_titleBar = null;
			
			super.dispose();
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function set freeBMD(value:Boolean):void
		{
			super.freeBMD = value;
			
			m_titleBar.freeBMD = value;
		}
		
		
		
		/**
		 * 标题栏水平偏移量
		 */
		public function get titleBarHOffset():int
		{
			return m_titleBarHOffset;
		}
		
		/** @private */
		public function set titleBarHOffset(value:int):void
		{
			if(m_titleBarHOffset != value)
			{
				m_titleBarHOffset = value;
				
				onPropertiesChanged(TITLEBARALIGN);
			}
		}
		
		/**
		 * 标题栏水平对齐方式，可能的值：
		 * <ul>
		 * 	<li>Window.LEFT</li>
		 * 	<li>Window.RIGHT</li>
		 * 	<li>Window.CENTER</li>
		 * </ul>
		 */		
		public function get titleBarHAlign():String
		{
			return m_titleBarHAlign;
		}
		
		/** @private */
		public function set titleBarHAlign(value:String):void
		{
			if(m_titleBarHAlign != value && (value == LEFT || value == RIGHT || value == CENTER))
			{
				m_titleBarHAlign = value;
				
				onPropertiesChanged(TITLEBARALIGN);
			}
		}
		
		/**
		 * 标题栏垂直偏移量
		 */		
		public function get titleBarVOffset():int
		{
			return m_titleBarVOffset;
		}
		
		/** @private */
		public function set titleBarVOffset(value:int):void
		{
			if(m_titleBarVOffset != value)
			{
				m_titleBarVOffset = value;
				
				onPropertiesChanged(TITLEBARALIGN);
			}
		}
		
		/**
		 * 标题栏垂直对齐方式，可能的值：
		 * <ul>
		 * 	<li>Window.TOP</li>
		 * 	<li>Window.BOTTOM</li>
		 * 	<li>Window.MIDDLE</li>
		 * </ul>
		 */		
		public function get titleBarVAlign():String
		{
			return m_titleBarVAlign;
		}
		
		/** @private */
		public function set titleBarVAlign(value:String):void
		{
			if(m_titleBarVAlign != value && (value == TOP || value == BOTTOM || value == MIDDLE))
			{
				m_titleBarVAlign = value;
				
				onPropertiesChanged(TITLEBARALIGN);
			}
		}
		
		/**
		 * 内容容器的x坐标偏移量
		 */		
		public function get contentOffsetX():int
		{
			return m_contentOffsetX;
		}
		
		/** @private */
		public function set contentOffsetX(value:int):void
		{
			if(m_contentOffsetX != value)
			{
				m_contentOffsetX = value;
				
				onPropertiesChanged(CONTENTOFFSET);
			}
		}
		
		/**
		 * 内容容器的y坐标偏移量
		 */		
		public function get contentOffsetY():int
		{
			return m_contentOffsetY;
		}
		
		/** @private */
		public function set contentOffsetY(value:int):void
		{
			if(m_contentOffsetY != value)
			{
				m_contentOffsetY = value;
				
				onPropertiesChanged(CONTENTOFFSET);
			}
		}
		
		//==================================	TitleBar 组件属性	==================================
		
		
		
		/**
		 * 标题栏背景资源显示对象
		 */		
		public function get titleBackground():DisplayObject
		{
			return m_titleBar.background;
		}
		
		/** @private */
		public function set titleBackground(value:DisplayObject):void
		{
			if(m_titleBar.background != value)
			{
				m_titleBar.background = value;
				
				onPropertiesChanged(TITLEBARCHANGE);
			}
		}
		
		/**
		 * 标题文本或 titleView 的水平偏移量
		 */		
		public function get titleHOffset():int
		{
			return m_titleBar.hOffset;
		}
		
		/** @private */
		public function set titleHOffset(value:int):void
		{
			if(m_titleBar.hOffset != value)
			{
				m_titleBar.hOffset = value;
				
				onPropertiesChanged(TITLEBARCHANGE);
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
		public function get titleHAlign():String
		{
			return m_titleBar.hAlign;
		}
		
		/** @private */
		public function set titleHAlign(value:String):void
		{
			if(m_titleBar.hAlign != value && (value == LEFT || value == RIGHT || value == CENTER))
			{
				m_titleBar.hAlign = value;
				
				onPropertiesChanged(TITLEBARCHANGE);
			}
		}
		
		/**
		 * 标题文本或 titleView 的垂直偏移量
		 */		
		public function get titleVOffset():int
		{
			return m_titleBar.vOffset;
		}
		
		/** @private */
		public function set titleVOffset(value:int):void
		{
			if(m_titleBar.vOffset != value)
			{
				m_titleBar.vOffset = value;
				
				onPropertiesChanged(TITLEBARCHANGE);
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
		public function get titleVAlign():String
		{
			return m_titleBar.vAlign;
		}
		
		/** @private */
		public function set titleVAlign(value:String):void
		{
			if(m_titleBar.vAlign != value && (value == TOP || value == BOTTOM || value == MIDDLE))
			{
				m_titleBar.vAlign = value;
				
				onPropertiesChanged(TITLEBARCHANGE);
			}
		}
		
		/**
		 * 标题显示对象
		 */		
		public function get titleView():DisplayObject
		{
			return m_titleBar.titleView;
		}
		
		/** @private */
		public function set titleView(value:DisplayObject):void
		{
			if(m_titleBar.titleView != value)
			{
				m_titleBar.titleView = value;
				
				onPropertiesChanged(TITLEBARCHANGE);
			}
		}
		
		
		
		//==============================	Label组件属性	==============================
		
		
		/**
		 * 获取无标签的真实文本
		 */		
		public function get titleRealText():String
		{
			return m_titleBar.realText;
		}
		
		/**
		 * 要显示的文本对象 支持带xml标签的文本
		 * 其中xml标签可在styleSheet属性对象内定义CSS样式
		 */		
		public function get titleText():String
		{
			return m_titleBar.text;
		}
		
		/** @private */
		public function set titleText(value:String):void
		{
			if(m_titleBar.text != value && StringUtil.isNotNullOrEmpty(value))
			{
				m_titleBar.text = value;
				
				onPropertiesChanged(TITLEBARCHANGE);
			}
		}
		
		/**
		 * 设置文本颜色
		 * CSS样式会覆盖此设置
		 */		
		public function get titleTextColor():uint
		{
			return m_titleBar.textColor;
		}
		
		/** @private */
		public function set titleTextColor(value:uint):void
		{
			if(m_titleBar.textColor != value)
			{
				m_titleBar.textColor = value;
				
				onPropertiesChanged(TITLEBARCHANGE);
			}
		}
		
		/**
		 * 是否启用Html模式显示
		 */		
		public function get titleHtml():Boolean
		{
			return m_titleBar.html;
		}
		
		/** @private */
		public function set titleHtml(value:Boolean):void
		{
			if(m_titleBar.html != value)
			{
				m_titleBar.html = value;
				
				onPropertiesChanged(TITLEBARCHANGE);
			}
		}
		
		/**
		 * 获取或设置textFormat中字体是否为嵌入字体
		 */		
		public function get titleEmbedFonts():Boolean
		{
			return m_titleBar.embedFonts;
		}
		
		/** @private */
		public function set titleEmbedFonts(value:Boolean):void
		{
			if(m_titleBar.embedFonts != value)
			{
				m_titleBar.embedFonts = value;
				
				onPropertiesChanged(TITLEBARCHANGE);
			}
		}
		
		/**
		 * 获取或设置描述字符格式的设置信息。
		 */		
		public function get titleTextFormat():TextFormat
		{
			return m_titleBar.textFormat;
		}
		
		/** @private */
		public function set titleTextFormat(value:TextFormat):void
		{
			m_titleBar.textFormat = value;
			
			onPropertiesChanged(TITLEBARCHANGE);
		}
		
		/**
		 * CSS样式表。
		 * 当使用CSS样式时无论是否开启 Html 属性都会替换掉所有标签并使用已定义的样式显示。
		 */		
		public function get titleStyleSheet():StyleSheet
		{
			return m_titleBar.styleSheet;
		}
		
		/** @private */
		public function set titleStyleSheet(value:StyleSheet):void
		{
			m_titleBar.styleSheet = value;
			
			onPropertiesChanged(TITLEBARCHANGE);
		}
		
		/**
		 * 解析CSS样式文本 会覆盖掉已定义样式的对应属性。
		 * 当使用CSS样式时无论是否开启 Html 属性都会替换掉所有标签并使用已定义的样式显示。
		 * @param cssText CSS样式文本
		 */		
		public function titleParseCSS(cssText:String):StyleSheet
		{
			var style:StyleSheet = m_titleBar.parseCSS(cssText);
			
			onPropertiesChanged(TITLEBARCHANGE);
			
			return style;
		}

		
		//==============================	Label组件属性	==============================
		
		
		//==================================	TitleBar 组件属性	==================================
	}
}