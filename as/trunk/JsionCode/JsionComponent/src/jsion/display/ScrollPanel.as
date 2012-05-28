package jsion.display
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import jsion.comps.Component;
	import jsion.events.DisplayEvent;
	import jsion.utils.DisposeUtil;
	
	/**
	 * 带滚动条的面板, 需要设置宽度和高度后才能显示。
	 * @author Jsion
	 * 
	 */	
	public class ScrollPanel extends Component
	{
		public static const SCROLLPOS:String = "scrollPos";
		
		public static const SCROLLBAR:String = "scrollBar";
		
		public static const SCROLLVIEW:String = "scrollView";
		
		/**
		 * 水平滚动
		 */		
		public static const HORIZONTAL:int = ScrollBar.HORIZONTAL;
		
		/**
		 * 垂直滚动
		 */		
		public static const VERTICAL:int = ScrollBar.VERTICAL;
		
		public static const INSIDE:int = 1;
		
		public static const OUTSIDE:int = 2;
		
		
		protected var m_scrollView:DisplayObject;
		
		protected var m_scrollBar:ScrollBar;
		
		private var m_freeBMD:Boolean;
		
		protected var m_scrollType:int;
		
		private var m_scrollPos:int;
		
		private var m_viewRect:Rectangle;
		
		public function ScrollPanel(scrollType:int = VERTICAL)
		{
			m_scrollType = scrollType;
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function beginChanges():void
		{
			m_scrollBar.beginChanges();
			
			super.beginChanges();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function commitChanges():void
		{
			m_scrollBar.commitChanges();
			
			super.commitChanges();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function initialize():void
		{
			super.initialize();
			
			m_scrollPos = INSIDE;
			
			m_viewRect = new Rectangle();
			scrollRect = m_viewRect;
			
			m_scrollBar = new ScrollBar(m_scrollType);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function addChildren():void
		{
			super.addChildren();
			
			addChild(m_scrollView);
			
			addChild(m_scrollBar);
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function initEvents():void
		{
			super.initEvents();
			
			addEventListener(MouseEvent.MOUSE_WHEEL, __panelMouseWheelHandler);
			
			m_scrollBar.addEventListener(DisplayEvent.CHANGED, __scrollValueChangedHandler);
		}
		
		private function __panelMouseWheelHandler(e:MouseEvent):void
		{
			e.stopPropagation();
			
			if(e.delta > 0)
			{
				scrollValue = scrollValue - wheelStep;
			}
			else
			{
				scrollValue = scrollValue + wheelStep;
			}
		}
		
		private function __scrollValueChangedHandler(e:DisplayEvent):void
		{
			if(m_scrollView)
			{
				if(m_scrollType == VERTICAL)
				{
					m_scrollView.y = -scrollValue;
				}
				else
				{
					m_scrollView.x = -scrollValue;
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function onProppertiesUpdate():void
		{
			super.onProppertiesUpdate();
			
			updateScrollBarPos();
			
			updateScrollViewPos();
			
			updateViewRectangle();
		}
		
		private function updateScrollBarPos():void
		{
			if(isChanged(SCROLLBAR) || isChanged(SCROLLPOS) || isChanged(WIDTH) || isChanged(HEIGHT))
			{
				if(m_scrollType == VERTICAL)
				{
					if(m_scrollPos == INSIDE)
					{
						m_scrollBar.x = m_width - m_scrollBar.width;
					}
					else
					{
						m_scrollBar.x = m_width;
					}
				}
				else
				{
					if(m_scrollPos == INSIDE)
					{
						m_scrollBar.y = m_height - m_scrollBar.height;
					}
					else
					{
						m_scrollBar.y = m_height;
					}
				}
			}
		}
		
		private function updateScrollViewPos():void
		{
			if(isChanged(SCROLLVIEW) && m_scrollView)
			{
				if(m_scrollType == VERTICAL)
				{
					m_scrollView.y = m_scrollBar.scrollValue;
				}
				else
				{
					m_scrollView.x = m_scrollBar.scrollValue;
				}
			}
		}
		
		private function updateViewRectangle():void
		{
			if(isChanged(WIDTH) || isChanged(HEIGHT))
			{
				m_viewRect.x = 0;
				m_viewRect.y = 0;
				
				graphics.clear();
				graphics.beginFill(0, 0);
				
				if(m_scrollType == VERTICAL)
				{
					if(m_scrollPos == INSIDE)
					{
						m_viewRect.width = m_width;
						graphics.drawRect(0, 0, m_width, m_height);
					}
					else
					{
						m_viewRect.width = m_width + m_scrollBar.width;
						graphics.drawRect(0, 0, m_width + m_scrollBar.width, m_height);
					}
					m_viewRect.height = m_height;
				}
				else
				{
					m_viewRect.width = m_width;
					
					if(m_scrollPos == INSIDE)
					{
						m_viewRect.height = m_height;
						graphics.drawRect(0, 0, m_width, m_height);
					}
					else
					{
						m_viewRect.height = m_height + m_scrollBar.height;
						graphics.drawRect(0, 0, m_width, m_height + m_scrollBar.height);
					}
				}
				
				graphics.endFill();
				
				scrollRect = m_viewRect;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set width(value:Number):void
		{
			super.width = value;
			
			if(m_scrollType == HORIZONTAL)
			{
				m_scrollBar.width = value;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set height(value:Number):void
		{
			super.height = value;
			
			if(m_scrollType == VERTICAL)
			{
				m_scrollBar.height = value;
			}
		}

		/**
		 * 滚动条位置类型，可能的值：
		 * <ul>
		 * 	<li>ScrollPanel.INSIDE 包含在设置的宽度内</li>
		 * 	<li>ScrollPanel.OUTSIDE 包含在设置的宽度外</li>
		 * </ul>
		 * 默认ScrollPanel.INSIDE。
		 */		
		public function get scrollPos():int
		{
			return m_scrollPos;
		}

		/** @private */
		public function set scrollPos(value:int):void
		{
			if(m_scrollPos != value && (value == INSIDE || value == OUTSIDE))
			{
				m_scrollPos = value;
				
				onPropertiesChanged(SCROLLPOS);
			}
		}

		/**
		 * 要滚动的显示对象
		 */		
		public function get scrollView():DisplayObject
		{
			return m_scrollView;
		}
		
		/** @private */
		public function set scrollView(value:DisplayObject):void
		{
			if(m_scrollView != value)
			{
				DisposeUtil.free(m_scrollView);
				
				m_scrollView = value;
				
				if(m_scrollType == VERTICAL)
				{
					viewSize = m_scrollView.height;
				}
				else
				{
					viewSize = m_scrollView.width;
				}
				
				onPropertiesChanged(SCROLLVIEW);
			}
		}
		
		
		
		//======================================	ScrollBar相关属性	======================================
		
		
		
		/**
		 * @copy jsion.display.ScrollBar#background
		 */		
		public function get scrollBarBackground():BitmapData
		{
			return m_scrollBar.background;
		}
		
		/** @private */
		public function set scrollBarBackground(value:BitmapData):void
		{
			if(m_scrollBar.background != value)
			{
				m_scrollBar.background = value;
				
				onPropertiesChanged(SCROLLBAR);
			}
		}
		
		/**
		 * @copy jsion.display.ScrollBar#UpOrLeftBtnUpAsset
		 */		
		public function get UpOrLeftBtnUpAsset():DisplayObject
		{
			return m_scrollBar.UpOrLeftBtnUpAsset;
		}
		
		/** @private */
		public function set UpOrLeftBtnUpAsset(value:DisplayObject):void
		{
			if(m_scrollBar.UpOrLeftBtnUpAsset != value)
			{
				m_scrollBar.UpOrLeftBtnUpAsset = value;
				
				onPropertiesChanged(SCROLLBAR);
			}
		}
		
		/**
		 * @copy jsion.display.ScrollBar#UpOrLeftBtnOverAsset
		 */		
		public function get UpOrLeftBtnOverAsset():DisplayObject
		{
			return m_scrollBar.UpOrLeftBtnOverAsset;
		}
		
		/** @private */
		public function set UpOrLeftBtnOverAsset(value:DisplayObject):void
		{
			if(m_scrollBar.UpOrLeftBtnOverAsset != value)
			{
				m_scrollBar.UpOrLeftBtnOverAsset = value;
				
				onPropertiesChanged(SCROLLBAR);
			}
		}
		
		/**
		 * @copy jsion.display.ScrollBar#UpOrLeftBtnDownAsset
		 */		
		public function get UpOrLeftBtnDownAsset():DisplayObject
		{
			return m_scrollBar.UpOrLeftBtnDownAsset;
		}
		
		/** @private */
		public function set UpOrLeftBtnDownAsset(value:DisplayObject):void
		{
			if(m_scrollBar.UpOrLeftBtnDownAsset != value)
			{
				m_scrollBar.UpOrLeftBtnDownAsset = value;
				
				onPropertiesChanged(SCROLLBAR);
			}
		}
		
		/**
		 * @copy jsion.display.ScrollBar#UpOrLeftBtnDisableAsset
		 */		
		public function get UpOrLeftBtnDisableAsset():DisplayObject
		{
			return m_scrollBar.UpOrLeftBtnDisableAsset;
		}
		
		/** @private */
		public function set UpOrLeftBtnDisableAsset(value:DisplayObject):void
		{
			if(m_scrollBar.UpOrLeftBtnDisableAsset != value)
			{
				m_scrollBar.UpOrLeftBtnDisableAsset = value;
				
				onPropertiesChanged(SCROLLBAR);
			}
		}
		
		/**
		 * @copy jsion.display.ScrollBar#UpOrLeftBtnUpFilters
		 */		
		public function get UpOrLeftBtnUpFilters():Array
		{
			return m_scrollBar.UpOrLeftBtnUpFilters;
		}
		
		/** @private */
		public function set UpOrLeftBtnUpFilters(value:Array):void
		{
			if(m_scrollBar.UpOrLeftBtnUpFilters != value)
			{
				m_scrollBar.UpOrLeftBtnUpFilters = value;
			}
		}
		
		/**
		 * @copy jsion.display.ScrollBar#UpOrLeftBtnOverFilters
		 */		
		public function get UpOrLeftBtnOverFilters():Array
		{
			return m_scrollBar.UpOrLeftBtnOverFilters;
		}
		
		/** @private */
		public function set UpOrLeftBtnOverFilters(value:Array):void
		{
			if(m_scrollBar.UpOrLeftBtnOverFilters != value)
			{
				m_scrollBar.UpOrLeftBtnOverFilters = value;
			}
		}
		
		/**
		 * @copy jsion.display.ScrollBar#UpOrLeftBtnDownFilters
		 */		
		public function get UpOrLeftBtnDownFilters():Array
		{
			return m_scrollBar.UpOrLeftBtnDownFilters;
		}
		
		/** @private */
		public function set UpOrLeftBtnDownFilters(value:Array):void
		{
			if(m_scrollBar.UpOrLeftBtnDownFilters != value)
			{
				m_scrollBar.UpOrLeftBtnDownFilters = value;
			}
		}
		
		/**
		 * @copy jsion.display.ScrollBar#UpOrLeftBtnDisableFilters
		 */		
		public function get UpOrLeftBtnDisableFilters():Array
		{
			return m_scrollBar.UpOrLeftBtnDisableFilters;
		}
		
		/** @private */
		public function set UpOrLeftBtnDisableFilters(value:Array):void
		{
			if(m_scrollBar.UpOrLeftBtnDisableFilters != value)
			{
				m_scrollBar.UpOrLeftBtnDisableFilters = value;
			}
		}
		
		/**
		 * @copy jsion.display.ScrollBar#UpOrLeftBtnImageOffsetX
		 */		
		public function get UpOrLeftBtnImageOffsetX():int
		{
			return m_scrollBar.UpOrLeftBtnImageOffsetX;
		}
		
		/** @private */
		public function set UpOrLeftBtnImageOffsetX(value:int):void
		{
			if(m_scrollBar.UpOrLeftBtnImageOffsetX != value)
			{
				m_scrollBar.UpOrLeftBtnImageOffsetX = value;
			}
		}
		
		/**
		 * @copy jsion.display.ScrollBar#UpOrLeftBtnImageOffsetY
		 */		
		public function get UpOrLeftBtnImageOffsetY():int
		{
			return m_scrollBar.UpOrLeftBtnImageOffsetY;
		}
		
		/** @private */
		public function set UpOrLeftBtnImageOffsetY(value:int):void
		{
			if(m_scrollBar.UpOrLeftBtnImageOffsetY != value)
			{
				m_scrollBar.UpOrLeftBtnImageOffsetY = value;
			}
		}
		
		/**
		 * @copy jsion.display.ScrollBar#UpOrLeftBtnImageOverOffsetX
		 */		
		public function get UpOrLeftBtnImageOverOffsetX():int
		{
			return m_scrollBar.UpOrLeftBtnImageOverOffsetX;
		}
		
		/** @private */
		public function set UpOrLeftBtnImageOverOffsetX(value:int):void
		{
			if(m_scrollBar.UpOrLeftBtnImageOverOffsetX != value)
			{
				m_scrollBar.UpOrLeftBtnImageOverOffsetX = value;
			}
		}
		
		/**
		 * @copy jsion.display.ScrollBar#UpOrLeftBtnImageOverOffsetY
		 */		
		public function get UpOrLeftBtnImageOverOffsetY():int
		{
			return m_scrollBar.UpOrLeftBtnImageOverOffsetY;
		}
		
		/** @private */
		public function set UpOrLeftBtnImageOverOffsetY(value:int):void
		{
			if(m_scrollBar.UpOrLeftBtnImageOverOffsetY != value)
			{
				m_scrollBar.UpOrLeftBtnImageOverOffsetY = value;
			}
		}
		
		/**
		 * @copy jsion.display.ScrollBar#UpOrLeftBtnImageDownOffsetX
		 */		
		public function get UpOrLeftBtnImageDownOffsetX():int
		{
			return m_scrollBar.UpOrLeftBtnImageDownOffsetX;
		}
		
		/** @private */
		public function set UpOrLeftBtnImageDownOffsetX(value:int):void
		{
			if(m_scrollBar.UpOrLeftBtnImageDownOffsetX != value)
			{
				m_scrollBar.UpOrLeftBtnImageDownOffsetX = value;
			}
		}
		
		/**
		 * @copy jsion.display.ScrollBar#UpOrLeftBtnImageDownOffsetY
		 */		
		public function get UpOrLeftBtnImageDownOffsetY():int
		{
			return m_scrollBar.UpOrLeftBtnImageDownOffsetY;
		}
		
		/** @private */
		public function set UpOrLeftBtnImageDownOffsetY(value:int):void
		{
			if(m_scrollBar.UpOrLeftBtnImageDownOffsetY != value)
			{
				m_scrollBar.UpOrLeftBtnImageDownOffsetY = value;
			}
		}
		
		
		
		
		
		
		
		
		
		
		/**
		 * @copy jsion.display.ScrollBar#DownOrRightBtnUpAsset
		 */		
		public function get DownOrRightBtnUpAsset():DisplayObject
		{
			return m_scrollBar.DownOrRightBtnUpAsset;
		}
		
		/** @private */
		public function set DownOrRightBtnUpAsset(value:DisplayObject):void
		{
			if(m_scrollBar.DownOrRightBtnUpAsset != value)
			{
				m_scrollBar.DownOrRightBtnUpAsset = value;
				
				onPropertiesChanged(SCROLLBAR);
			}
		}
		
		/**
		 * @copy jsion.display.ScrollBar#DownOrRightBtnOverAsset
		 */		
		public function get DownOrRightBtnOverAsset():DisplayObject
		{
			return m_scrollBar.DownOrRightBtnOverAsset;
		}
		
		/** @private */
		public function set DownOrRightBtnOverAsset(value:DisplayObject):void
		{
			if(m_scrollBar.DownOrRightBtnOverAsset != value)
			{
				m_scrollBar.DownOrRightBtnOverAsset = value;
				
				onPropertiesChanged(SCROLLBAR);
			}
		}
		
		/**
		 * @copy jsion.display.ScrollBar#DownOrRightBtnDownAsset
		 */		
		public function get DownOrRightBtnDownAsset():DisplayObject
		{
			return m_scrollBar.DownOrRightBtnDownAsset;
		}
		
		/** @private */
		public function set DownOrRightBtnDownAsset(value:DisplayObject):void
		{
			if(m_scrollBar.DownOrRightBtnDownAsset != value)
			{
				m_scrollBar.DownOrRightBtnDownAsset = value;
				
				onPropertiesChanged(SCROLLBAR);
			}
		}
		
		/**
		 * @copy jsion.display.ScrollBar#DownOrRightBtnDisableAsset
		 */		
		public function get DownOrRightBtnDisableAsset():DisplayObject
		{
			return m_scrollBar.DownOrRightBtnDisableAsset;
		}
		
		/** @private */
		public function set DownOrRightBtnDisableAsset(value:DisplayObject):void
		{
			if(m_scrollBar.DownOrRightBtnDisableAsset != value)
			{
				m_scrollBar.DownOrRightBtnDisableAsset = value;
				
				onPropertiesChanged(SCROLLBAR);
			}
		}
		
		/**
		 * @copy jsion.display.ScrollBar#DownOrRightBtnUpFilters
		 */		
		public function get DownOrRightBtnUpFilters():Array
		{
			return m_scrollBar.DownOrRightBtnUpFilters;
		}
		
		/** @private */
		public function set DownOrRightBtnUpFilters(value:Array):void
		{
			if(m_scrollBar.DownOrRightBtnUpFilters != value)
			{
				m_scrollBar.DownOrRightBtnUpFilters = value;
			}
		}
		
		/**
		 * @copy jsion.display.ScrollBar#DownOrRightBtnOverFilters
		 */		
		public function get DownOrRightBtnOverFilters():Array
		{
			return m_scrollBar.DownOrRightBtnOverFilters;
		}
		
		/** @private */
		public function set DownOrRightBtnOverFilters(value:Array):void
		{
			if(m_scrollBar.DownOrRightBtnOverFilters != value)
			{
				m_scrollBar.DownOrRightBtnOverFilters = value;
			}
		}
		
		/**
		 * @copy jsion.display.ScrollBar#DownOrRightBtnDownFilters
		 */		
		public function get DownOrRightBtnDownFilters():Array
		{
			return m_scrollBar.DownOrRightBtnDownFilters;
		}
		
		/** @private */
		public function set DownOrRightBtnDownFilters(value:Array):void
		{
			if(m_scrollBar.DownOrRightBtnDownFilters != value)
			{
				m_scrollBar.DownOrRightBtnDownFilters = value;
			}
		}
		
		/**
		 * @copy jsion.display.ScrollBar#DownOrRightBtnDisableFilters
		 */		
		public function get DownOrRightBtnDisableFilters():Array
		{
			return m_scrollBar.DownOrRightBtnDisableFilters;
		}
		
		/** @private */
		public function set DownOrRightBtnDisableFilters(value:Array):void
		{
			if(m_scrollBar.DownOrRightBtnDisableFilters != value)
			{
				m_scrollBar.DownOrRightBtnDisableFilters = value;
			}
		}
		
		/**
		 * @copy jsion.display.ScrollBar#DownOrRightBtnImageOffsetX
		 */		
		public function get DownOrRightBtnImageOffsetX():int
		{
			return m_scrollBar.DownOrRightBtnImageOffsetX;
		}
		
		/** @private */
		public function set DownOrRightBtnImageOffsetX(value:int):void
		{
			if(m_scrollBar.DownOrRightBtnImageOffsetX != value)
			{
				m_scrollBar.DownOrRightBtnImageOffsetX = value;
			}
		}
		
		/**
		 * @copy jsion.display.ScrollBar#DownOrRightBtnImageOffsetY
		 */		
		public function get DownOrRightBtnImageOffsetY():int
		{
			return m_scrollBar.DownOrRightBtnImageOffsetY;
		}
		
		/** @private */
		public function set DownOrRightBtnImageOffsetY(value:int):void
		{
			if(m_scrollBar.DownOrRightBtnImageOffsetY != value)
			{
				m_scrollBar.DownOrRightBtnImageOffsetY = value;
			}
		}
		
		/**
		 * @copy jsion.display.ScrollBar#DownOrRightBtnImageOverOffsetX
		 */		
		public function get DownOrRightBtnImageOverOffsetX():int
		{
			return m_scrollBar.DownOrRightBtnImageOverOffsetX;
		}
		
		/** @private */
		public function set DownOrRightBtnImageOverOffsetX(value:int):void
		{
			if(m_scrollBar.DownOrRightBtnImageOverOffsetX != value)
			{
				m_scrollBar.DownOrRightBtnImageOverOffsetX = value;
			}
		}
		
		/**
		 * @copy jsion.display.ScrollBar#DownOrRightBtnImageOverOffsetY
		 */		
		public function get DownOrRightBtnImageOverOffsetY():int
		{
			return m_scrollBar.DownOrRightBtnImageOverOffsetY;
		}
		
		/** @private */
		public function set DownOrRightBtnImageOverOffsetY(value:int):void
		{
			if(m_scrollBar.DownOrRightBtnImageOverOffsetY != value)
			{
				m_scrollBar.DownOrRightBtnImageOverOffsetY = value;
			}
		}
		
		/**
		 * @copy jsion.display.ScrollBar#DownOrRightBtnImageDownOffsetX
		 */		
		public function get DownOrRightBtnImageDownOffsetX():int
		{
			return m_scrollBar.DownOrRightBtnImageDownOffsetX;
		}
		
		/** @private */
		public function set DownOrRightBtnImageDownOffsetX(value:int):void
		{
			if(m_scrollBar.DownOrRightBtnImageDownOffsetX != value)
			{
				m_scrollBar.DownOrRightBtnImageDownOffsetX = value;
			}
		}
		
		/**
		 * @copy jsion.display.ScrollBar#DownOrRightBtnImageDownOffsetY
		 */		
		public function get DownOrRightBtnImageDownOffsetY():int
		{
			return m_scrollBar.DownOrRightBtnImageDownOffsetY;
		}
		
		/** @private */
		public function set DownOrRightBtnImageDownOffsetY(value:int):void
		{
			if(m_scrollBar.DownOrRightBtnImageDownOffsetY != value)
			{
				m_scrollBar.DownOrRightBtnImageDownOffsetY = value;
			}
		}
		
		
		
		
		
		
		
		
		
		/**
		 * @copy jsion.display.ScrollBar#BarUpAsset
		 */		
		public function get BarUpAsset():DisplayObject
		{
			return m_scrollBar.BarUpAsset;
		}
		
		/** @private */
		public function set BarUpAsset(value:DisplayObject):void
		{
			if(m_scrollBar.BarUpAsset != value)
			{
				m_scrollBar.BarUpAsset = value;
				
				onPropertiesChanged(SCROLLBAR);
			}
		}
		
		/**
		 * @copy jsion.display.ScrollBar#BarOverAsset
		 */		
		public function get BarOverAsset():DisplayObject
		{
			return m_scrollBar.BarOverAsset;
		}
		
		/** @private */
		public function set BarOverAsset(value:DisplayObject):void
		{
			if(m_scrollBar.BarOverAsset != value)
			{
				m_scrollBar.BarOverAsset = value;
				
				onPropertiesChanged(SCROLLBAR);
			}
		}
		
		/**
		 * @copy jsion.display.ScrollBar#BarDownAsset
		 */		
		public function get BarDownAsset():DisplayObject
		{
			return m_scrollBar.BarDownAsset;
		}
		
		/** @private */
		public function set BarDownAsset(value:DisplayObject):void
		{
			if(m_scrollBar.BarDownAsset != value)
			{
				m_scrollBar.BarDownAsset = value;
				
				onPropertiesChanged(SCROLLBAR);
			}
		}
		
		/**
		 * @copy jsion.display.ScrollBar#BarDisableAsset
		 */		
		public function get BarDisableAsset():DisplayObject
		{
			return m_scrollBar.BarDisableAsset;
		}
		
		/** @private */
		public function set BarDisableAsset(value:DisplayObject):void
		{
			if(m_scrollBar.BarDisableAsset != value)
			{
				m_scrollBar.BarDisableAsset = value;
				
				onPropertiesChanged(SCROLLBAR);
			}
		}
		
		/**
		 * @copy jsion.display.ScrollBar#BarUpFilters
		 */		
		public function get BarUpFilters():Array
		{
			return m_scrollBar.BarUpFilters;
		}
		
		/** @private */
		public function set BarUpFilters(value:Array):void
		{
			if(m_scrollBar.BarUpFilters != value)
			{
				m_scrollBar.BarUpFilters = value;
			}
		}
		
		/**
		 * @copy jsion.display.ScrollBar#BarOverFilters
		 */		
		public function get BarOverFilters():Array
		{
			return m_scrollBar.BarOverFilters;
		}
		
		/** @private */
		public function set BarOverFilters(value:Array):void
		{
			if(m_scrollBar.BarOverFilters != value)
			{
				m_scrollBar.BarOverFilters = value;
			}
		}
		
		/**
		 * @copy jsion.display.ScrollBar#BarDownFilters
		 */		
		public function get BarDownFilters():Array
		{
			return m_scrollBar.BarDownFilters;
		}
		
		/** @private */
		public function set BarDownFilters(value:Array):void
		{
			if(m_scrollBar.BarDownFilters != value)
			{
				m_scrollBar.BarDownFilters = value;
			}
		}
		
		/**
		 * @copy jsion.display.ScrollBar#BarDisableFilters
		 */		
		public function get BarDisableFilters():Array
		{
			return m_scrollBar.BarDisableFilters;
		}
		
		/** @private */
		public function set BarDisableFilters(value:Array):void
		{
			if(m_scrollBar.BarDisableFilters != value)
			{
				m_scrollBar.BarDisableFilters = value;
			}
		}
		
		/**
		 * @copy jsion.display.ScrollBar#BarImageOffsetX
		 */		
		public function get BarImageOffsetX():int
		{
			return m_scrollBar.BarImageOffsetX;
		}
		
		/** @private */
		public function set BarImageOffsetX(value:int):void
		{
			if(m_scrollBar.BarImageOffsetX != value)
			{
				m_scrollBar.BarImageOffsetX = value;
			}
		}
		
		/**
		 * @copy jsion.display.ScrollBar#BarImageOffsetY
		 */		
		public function get BarImageOffsetY():int
		{
			return m_scrollBar.BarImageOffsetY;
		}
		
		/** @private */
		public function set BarImageOffsetY(value:int):void
		{
			if(m_scrollBar.BarImageOffsetY != value)
			{
				m_scrollBar.BarImageOffsetY = value;
			}
		}
		
		/**
		 * @copy jsion.display.ScrollBar#BarImageOverOffsetX
		 */		
		public function get BarImageOverOffsetX():int
		{
			return m_scrollBar.BarImageOverOffsetX;
		}
		
		/** @private */
		public function set BarImageOverOffsetX(value:int):void
		{
			if(m_scrollBar.BarImageOverOffsetX != value)
			{
				m_scrollBar.BarImageOverOffsetX = value;
			}
		}
		
		/**
		 * @copy jsion.display.ScrollBar#BarImageOverOffsetY
		 */		
		public function get BarImageOverOffsetY():int
		{
			return m_scrollBar.BarImageOverOffsetY;
		}
		
		/** @private */
		public function set BarImageOverOffsetY(value:int):void
		{
			if(m_scrollBar.BarImageOverOffsetY != value)
			{
				m_scrollBar.BarImageOverOffsetY = value;
			}
		}
		
		/**
		 * @copy jsion.display.ScrollBar#BarImageDownOffsetX
		 */		
		public function get BarImageDownOffsetX():int
		{
			return m_scrollBar.BarImageDownOffsetX;
		}
		
		/** @private */
		public function set BarImageDownOffsetX(value:int):void
		{
			if(m_scrollBar.BarImageDownOffsetX != value)
			{
				m_scrollBar.BarImageDownOffsetX = value;
			}
		}
		
		/**
		 * @copy jsion.display.ScrollBar#BarImageDownOffsetY
		 */		
		public function get BarImageDownOffsetY():int
		{
			return m_scrollBar.BarImageDownOffsetY;
		}
		
		/** @private */
		public function set BarImageDownOffsetY(value:int):void
		{
			if(m_scrollBar.BarImageDownOffsetY != value)
			{
				m_scrollBar.BarImageDownOffsetY = value;
			}
		}
		
		
		
		
		
		/**
		 * @copy jsion.display.ScrollBar#thumb
		 */		
		public function get thumb():DisplayObject
		{
			return m_scrollBar.thumb;
		}
		
		/** @private */
		public function set thumb(value:DisplayObject):void
		{
			if(m_scrollBar.thumb != value)
			{
				m_scrollBar.thumb = value;
			}
		}
		
		/**
		 * @copy jsion.display.ScrollBar#freeBMD
		 */		
		public function get freeBMD():Boolean
		{
			return m_scrollBar.freeBMD;
		}
		
		/** @private */
		public function set freeBMD(value:Boolean):void
		{
			m_freeBMD = value;
			
			m_scrollBar.freeBMD = value;
		}
		
		/**
		 * @copy jsion.display.ScrollBar#scrollValue
		 */		
		public function get scrollValue():int
		{
			return m_scrollBar.scrollValue;
		}
		
		/** @private */
		public function set scrollValue(value:int):void
		{
			m_scrollBar.scrollValue = value;
		}
		
		/**
		 * @copy jsion.display.ScrollBar#viewSize
		 */		
		public function get viewSize():int
		{
			return m_scrollBar.viewSize;
		}
		
		/** @private */
		public function set viewSize(value:int):void
		{
			if(m_scrollBar.viewSize != value)
			{
				m_scrollBar.viewSize = value;
				
				onPropertiesChanged(SCROLLBAR);
			}
		}
		
		/**
		 * @copy jsion.display.ScrollBar#scrollValueOffset
		 */		
		public function get scrollValueOffset():int
		{
			return m_scrollBar.scrollValueOffset;
		}
		
		/** @private */
		public function set scrollValueOffset(value:int):void
		{
			if(m_scrollBar.scrollValueOffset != value)
			{
				m_scrollBar.scrollValueOffset = value;
				
				onPropertiesChanged(SCROLLBAR);
			}
		}
		
		/**
		 * @copy jsion.display.ScrollBar#wheelStep
		 */		
		public function get wheelStep():int
		{
			return m_scrollBar.wheelStep;
		}
		
		/** @private */
		public function set wheelStep(value:int):void
		{
			m_scrollBar.wheelStep = value;
		}
		
		/**
		 * @copy jsion.display.ScrollBar#scrollStep
		 */		
		public function get scrollStep():int
		{
			return m_scrollBar.scrollStep;;
		}
		
		/** @private */
		public function set scrollStep(value:int):void
		{
			m_scrollBar.scrollStep = value;
		}
		
		/**
		 * @copy jsion.display.ScrollBar#delayFrame
		 */		
		public function get delayFrame():int
		{
			return m_scrollBar.delayFrame;
		}
		
		/** @private */
		public function set delayFrame(value:int):void
		{
			m_scrollBar.delayFrame = value;
		}
		
		/**
		 * @copy jsion.display.ScrollBar#btnGap
		 */		
		public function get btnGap():int
		{
			return m_scrollBar.btnGap;
		}
		
		public function set btnGap(value:int):void
		{
			if(m_scrollBar.btnGap != value)
			{
				m_scrollBar.btnGap = value;
				
				onPropertiesChanged(SCROLLBAR);
			}
		}
		
		//======================================	ScrollBar相关属性	======================================
		
		/**
		 * @inheritDoc
		 */
		override public function dispose():void
		{
			DisposeUtil.free(m_scrollBar);
			m_scrollBar = null;
			
			DisposeUtil.free(m_scrollView);
			m_scrollView = null;
			
			m_viewRect = null;
			
			super.dispose();
		}
	}
}