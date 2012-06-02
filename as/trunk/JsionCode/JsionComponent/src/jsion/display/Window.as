package jsion.display
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import jsion.comps.CompGlobal;
	import jsion.comps.CompUtil;
	import jsion.comps.Component;
	import jsion.utils.DisposeUtil;
	
	/**
	 * 无标题窗体
	 * @author Jsion
	 * 
	 */	
	public class Window extends Component
	{
		public static const BACKGROUND:String = "background";
		
		public static const CLOSEALIGN:String = "closeAlign";
		
		public static const CLOSECHANGE:String = "closeChange";
		
		public static const CONTENTOFFSET:String = "contentOffset";
		
		public static var MODALWIDTH:int = 2000;
		public static var MODALHEIGHT:int = 2000;
		public static var MODALALPH:Number = 0.5;
		public static var MODALCOLOR:uint = 0XCCCCCC;
		
		
		/**
		 * 水平左边对齐
		 */		
		public static const LEFT:String = CompGlobal.LEFT;
		
		/**
		 * 水平右边对齐
		 */		
		public static const RIGHT:String = CompGlobal.RIGHT;
		
		/**
		 * 垂直顶部对齐
		 */		
		public static const TOP:String = CompGlobal.TOP;
		
		/**
		 * 垂直底部对齐
		 */		
		public static const BOTTOM:String = CompGlobal.BOTTOM;

		
		/** @private */
		protected var m_freeBMD:Boolean;
		
		/** @private */
		protected var m_background:DisplayObject;
		
		/** @private */
		protected var m_closeButton:Button;
		
		/** @private */
		protected var m_closeHOffset:int;
		/** @private */
		protected var m_closeHAlign:String;
		
		/** @private */
		protected var m_closeVOffset:int;
		/** @private */
		protected var m_closeVAlign:String;
		
		/** @private */
		protected var m_content:Sprite;
		
		/** @private */
		protected var m_contentOffsetX:int;
		/** @private */
		protected var m_contentOffsetY:int;
		
		/** @private */
		protected var m_modal:Boolean;
		/** @private */
		protected var m_modalColor:uint;
		
		public function Window(modal:Boolean = false)
		{
			m_modal = modal;
			
			super();
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function initialize():void
		{
			super.initialize();
			
			m_closeVAlign = TOP;
			m_closeHAlign = RIGHT;
			
			m_closeButton = new Button();
			
			m_content = new Sprite();
			
			if(m_modal)
			{
				graphics.clear();
				graphics.beginFill(MODALCOLOR, MODALALPH);
				graphics.drawRect(-MODALWIDTH, -MODALHEIGHT, MODALWIDTH * 3, MODALHEIGHT * 3);
				graphics.endFill();
			}
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function initEvents():void
		{
			super.initEvents();
			
			m_closeButton.addEventListener(MouseEvent.CLICK, __mouseClickHandler);
		}
		
		private function __mouseClickHandler(e:MouseEvent):void
		{
			// TODO Auto-generated method stub
			
			close();
		}
		
		public function addToContent(child:DisplayObject):void
		{
			m_content.addChild(child);
		}
		
		public function close():void
		{
			onClosed();
			
			DisposeUtil.free(this);
		}
		
		protected function onClosed():void
		{
			
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function onProppertiesUpdate():void
		{
			super.onProppertiesUpdate();
			
			updateBackground();
			
			updateCloseButton();
			
			updateContent();
		}
		
		private function updateBackground():void
		{
			// TODO Auto Generated method stub
			if(isChanged(BACKGROUND) || isChanged(WIDTH) || isChanged(HEIGHT))
			{
				if(m_background)
				{
					m_background.width = m_width;
					m_background.height = m_height;
				}
			}
		}
		
		private function updateCloseButton():void
		{
			// TODO Auto Generated method stub
			
			var rect:Rectangle = new Rectangle();
			
			rect.width = m_closeButton.width;
			rect.height = m_closeButton.height;
			
			CompUtil.layoutPosition(m_width, m_height, m_closeHAlign, m_closeHOffset, m_closeVAlign, m_closeVOffset, rect);
			
			m_closeButton.x = rect.x;
			m_closeButton.y = rect.y;
		}
		
		private function updateContent():void
		{
			// TODO Auto Generated method stub
			
			if(isChanged(CONTENTOFFSET))
			{
				m_content.x = m_contentOffsetX;
				m_content.y = m_contentOffsetY;
			}
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function addChildren():void
		{
			super.addChildren();
			
			if(m_background) addChild(m_background);
			
			addChild(m_closeButton);
			
			addChild(m_content);
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function dispose():void
		{
			DisposeUtil.free(m_background, m_freeBMD);
			m_background = null;
			
			DisposeUtil.freeChildren(m_content);
			DisposeUtil.free(m_content);
			m_content = null;
			
			m_closeButton = null;
			
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
			
			m_closeButton.freeBMD = value;
		}

		/**
		 * 窗口背景面板资源，如果宽度或高度未设置则将以前资源宽度或高度设置对应的值。
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
		 * 关闭按钮的水平偏移量
		 */
		public function get closeHOffset():int
		{
			return m_closeHOffset;
		}
		
		/** @private */
		public function set closeHOffset(value:int):void
		{
			if(m_closeHOffset != value)
			{
				m_closeHOffset = value;
				
				onPropertiesChanged(CLOSEALIGN);
			}
		}

		/**
		 * 关闭按钮的水平对齐方式，可能的值：
		 * <ul>
		 * 	<li>Window.LEFT</li>
		 * 	<li>Window.RIGHT</li>
		 * 	<li>Window.CENTER</li>
		 * </ul>
		 */		
		public function get closeHAlign():String
		{
			return m_closeHAlign;
		}
		
		/** @private */
		public function set closeHAlign(value:String):void
		{
			if(m_closeHAlign != value && (value == LEFT || value == RIGHT))
			{
				m_closeHAlign = value;
				
				onPropertiesChanged(CLOSEALIGN);
			}
		}

		/**
		 * 关闭按钮的垂直偏移量
		 */		
		public function get closeVOffset():int
		{
			return m_closeVOffset;
		}
		
		/** @private */
		public function set closeVOffset(value:int):void
		{
			if(m_closeVOffset != value)
			{
				m_closeVOffset = value;
				
				onPropertiesChanged(CLOSEALIGN);
			}
		}

		/**
		 * 关闭按钮的垂直对齐方式，可能的值：
		 * <ul>
		 * 	<li>Window.TOP</li>
		 * 	<li>Window.BOTTOM</li>
		 * 	<li>Window.MIDDLE</li>
		 * </ul>
		 */		
		public function get closeVAlign():String
		{
			return m_closeVAlign;
		}
		
		/** @private */
		public function set closeVAlign(value:String):void
		{
			if(m_closeVAlign != value && (value == TOP || value == BOTTOM))
			{
				m_closeVAlign = value;
				
				onPropertiesChanged(CLOSEALIGN);
			}
		}
		
		//======================================	按钮 组件属性		======================================
		
		/**
		 * 按钮弹起时的显示对象资源
		 * 如果宽度和高度未设置时会根据此显示对象的宽高来设置对应的值
		 */		
		public function get closeUpImage():DisplayObject
		{
			return m_closeButton.upImage;
		}
		
		/** @private */
		public function set closeUpImage(value:DisplayObject):void
		{
			if(m_closeButton.upImage != value)
			{
				m_closeButton.upImage = value;
				
				onPropertiesChanged(CLOSECHANGE);
			}
		}
		
		/**
		 * 按钮鼠标经过时的显示对象资源
		 */		
		public function get closeOverImage():DisplayObject
		{
			return m_closeButton.overImage;
		}
		
		/** @private */
		public function set closeOverImage(value:DisplayObject):void
		{
			if(m_closeButton.overImage != value)
			{
				m_closeButton.overImage = value;
				
				onPropertiesChanged(CLOSECHANGE);
			}
		}
		
		/**
		 * 按钮按下时的显示对象资源
		 */		
		public function get closeDownImage():DisplayObject
		{
			return m_closeButton.downImage;
		}
		
		/** @private */
		public function set closeDownImage(value:DisplayObject):void
		{
			if(m_closeButton.downImage != value)
			{
				m_closeButton.downImage = value;
				
				onPropertiesChanged(CLOSECHANGE);
			}
		}
		
		/**
		 * 按钮禁用时的显示对象资源
		 */		
		public function get closeDisableImage():DisplayObject
		{
			return m_closeButton.disableImage;
		}
		
		/** @private */
		public function set closeDisableImage(value:DisplayObject):void
		{
			if(m_closeButton.disableImage != value)
			{
				m_closeButton.disableImage = value;
				
				onPropertiesChanged(CLOSECHANGE);
			}
		}
		
		/**
		 * 按钮弹起时的滤镜对象
		 */		
		public function get closeUpFilters():Array
		{
			return m_closeButton.upFilters;
		}
		
		/** @private */
		public function set closeUpFilters(value:Array):void
		{
			if(m_closeButton.upFilters != value)
			{
				m_closeButton.upFilters = value;
				
				onPropertiesChanged(CLOSECHANGE);
			}
		}
		
		/**
		 * 按钮鼠标经过时的滤镜对象
		 */		
		public function get closeOverFilters():Array
		{
			return m_closeButton.overFilters;
		}
		
		/** @private */
		public function set closeOverFilters(value:Array):void
		{
			if(m_closeButton.overFilters != value)
			{
				m_closeButton.overFilters = value;
				
				onPropertiesChanged(CLOSECHANGE);
			}
		}
		
		/**
		 * 按钮按下时的滤镜对象
		 */		
		public function get closeDownFilters():Array
		{
			return m_closeButton.downFilters;
		}
		
		/** @private */
		public function set closeDownFilters(value:Array):void
		{
			if(m_closeButton.downFilters != value)
			{
				m_closeButton.downFilters = value;
				
				onPropertiesChanged(CLOSECHANGE);
			}
		}
		
		/**
		 * 按钮禁用时的滤镜对象
		 */		
		public function get closeDisableFilters():Array
		{
			return m_closeButton.disableFilters;
		}
		
		/** @private */
		public function set closeDisableFilters(value:Array):void
		{
			if(m_closeButton.disableFilters != value)
			{
				m_closeButton.disableFilters = value;
				
				onPropertiesChanged(CLOSECHANGE);
			}
		}
		
		/**
		 * 按钮状态显示对象x坐标偏移量
		 */
		public function get closeOffsetX():int
		{
			return m_closeButton.offsetX;
		}
		
		/** @private */
		public function set closeOffsetX(value:int):void
		{
			if(m_closeButton.offsetX != value)
			{
				m_closeButton.offsetX = value;
				
				onPropertiesChanged(CLOSECHANGE);
			}
		}
		
		/**
		 * 按钮状态显示对象y坐标偏移量
		 */
		public function get closeOffsetY():int
		{
			return m_closeButton.offsetY;
		}
		
		/** @private */
		public function set closeOffsetY(value:int):void
		{
			if(m_closeButton.offsetY != value)
			{
				m_closeButton.offsetY = value;
				
				onPropertiesChanged(CLOSECHANGE);
			}
		}
		
		/**
		 * 按钮鼠标经过时状态显示对象x坐标偏移量
		 */
		public function get closeOverOffsetX():int
		{
			return m_closeButton.overOffsetX;
		}
		
		/** @private */
		public function set closeOverOffsetX(value:int):void
		{
			if(m_closeButton.overOffsetX != value)
			{
				m_closeButton.overOffsetX = value;
				
				onPropertiesChanged(CLOSECHANGE);
			}
		}
		
		/**
		 * 按钮鼠标经过时状态显示对象y坐标偏移量
		 */
		public function get closeOverOffsetY():int
		{
			return m_closeButton.overOffsetY;
		}
		
		/** @private */
		public function set closeOverOffsetY(value:int):void
		{
			if(m_closeButton.overOffsetY != value)
			{
				m_closeButton.overOffsetY = value;
				
				onPropertiesChanged(CLOSECHANGE);
			}
		}
		
		/**
		 * 按钮按下时状态显示对象x坐标偏移量
		 */
		public function get closeDownOffsetX():int
		{
			return m_closeButton.downOffsetX;
		}
		
		/** @private */
		public function set closeDownOffsetX(value:int):void
		{
			if(m_closeButton.downOffsetX != value)
			{
				m_closeButton.downOffsetX = value;
				
				onPropertiesChanged(CLOSECHANGE);
			}
		}
		
		/**
		 * 按钮按下时状态显示对象y坐标偏移量
		 */
		public function get closeDownOffsetY():int
		{
			return m_closeButton.downOffsetY;
		}
		
		/** @private */
		public function set closeDownOffsetY(value:int):void
		{
			if(m_closeButton.downOffsetY != value)
			{
				m_closeButton.downOffsetY = value;
				
				onPropertiesChanged(CLOSECHANGE);
			}
		}
		
		//======================================	按钮 组件属性		======================================
	}
}