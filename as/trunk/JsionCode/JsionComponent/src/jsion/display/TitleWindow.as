package jsion.display
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.StyleSheet;
	import flash.text.TextFormat;
	
	import jsion.comps.CompUtil;
	import jsion.ddrop.DDropMgr;
	import jsion.utils.StringUtil;

	/**
	 * 带标题的窗体
	 * @author Jsion
	 * 
	 */	
	public class TitleWindow extends Window
	{
		/**
		 * 宽度属性变更
		 */		
		public static const WIDTH:String = Window.WIDTH;
		/**
		 * 高度属性变更
		 */		
		public static const HEIGHT:String = Window.HEIGHT;
		/**
		 * 窗体背景显示对象发生变更
		 */		
		public static const BACKGROUND:String = Window.BACKGROUND;
		/**
		 * 关闭按钮对齐方式发生变更
		 */		
		public static const CLOSEALIGN:String = Window.CLOSEALIGN;
		/**
		 * 关闭按钮发生变更
		 */		
		public static const CLOSECHANGE:String = Window.CLOSECHANGE;
		/**
		 * 内容容器的坐标偏移量发生变更
		 */		
		public static const CONTENTOFFSET:String = Window.CONTENTOFFSET;
		
		/**
		 * 模态窗体阴影的宽度值
		 */		
		public static var MODALWIDTH:int = Window.MODALWIDTH;
		/**
		 * 模态窗体阴影的高度值
		 */		
		public static var MODALHEIGHT:int = Window.MODALHEIGHT;
		/**
		 * 模态窗体阴影的透明度
		 */		
		public static var MODALALPH:Number = Window.MODALALPH;
		/**
		 * 模态窗体阴影的颜色
		 */		
		public static var MODALCOLOR:uint = Window.MODALCOLOR;
		/**
		 * 标题栏对齐方式
		 */		
		public static const TITLEBARALIGN:String = "titleBarAlign";
		/**
		 * 标题栏发生变更
		 */		
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
		
		private var m_dragEnabled:Boolean;
		
		private var m_autoBring2Top:Boolean;
		
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
			
			m_dragEnabled = true;
			m_dragger = new TitleDragger(this);
			
			autoBring2Top = true;
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
		 * 是否显示标题栏
		 */		
		public function get titleBarVisible():Boolean
		{
			return m_titleBar.visible;
		}
		
		/** @private */
		public function set titleBarVisible(value:Boolean):void
		{
			m_titleBar.visible = value;
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
		//==================================	TitleDragger 组件属性	==================================
		
		
		/**
		 * 是否在标题拖拽辅助对象的 MouseDown 事件的时候交窗体提升到最顶层
		 */		
		public function get autoBring2Top():Boolean
		{
			return m_autoBring2Top;
		}
		
		/**
		 * @private
		 */		
		public function set autoBring2Top(value:Boolean):void
		{
			if(m_autoBring2Top != value)
			{
				m_autoBring2Top = value;
				
				if(m_autoBring2Top)
				{
					addEventListener(MouseEvent.MOUSE_DOWN, __mouseDownHandler);
				}
				else
				{
					removeEventListener(MouseEvent.MOUSE_DOWN, __mouseDownHandler);
				}
			}
		}
		
		
		private function __mouseDownHandler(e:MouseEvent):void
		{
			bring2Top();
		}
		
		//==================================	TitleDragger 组件属性	==================================
		
		//==================================	TitleBar 组件属性	==================================
		
		
		
		/**
		 * 标题栏宽度
		 */
		public function get titleBarWidth():int
		{
			return m_titleBar.width;
		}
		
		/** @private */
		public function set titleBarWidth(value:int):void
		{
			if(m_titleBar.width != value)
			{
				m_titleBar.width = value;
				
				onPropertiesChanged(TITLEBARCHANGE);
			}
		}
		
		/**
		 * 标题栏高度
		 */
		public function get titleBarHeight():int
		{
			return m_titleBar.height;
		}
		
		/** @private */
		public function set titleBarHeight(value:int):void
		{
			if(m_titleBar.height != value)
			{
				m_titleBar.height = value;
				
				onPropertiesChanged(TITLEBARCHANGE);
			}
		}
		
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
		
		/**
		 * 是否启动窗体拖动，默认为 true。
		 */		
		public function get dragEnabled():Boolean
		{
			return m_dragEnabled;
		}
		
		/** @private */
		public function set dragEnabled(value:Boolean):void
		{
			if(m_dragEnabled != value)
			{
				m_dragEnabled = value;
				
				if(m_dragEnabled)
				{
					DDropMgr.registeDrag(m_dragger);
				}
				else
				{
					DDropMgr.unregisteDrag(m_dragger);
				}
			}
		}
		
		
		//==================================	TitleBar 组件属性	==================================
		
		
		
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
	}
}