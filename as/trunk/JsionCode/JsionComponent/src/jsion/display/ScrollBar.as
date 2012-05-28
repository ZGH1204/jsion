package jsion.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import jsion.comps.Component;
	import jsion.events.DisplayEvent;
	import jsion.events.ReleaseEvent;
	import jsion.utils.DisposeUtil;
	
	/**
	 * 滚动条 支持水平滚动条和垂直滚动条
	 * @author Jsion
	 * 
	 */	
	public class ScrollBar extends Component
	{
		public static const BACKGROUNDCHANGE:String = "backgroundChange";
		public static const BUTTONGAP:String = "btnGap";
		public static const UPORLEFTBTNCHANGE:String = "upOrLeftBtnChange";
		public static const DOWNORRIGHTBTNCHANGE:String = "downOrRightBtnChange";
		public static const BARCHANGE:String = "barChange";
		public static const THUMBCHANGE:String = "thumbChange";
		public static const SCROLLDATA:String = "scrollData";
		public static const SCROLLVALUEOFFSET:String = "scrollValueOffset";
		
		/**
		 * 水平滚动条
		 */		
		public static const HORIZONTAL:int = 1;
		
		/**
		 * 垂直滚动条
		 */		
		public static const VERTICAL:int = 2;
		
		private var m_background:Image;
		private var m_upOrLeftBtn:Button;
		private var m_downOrRightBtn:Button;
		private var m_bar:Button;
		private var m_thumb:DisplayObject;
		
		private var m_freeBMD:Boolean;
		
		private var m_scrollType:int;
		
		private var m_btnGap:int;
		
		/**
		 * 拖动条的最小坐标
		 */		
		private var m_minPos:int;
		/**
		 * 拖动条的最大坐标
		 */		
		private var m_maxPos:int;
		
		/**
		 * 拖动条的最大拖动范围长度
		 */		
		private var m_maxBarRect:int;
		
		/**
		 * 鼠标按下时拖动条的起始位置
		 */		
		private var m_startPoint:Point;
		/**
		 * 鼠标按下时拖动条的舞台鼠标位置
		 */		
		private var m_startGlobalPoint:Point;
		
		/**
		 * 滚动值
		 */		
		private var m_scrollValue:int;
		/**
		 * 要滚动的全长度
		 */		
		private var m_viewSize:int;
		
		/**
		 * 滚动值的偏移量
		 */		
		private var m_scrollValueOffset:int;
		/**
		 * 最大滚动值
		 */		
		private var m_maxScrollValue:int;
		
		private var m_scrollStep:int;
		private var m_wheelStep:int;
		
		private var m_curFrame:int;
		private var m_delayFrame:int;
		
		/**
		 * 滚动条构造函数
		 * @param type 滚动条类型，可能的值：
		 * <ul>
		 * 	<li>ScrollBar.HORIZONTAL 水平滚动条类型</li>
		 * 	<li>ScrollBar.VERTICAL   垂直滚动条类型</li>
		 * </ul>
		 * 默认ScrollBar.VERTICAL。
		 * @throws Error 滚动类型错误 必需是 ScrollBar.HORIZONTAL 或 ScrollBar.VERTICAL 之一。
		 */		
		public function ScrollBar(type:int = VERTICAL)
		{
			super();
			
			if(type != VERTICAL && type != HORIZONTAL)
			{
				throw new Error("滚动类型错误");
				return;
			}
			
			m_freeBMD = false;
			m_scrollType = type;
			m_startPoint = new Point();
			m_startGlobalPoint = new Point();
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function beginChanges():void
		{
			m_background.beginChanges();
			m_upOrLeftBtn.beginChanges();
			m_downOrRightBtn.beginChanges();
			m_bar.beginChanges();
			
			super.beginChanges();
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function commitChanges():void
		{
			m_background.commitChanges();
			m_upOrLeftBtn.commitChanges();
			m_downOrRightBtn.commitChanges();
			m_bar.commitChanges();
			
			super.commitChanges();
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function initialize():void
		{
			super.initialize();
			
			m_background = new Image();
			m_upOrLeftBtn = new Button();
			m_downOrRightBtn = new Button();
			m_bar = new Button();
			
			m_background.mouseEnabled = true;
			
			m_scrollValueOffset = 0;
			m_maxScrollValue = 0;
			m_scrollStep = 5;
			m_wheelStep = 5;
			m_delayFrame = 20;
			//stopPropagation();
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function initEvents():void
		{
			super.initEvents();
			
			addEventListener(MouseEvent.MOUSE_WHEEL, __mouseWheelHandler);
			
			m_bar.addEventListener(MouseEvent.MOUSE_DOWN, __barMouseDownHandler);
			m_bar.addEventListener(ReleaseEvent.RELEASE, __barReleaseHandler);
			
			m_upOrLeftBtn.addEventListener(MouseEvent.MOUSE_DOWN, __upOrLeftMouseDownHandler);
			m_upOrLeftBtn.addEventListener(ReleaseEvent.RELEASE, __btnReleaseHandler);
			
			m_downOrRightBtn.addEventListener(MouseEvent.MOUSE_DOWN, __downOrRightMouseDownHandler);
			m_downOrRightBtn.addEventListener(ReleaseEvent.RELEASE, __btnReleaseHandler);
			
			m_background.addEventListener(MouseEvent.CLICK, __bgClickHandler);
		}
		
		private function __bgClickHandler(e:MouseEvent):void
		{
			if(m_scrollType == VERTICAL)
			{
				if(e.localY < m_bar.y)
				{
					scrollValue = m_scrollValue - m_height;
				}
				else
				{
					scrollValue = m_scrollValue + m_height;
				}
			}
			else
			{
				if(e.localX < m_bar.x)
				{
					scrollValue = m_scrollValue - m_width;
				}
				else
				{
					scrollValue = m_scrollValue + m_width;
				}
			}
		}
		
		private function __upOrLeftMouseDownHandler(e:MouseEvent):void
		{
			scrollValue = m_scrollValue - m_scrollStep;
			m_curFrame = 0;
			addEventListener(Event.ENTER_FRAME, __upOrLeftEnterFrameHandler);
		}
		
		private function __downOrRightMouseDownHandler(e:MouseEvent):void
		{
			scrollValue = m_scrollValue + m_scrollStep;
			m_curFrame = 0;
			addEventListener(Event.ENTER_FRAME, __downOrRightEnterFrameHandler);
		}
		
		private function __btnReleaseHandler(e:Event):void
		{
			m_curFrame = 0;
			removeEventListener(Event.ENTER_FRAME, __upOrLeftEnterFrameHandler);
			removeEventListener(Event.ENTER_FRAME, __downOrRightEnterFrameHandler);
		}
		
		private function __upOrLeftEnterFrameHandler(e:Event):void
		{
			if(m_curFrame < m_delayFrame)
			{
				m_curFrame++;
				return;
			}
			
			scrollValue = m_scrollValue - m_scrollStep;
		}
		
		private function __downOrRightEnterFrameHandler(e:Event):void
		{
			if(m_curFrame < m_delayFrame)
			{
				m_curFrame++;
				return;
			}
			
			scrollValue = m_scrollValue + m_scrollStep;
		}
		
		private function __mouseWheelHandler(e:MouseEvent):void
		{
			e.stopPropagation();
			
			if(e.delta > 0)
			{
				scrollValue = m_scrollValue - m_wheelStep;
			}
			else
			{
				scrollValue = m_scrollValue + m_wheelStep;
			}
		}
		
		private function __barMouseDownHandler(e:MouseEvent):void
		{
			m_startPoint.x = m_bar.x;
			m_startPoint.y = m_bar.y;
			m_startGlobalPoint.x = stage.mouseX;
			m_startGlobalPoint.y = stage.mouseY;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, __mouseMoveHandler);
		}
		
		private function __barReleaseHandler(e:Event):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, __mouseMoveHandler);
		}
		
		private function __mouseMoveHandler(e:MouseEvent):void
		{
			if(m_scrollType == VERTICAL)
			{
				m_bar.y = m_startPoint.y + stage.mouseY - m_startGlobalPoint.y;
				
				if(m_bar.y < m_minPos)
				{
					m_bar.y = m_minPos;
				}
				else if(m_bar.y > m_maxPos)
				{
					m_bar.y = m_maxPos;
				}
			}
			else
			{
				m_bar.x = m_startPoint.x + stage.mouseX - m_startGlobalPoint.x;
				
				if(m_bar.x < m_minPos)
				{
					m_bar.x = m_minPos;
				}
				else if(m_bar.x > m_maxPos)
				{
					m_bar.x = m_maxPos;
				}
			}
			
			calcScrollValue();
		}
		
		/**
		 * 计算滚动值
		 */		
		protected function calcScrollValue():void
		{
			var temp:int;
			
			if(m_scrollType == VERTICAL)
			{
				temp = (m_bar.y - m_minPos) / m_maxBarRect * m_maxScrollValue + m_scrollValueOffset;
			}
			else
			{
				temp = (m_bar.x - m_minPos) / m_maxBarRect * m_maxScrollValue + m_scrollValueOffset;
			}
			
			temp = Math.max(temp, m_scrollValueOffset);
			temp = Math.min(temp, m_maxScrollValue + m_scrollValueOffset);
			
			if(m_scrollValue != temp)
			{
				m_scrollValue = temp;
				
				dispatchEvent(new DisplayEvent(DisplayEvent.CHANGED, m_scrollValue));
			}
		}
		
		/**
		 * 更新 拖动条 的位置
		 */		
		protected function positionBar():void
		{
			if(m_scrollType == VERTICAL)
			{
				m_bar.y = (m_scrollValue - m_scrollValueOffset) * m_maxBarRect / m_maxScrollValue + m_minPos;
			}
			else
			{
				m_bar.x = (m_scrollValue - m_scrollValueOffset) * m_maxBarRect / m_maxScrollValue + m_minPos;
			}
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function addChildren():void
		{
			super.addChildren();
			
			addChild(m_background);
			addChild(m_upOrLeftBtn);
			addChild(m_downOrRightBtn);
			addChild(m_bar);
			
			if(m_thumb && m_bar) m_bar.addChild(m_thumb);
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function onProppertiesUpdate():void
		{
			super.onProppertiesUpdate();
			
			updateUIPos();
			
			updateUISize();
			
			updateUIData();
		}
		
		private function updateUIPos():void
		{
			if(isChanged(BACKGROUNDCHANGE) || 
			   isChanged(UPORLEFTBTNCHANGE) || 
			   isChanged(DOWNORRIGHTBTNCHANGE) || 
			   isChanged(BARCHANGE) || 
			   isChanged(BUTTONGAP) || 
			   isChanged(WIDTH) || 
			   isChanged(HEIGHT))
			{
				if(m_scrollType == VERTICAL)
				{
					m_width = Math.max(m_background.width, m_upOrLeftBtn.width, m_downOrRightBtn.width, m_bar.width);
					
					m_background.x = (m_width - m_background.width) / 2;
					m_background.y = 0;
					
					m_upOrLeftBtn.x = (m_width - m_upOrLeftBtn.width) / 2;
					m_upOrLeftBtn.y = m_btnGap;
					
					m_downOrRightBtn.x = (m_width - m_downOrRightBtn.width) / 2;
					m_downOrRightBtn.y = m_height - m_downOrRightBtn.height - m_btnGap;
					if(m_downOrRightBtn.y < (m_upOrLeftBtn.y + m_upOrLeftBtn.height))
					{
						m_downOrRightBtn.y = m_upOrLeftBtn.y + m_upOrLeftBtn.height;
					}
					
					m_bar.x = (m_width - m_bar.width) / 2;
					m_bar.y = m_upOrLeftBtn.y + m_upOrLeftBtn.height;
				}
				else
				{
					m_height = Math.max(m_background.height, m_upOrLeftBtn.height, m_downOrRightBtn.height, m_bar.height);
					
					m_background.x = 0;
					m_background.y = (m_height - m_background.height) / 2;
					
					m_upOrLeftBtn.x = m_btnGap;
					m_upOrLeftBtn.y = (m_height - m_upOrLeftBtn.height) / 2;
					
					m_downOrRightBtn.x = m_width - m_downOrRightBtn.width - m_btnGap;
					m_downOrRightBtn.y = (m_height - m_downOrRightBtn.height) / 2;
					if(m_downOrRightBtn.x < (m_upOrLeftBtn.x + m_upOrLeftBtn.width))
					{
						m_downOrRightBtn.x = m_upOrLeftBtn.x + m_upOrLeftBtn.width;
					}
					
					m_bar.x = m_upOrLeftBtn.x + m_upOrLeftBtn.width;
					m_bar.y = (m_height - m_bar.height) / 2;
				}
				
				if(m_thumb)
				{
					m_thumb.x = (m_bar.width - m_thumb.width) / 2;
					m_thumb.y = (m_bar.height - m_thumb.height) / 2;
				}
			}
		}
		
		private function updateUISize():void
		{
			var temp:int;
			
			if(isChanged(BACKGROUNDCHANGE) || 
				isChanged(UPORLEFTBTNCHANGE) || 
				isChanged(DOWNORRIGHTBTNCHANGE) || 
				isChanged(BARCHANGE) || 
				isChanged(WIDTH) || 
				isChanged(HEIGHT) || 
				isChanged(SCROLLDATA))
			{
				if(m_scrollType == VERTICAL)
				{
					m_background.height = m_height;
					
					temp = m_height - m_upOrLeftBtn.height - m_downOrRightBtn.height;
					
					if(temp < m_bar.minHeight)
					{
						m_bar.height = m_bar.minHeight;
						//m_bar.enabled = false;
						m_bar.visible = false;
						m_upOrLeftBtn.enabled = false;
						m_downOrRightBtn.enabled = false;
					}
					else
					{
						if(m_viewSize > m_height)
						{
							m_bar.height = temp * m_height / m_viewSize;
							//m_bar.enabled = true;
							m_bar.visible = true;
							m_upOrLeftBtn.enabled = true;
							m_downOrRightBtn.enabled = true;
						}
						else
						{
							m_bar.height = temp;
							//m_bar.enabled = true;
							m_bar.visible = false;
							m_upOrLeftBtn.enabled = false;
							m_downOrRightBtn.enabled = false;
						}
					}
				}
				else
				{
					
					m_background.width = m_width;
					
					temp = m_width - m_upOrLeftBtn.width - m_downOrRightBtn.width;
					
					if(temp < m_bar.minWidth)
					{
						m_bar.width = m_bar.minWidth;
						m_bar.enabled = false;
						//m_bar.visible = false;
					}
					else
					{
						if(m_viewSize > m_width)
						{
							m_bar.width = temp * m_width / m_viewSize;
							m_bar.enabled = true;
							//m_bar.visible = true;
						}
						else
						{
							m_bar.width = temp;
							m_bar.enabled = true;
							//m_bar.visible = true;
						}
					}
				}
			}
		}
		
		private function updateUIData():void
		{
//			if(isChanged(UPORLEFTBTNCHANGE) || 
//				isChanged(DOWNORRIGHTBTNCHANGE) || 
//				isChanged(BARCHANGE) || 
//				isChanged(WIDTH) || 
//				isChanged(HEIGHT) || 
//				isChanged(SCROLLDATA))
//			{
				if(m_scrollType == VERTICAL)
				{
					m_minPos = m_upOrLeftBtn.y + m_upOrLeftBtn.height;
					m_maxPos = m_downOrRightBtn.y - m_bar.height;
					m_maxScrollValue = m_viewSize - m_height;
				}
				else
				{
					m_minPos = m_upOrLeftBtn.x + m_upOrLeftBtn.width;
					m_maxPos = m_downOrRightBtn.x - m_bar.width;
					m_maxScrollValue = m_viewSize - m_width;
				}
				
				m_maxBarRect = m_maxPos - m_minPos;
//			}
			
			if(isChanged(SCROLLVALUEOFFSET))
			{
				calcScrollValue();
				
				positionBar();
			}
		}

		/**
		 * 滚动条类型。可能的值：
		 * <ul>
		 * 	<li>ScrollBar.HORIZONTAL 水平滚动条</li>
		 * 	<li>ScrollBar.VERTICAL   垂直滚动条</li>
		 * </ul>
		 */		
		public function get scrollType():int
		{
			return m_scrollType;
		}
		
		/**
		 * 滚动条背景图片的 BitmapData 对象
		 */		
		public function get background():BitmapData
		{
			return m_background.source;
		}
		
		/** @private */
		public function set background(value:BitmapData):void
		{
			if(m_background.source != value)
			{
				m_background.source = value;
				
				if(m_scrollType == VERTICAL)
				{
					if(manualHeight == false) m_height = m_background.height;
				}
				else
				{
					if(manualWidth == false) m_width = m_background.width;
				}
				
				onPropertiesChanged(BACKGROUNDCHANGE);
			}
		}
		
		/**
		 * 向上或向左按钮弹起时的显示对象资源
		 * @see jsion.display.Button#upImage
		 */		
		public function get UpOrLeftBtnUpAsset():DisplayObject
		{
			return m_upOrLeftBtn.upImage;
		}
		
		/** @private */
		public function set UpOrLeftBtnUpAsset(value:DisplayObject):void
		{
			if(m_upOrLeftBtn.upImage != value)
			{
				m_upOrLeftBtn.upImage = value;
				
				onPropertiesChanged(UPORLEFTBTNCHANGE);
			}
		}
		
		/**
		 * 向上或向左按钮鼠标经过时的显示对象资源
		 * @see jsion.display.Button#overImage
		 */		
		public function get UpOrLeftBtnOverAsset():DisplayObject
		{
			return m_upOrLeftBtn.overImage;
		}
		
		/** @private */
		public function set UpOrLeftBtnOverAsset(value:DisplayObject):void
		{
			if(m_upOrLeftBtn.overImage != value)
			{
				m_upOrLeftBtn.overImage = value;
				
				onPropertiesChanged(UPORLEFTBTNCHANGE);
			}
		}
		
		/**
		 * 向上或向左按钮鼠标按下时的显示对象资源
		 * @see jsion.display.Button#downImage
		 */		
		public function get UpOrLeftBtnDownAsset():DisplayObject
		{
			return m_upOrLeftBtn.downImage;
		}
		
		/** @private */
		public function set UpOrLeftBtnDownAsset(value:DisplayObject):void
		{
			if(m_upOrLeftBtn.downImage != value)
			{
				m_upOrLeftBtn.downImage = value;
				
				onPropertiesChanged(UPORLEFTBTNCHANGE);
			}
		}
		
		/**
		 * 向上或向左按钮禁用时的显示对象资源
		 * @see jsion.display.Button#disableImage
		 */		
		public function get UpOrLeftBtnDisableAsset():DisplayObject
		{
			return m_upOrLeftBtn.disableImage;
		}
		
		/** @private */
		public function set UpOrLeftBtnDisableAsset(value:DisplayObject):void
		{
			if(m_upOrLeftBtn.disableImage != value)
			{
				m_upOrLeftBtn.disableImage = value;
				
				onPropertiesChanged(UPORLEFTBTNCHANGE);
			}
		}
		
		/**
		 * 向上或向左按钮弹起时的显示对象滤镜
		 * @see jsion.display.Button#upFilters
		 */		
		public function get UpOrLeftBtnUpFilters():Array
		{
			return m_upOrLeftBtn.upFilters;
		}
		
		/** @private */
		public function set UpOrLeftBtnUpFilters(value:Array):void
		{
			if(m_upOrLeftBtn.upFilters != value)
			{
				m_upOrLeftBtn.upFilters = value;
			}
		}
		
		/**
		 * 向上或向左按钮鼠标经过时的显示对象滤镜
		 * @see jsion.display.Button#overFilters
		 */		
		public function get UpOrLeftBtnOverFilters():Array
		{
			return m_upOrLeftBtn.overFilters;
		}
		
		/** @private */
		public function set UpOrLeftBtnOverFilters(value:Array):void
		{
			if(m_upOrLeftBtn.overFilters != value)
			{
				m_upOrLeftBtn.overFilters = value;
			}
		}
		
		/**
		 * 向上或向左按钮鼠标按下时的显示对象滤镜
		 * @see jsion.display.Button#downFilters
		 */		
		public function get UpOrLeftBtnDownFilters():Array
		{
			return m_upOrLeftBtn.downFilters;
		}
		
		/** @private */
		public function set UpOrLeftBtnDownFilters(value:Array):void
		{
			if(m_upOrLeftBtn.downFilters != value)
			{
				m_upOrLeftBtn.downFilters = value;
			}
		}
		
		/**
		 * 向上或向左按钮禁用时的显示对象滤镜
		 * @see jsion.display.Button#disableFilters
		 */		
		public function get UpOrLeftBtnDisableFilters():Array
		{
			return m_upOrLeftBtn.disableFilters;
		}
		
		/** @private */
		public function set UpOrLeftBtnDisableFilters(value:Array):void
		{
			if(m_upOrLeftBtn.disableFilters != value)
			{
				m_upOrLeftBtn.disableFilters = value;
			}
		}
		
		/**
		 * 向上或向左按钮弹起时的显示对象x坐标偏移量
		 * @see jsion.display.Button#offsetX
		 */		
		public function get UpOrLeftBtnImageOffsetX():int
		{
			return m_upOrLeftBtn.offsetX;
		}
		
		/** @private */
		public function set UpOrLeftBtnImageOffsetX(value:int):void
		{
			if(m_upOrLeftBtn.offsetX != value)
			{
				m_upOrLeftBtn.offsetX = value;
			}
		}
		
		/**
		 * 向上或向左按钮弹起时的显示对象y坐标偏移量
		 * @see jsion.display.Button#offsetY
		 */		
		public function get UpOrLeftBtnImageOffsetY():int
		{
			return m_upOrLeftBtn.offsetY;
		}
		
		/** @private */
		public function set UpOrLeftBtnImageOffsetY(value:int):void
		{
			if(m_upOrLeftBtn.offsetY != value)
			{
				m_upOrLeftBtn.offsetY = value;
			}
		}
		
		/**
		 * 向上或向左按钮鼠标经过时的显示对象x坐标偏移量
		 * @see jsion.display.Button#overOffsetX
		 */		
		public function get UpOrLeftBtnImageOverOffsetX():int
		{
			return m_upOrLeftBtn.overOffsetX;
		}
		
		/** @private */
		public function set UpOrLeftBtnImageOverOffsetX(value:int):void
		{
			if(m_upOrLeftBtn.overOffsetX != value)
			{
				m_upOrLeftBtn.overOffsetX = value;
			}
		}
		
		/**
		 * 向上或向左按钮鼠标经过时的显示对象y坐标偏移量
		 * @see jsion.display.Button#overOffsetY
		 */		
		public function get UpOrLeftBtnImageOverOffsetY():int
		{
			return m_upOrLeftBtn.overOffsetY;
		}
		
		/** @private */
		public function set UpOrLeftBtnImageOverOffsetY(value:int):void
		{
			if(m_upOrLeftBtn.overOffsetY != value)
			{
				m_upOrLeftBtn.overOffsetY = value;
			}
		}
		
		/**
		 * 向上或向左按钮鼠标按下时的显示对象x坐标偏移量
		 * @see jsion.display.Button#downOffsetX
		 */		
		public function get UpOrLeftBtnImageDownOffsetX():int
		{
			return m_upOrLeftBtn.downOffsetX;
		}
		
		/** @private */
		public function set UpOrLeftBtnImageDownOffsetX(value:int):void
		{
			if(m_upOrLeftBtn.downOffsetX != value)
			{
				m_upOrLeftBtn.downOffsetX = value;
			}
		}
		
		/**
		 * 向上或向左按钮鼠标按下时的显示对象y坐标偏移量
		 * @see jsion.display.Button#downOffsetY
		 */		
		public function get UpOrLeftBtnImageDownOffsetY():int
		{
			return m_upOrLeftBtn.downOffsetY;
		}
		
		/** @private */
		public function set UpOrLeftBtnImageDownOffsetY(value:int):void
		{
			if(m_upOrLeftBtn.downOffsetY != value)
			{
				m_upOrLeftBtn.downOffsetY = value;
			}
		}
		
		
		
		
		
		
		
		
		
		
		/**
		 * 向下或向右按钮弹起时的显示对象资源
		 * @see jsion.display.Button#upImage
		 */		
		public function get DownOrRightBtnUpAsset():DisplayObject
		{
			return m_downOrRightBtn.upImage;
		}
		
		/** @private */
		public function set DownOrRightBtnUpAsset(value:DisplayObject):void
		{
			if(m_downOrRightBtn.upImage != value)
			{
				m_downOrRightBtn.upImage = value;
				
				onPropertiesChanged(DOWNORRIGHTBTNCHANGE);
			}
		}
		
		/**
		 * 向下或向右按钮鼠标经过时的显示对象资源
		 * @see jsion.display.Button#overImage
		 */		
		public function get DownOrRightBtnOverAsset():DisplayObject
		{
			return m_downOrRightBtn.overImage;
		}
		
		/** @private */
		public function set DownOrRightBtnOverAsset(value:DisplayObject):void
		{
			if(m_downOrRightBtn.overImage != value)
			{
				m_downOrRightBtn.overImage = value;
				
				onPropertiesChanged(DOWNORRIGHTBTNCHANGE);
			}
		}
		
		/**
		 * 向下或向右按钮鼠标按下时的显示对象资源
		 * @see jsion.display.Button#downImage
		 */		
		public function get DownOrRightBtnDownAsset():DisplayObject
		{
			return m_downOrRightBtn.downImage;
		}
		
		/** @private */
		public function set DownOrRightBtnDownAsset(value:DisplayObject):void
		{
			if(m_downOrRightBtn.downImage != value)
			{
				m_downOrRightBtn.downImage = value;
				
				onPropertiesChanged(DOWNORRIGHTBTNCHANGE);
			}
		}
		
		/**
		 * 向下或向右按钮禁用时的显示对象资源
		 * @see jsion.display.Button#disableImage
		 */		
		public function get DownOrRightBtnDisableAsset():DisplayObject
		{
			return m_downOrRightBtn.disableImage;
		}
		
		/** @private */
		public function set DownOrRightBtnDisableAsset(value:DisplayObject):void
		{
			if(m_downOrRightBtn.disableImage != value)
			{
				m_downOrRightBtn.disableImage = value;
				
				onPropertiesChanged(DOWNORRIGHTBTNCHANGE);
			}
		}
		
		/**
		 * 向下或向右按钮弹起时的显示对象滤镜
		 * @see jsion.display.Button#upFilters
		 */		
		public function get DownOrRightBtnUpFilters():Array
		{
			return m_downOrRightBtn.upFilters;
		}
		
		/** @private */
		public function set DownOrRightBtnUpFilters(value:Array):void
		{
			if(m_downOrRightBtn.upFilters != value)
			{
				m_downOrRightBtn.upFilters = value;
			}
		}
		
		/**
		 * 向下或向右按钮鼠标经过时的显示对象滤镜
		 * @see jsion.display.Button#overFilters
		 */		
		public function get DownOrRightBtnOverFilters():Array
		{
			return m_downOrRightBtn.overFilters;
		}
		
		/** @private */
		public function set DownOrRightBtnOverFilters(value:Array):void
		{
			if(m_downOrRightBtn.overFilters != value)
			{
				m_downOrRightBtn.overFilters = value;
			}
		}
		
		/**
		 * 向下或向右按钮鼠标按下时的显示对象滤镜
		 * @see jsion.display.Button#downFilters
		 */		
		public function get DownOrRightBtnDownFilters():Array
		{
			return m_downOrRightBtn.downFilters;
		}
		
		/** @private */
		public function set DownOrRightBtnDownFilters(value:Array):void
		{
			if(m_downOrRightBtn.downFilters != value)
			{
				m_downOrRightBtn.downFilters = value;
			}
		}
		
		/**
		 * 向下或向右按钮禁用时的显示对象滤镜
		 * @see jsion.display.Button#disableFilters
		 */		
		public function get DownOrRightBtnDisableFilters():Array
		{
			return m_downOrRightBtn.disableFilters;
		}
		
		/** @private */
		public function set DownOrRightBtnDisableFilters(value:Array):void
		{
			if(m_downOrRightBtn.disableFilters != value)
			{
				m_downOrRightBtn.disableFilters = value;
			}
		}
		
		/**
		 * 向下或向右按钮弹起时的显示对象x坐标偏移量
		 * @see jsion.display.Button#offsetX
		 */		
		public function get DownOrRightBtnImageOffsetX():int
		{
			return m_downOrRightBtn.offsetX;
		}
		
		/** @private */
		public function set DownOrRightBtnImageOffsetX(value:int):void
		{
			if(m_downOrRightBtn.offsetX != value)
			{
				m_downOrRightBtn.offsetX = value;
			}
		}
		
		/**
		 * 向下或向右按钮弹起时的显示对象y坐标偏移量
		 * @see jsion.display.Button#offsetY
		 */		
		public function get DownOrRightBtnImageOffsetY():int
		{
			return m_downOrRightBtn.offsetY;
		}
		
		/** @private */
		public function set DownOrRightBtnImageOffsetY(value:int):void
		{
			if(m_downOrRightBtn.offsetY != value)
			{
				m_downOrRightBtn.offsetY = value;
			}
		}
		
		/**
		 * 向下或向右按钮鼠标经过时的显示对象x坐标偏移量
		 * @see jsion.display.Button#overOffsetX
		 */		
		public function get DownOrRightBtnImageOverOffsetX():int
		{
			return m_downOrRightBtn.overOffsetX;
		}
		
		/** @private */
		public function set DownOrRightBtnImageOverOffsetX(value:int):void
		{
			if(m_downOrRightBtn.overOffsetX != value)
			{
				m_downOrRightBtn.overOffsetX = value;
			}
		}
		
		/**
		 * 向下或向右按钮鼠标经过时的显示对象y坐标偏移量
		 * @see jsion.display.Button#overOffsetY
		 */		
		public function get DownOrRightBtnImageOverOffsetY():int
		{
			return m_downOrRightBtn.overOffsetY;
		}
		
		/** @private */
		public function set DownOrRightBtnImageOverOffsetY(value:int):void
		{
			if(m_downOrRightBtn.overOffsetY != value)
			{
				m_downOrRightBtn.overOffsetY = value;
			}
		}
		
		/**
		 * 向下或向右按钮鼠标按下时的显示对象x坐标偏移量
		 * @see jsion.display.Button#downOffsetX
		 */		
		public function get DownOrRightBtnImageDownOffsetX():int
		{
			return m_downOrRightBtn.downOffsetX;
		}
		
		/** @private */
		public function set DownOrRightBtnImageDownOffsetX(value:int):void
		{
			if(m_downOrRightBtn.downOffsetX != value)
			{
				m_downOrRightBtn.downOffsetX = value;
			}
		}
		
		/**
		 * 向下或向右按钮鼠标按下时的显示对象y坐标偏移量
		 * @see jsion.display.Button#downOffsetY
		 */		
		public function get DownOrRightBtnImageDownOffsetY():int
		{
			return m_downOrRightBtn.downOffsetY;
		}
		
		/** @private */
		public function set DownOrRightBtnImageDownOffsetY(value:int):void
		{
			if(m_downOrRightBtn.downOffsetY != value)
			{
				m_downOrRightBtn.downOffsetY = value;
			}
		}
		
		
		
		
		
		
		
		
		
		/**
		 * 拖动条弹起时的显示对象资源
		 * @see jsion.display.Button#upImage
		 */
		public function get BarUpAsset():DisplayObject
		{
			return m_bar.upImage;
		}
		
		/** @private */
		public function set BarUpAsset(value:DisplayObject):void
		{
			if(m_bar.upImage != value)
			{
				m_bar.upImage = value;
				
				onPropertiesChanged(BARCHANGE);
			}
		}
		
		/**
		 * 拖动条鼠标经过时的显示对象资源
		 * @see jsion.display.Button#overImage
		 */
		public function get BarOverAsset():DisplayObject
		{
			return m_bar.overImage;
		}
		
		/** @private */
		public function set BarOverAsset(value:DisplayObject):void
		{
			if(m_bar.overImage != value)
			{
				m_bar.overImage = value;
				
				onPropertiesChanged(BARCHANGE);
			}
		}
		
		/**
		 * 拖动条鼠标按下时的显示对象资源
		 * @see jsion.display.Button#downImage
		 */
		public function get BarDownAsset():DisplayObject
		{
			return m_bar.downImage;
		}
		
		/** @private */
		public function set BarDownAsset(value:DisplayObject):void
		{
			if(m_bar.downImage != value)
			{
				m_bar.downImage = value;
				
				onPropertiesChanged(BARCHANGE);
			}
		}
		
		/**
		 * 拖动条禁用时的显示对象资源
		 * @see jsion.display.Button#disableImage
		 */
		public function get BarDisableAsset():DisplayObject
		{
			return m_bar.disableImage;
		}
		
		/** @private */
		public function set BarDisableAsset(value:DisplayObject):void
		{
			if(m_bar.disableImage != value)
			{
				m_bar.disableImage = value;
				
				onPropertiesChanged(BARCHANGE);
			}
		}
		
		/**
		 * 拖动条弹起时的显示对象滤镜
		 * @see jsion.display.Button#upFilters
		 */
		public function get BarUpFilters():Array
		{
			return m_bar.upFilters;
		}
		
		/** @private */
		public function set BarUpFilters(value:Array):void
		{
			if(m_bar.upFilters != value)
			{
				m_bar.upFilters = value;
			}
		}
		
		/**
		 * 拖动条鼠标经过时的显示对象滤镜
		 * @see jsion.display.Button#overFilters
		 */
		public function get BarOverFilters():Array
		{
			return m_bar.overFilters;
		}
		
		/** @private */
		public function set BarOverFilters(value:Array):void
		{
			if(m_bar.overFilters != value)
			{
				m_bar.overFilters = value;
			}
		}
		
		/**
		 * 拖动条鼠标按下时的显示对象滤镜
		 * @see jsion.display.Button#downFilters
		 */
		public function get BarDownFilters():Array
		{
			return m_bar.downFilters;
		}
		
		/** @private */
		public function set BarDownFilters(value:Array):void
		{
			if(m_bar.downFilters != value)
			{
				m_bar.downFilters = value;
			}
		}
		
		/**
		 * 拖动条禁用时的显示对象滤镜
		 * @see jsion.display.Button#disableFilters
		 */
		public function get BarDisableFilters():Array
		{
			return m_bar.disableFilters;
		}
		
		/** @private */
		public function set BarDisableFilters(value:Array):void
		{
			if(m_bar.disableFilters != value)
			{
				m_bar.disableFilters = value;
			}
		}
		
		/**
		 * 拖动条弹起时的显示对象x坐标偏移量
		 * @see jsion.display.Button#offsetX
		 */
		public function get BarImageOffsetX():int
		{
			return m_bar.offsetX;
		}
		
		/** @private */
		public function set BarImageOffsetX(value:int):void
		{
			if(m_bar.offsetX != value)
			{
				m_bar.offsetX = value;
			}
		}
		
		/**
		 * 拖动条弹起时的显示对象y坐标偏移量
		 * @see jsion.display.Button#offsetY
		 */
		public function get BarImageOffsetY():int
		{
			return m_bar.offsetY;
		}
		
		/** @private */
		public function set BarImageOffsetY(value:int):void
		{
			if(m_bar.offsetY != value)
			{
				m_bar.offsetY = value;
			}
		}
		
		/**
		 * 拖动条鼠标经过时的显示对象x坐标偏移量
		 * @see jsion.display.Button#overOffsetX
		 */
		public function get BarImageOverOffsetX():int
		{
			return m_bar.overOffsetX;
		}
		
		/** @private */
		public function set BarImageOverOffsetX(value:int):void
		{
			if(m_bar.overOffsetX != value)
			{
				m_bar.overOffsetX = value;
			}
		}
		
		/**
		 * 拖动条鼠标经过时的显示对象y坐标偏移量
		 * @see jsion.display.Button#overOffsetY
		 */
		public function get BarImageOverOffsetY():int
		{
			return m_bar.overOffsetY;
		}
		
		/** @private */
		public function set BarImageOverOffsetY(value:int):void
		{
			if(m_bar.overOffsetY != value)
			{
				m_bar.overOffsetY = value;
			}
		}
		
		/**
		 * 拖动条鼠标按下时的显示对象x坐标偏移量
		 * @see jsion.display.Button#downOffsetX
		 */
		public function get BarImageDownOffsetX():int
		{
			return m_bar.downOffsetX;
		}
		
		/** @private */
		public function set BarImageDownOffsetX(value:int):void
		{
			if(m_bar.downOffsetX != value)
			{
				m_bar.downOffsetX = value;
			}
		}
		
		/**
		 * 拖动条鼠标按下时的显示对象y坐标偏移量
		 * @see jsion.display.Button#downOffsetY
		 */
		public function get BarImageDownOffsetY():int
		{
			return m_bar.downOffsetY;
		}
		
		/** @private */
		public function set BarImageDownOffsetY(value:int):void
		{
			if(m_bar.downOffsetY != value)
			{
				m_bar.downOffsetY = value;
			}
		}
		
		
		
		
		
		/**
		 * 拖动条中间的修饰的显示对象
		 */
		public function get thumb():DisplayObject
		{
			return m_thumb;
		}
		
		/** @private */
		public function set thumb(value:DisplayObject):void
		{
			if(m_thumb != value)
			{
				if(m_thumb) DisposeUtil.free(m_thumb, m_freeBMD);
				
				m_thumb = value;
				
				onPropertiesChanged(THUMBCHANGE);
			}
		}

		/**
		 * @copy jsion.display.Button#freeBMD
		 * @see jsion.display.Button#freeBMD
		 */		
		public function get freeBMD():Boolean
		{
			return m_freeBMD;
		}
		
		/** @private */
		public function set freeBMD(value:Boolean):void
		{
			m_freeBMD = value;
			
			m_bar.freeBMD = value;
			m_upOrLeftBtn.freeBMD = value;
			m_downOrRightBtn.freeBMD = value;
		}

		/**
		 * 滚动值
		 */		
		public function get scrollValue():int
		{
			return m_scrollValue;
		}
		
		/** @private */
		public function set scrollValue(value:int):void
		{
			value = Math.max(value, m_scrollValueOffset);
			value = Math.min(value, m_maxScrollValue + m_scrollValueOffset);
			
			if(m_scrollValue != value)
			{
				m_scrollValue = value;
				
				positionBar();
				
				dispatchEvent(new DisplayEvent(DisplayEvent.CHANGED, m_scrollValue));
			}
		}

		/**
		 * 要滚动的全长度
		 */		
		public function get viewSize():int
		{
			return m_viewSize;
		}
		
		/** @private */
		public function set viewSize(value:int):void
		{
			if(m_viewSize != value)
			{
				m_viewSize = value;
				
				onPropertiesChanged(SCROLLDATA);
			}
		}

		/**
		 * 滚动值的最终偏移量
		 */		
		public function get scrollValueOffset():int
		{
			return m_scrollValueOffset;
		}
		
		/** @private */
		public function set scrollValueOffset(value:int):void
		{
			if(m_scrollValueOffset != value)
			{
				m_scrollValueOffset = value;
				
				onPropertiesChanged(SCROLLVALUEOFFSET);
			}
		}

		/**
		 * 每次鼠标滚轮滚动的滚动值
		 */
		public function get wheelStep():int
		{
			return m_wheelStep;
		}

		/** @private */
		public function set wheelStep(value:int):void
		{
			m_wheelStep = value;
		}

		/**
		 * 点击按钮时的滚动值
		 */		
		public function get scrollStep():int
		{
			return m_scrollStep;
		}
		
		/** @private */
		public function set scrollStep(value:int):void
		{
			m_scrollStep = value;
		}

		/**
		 * 长按按钮的延迟帧数 超过延迟帧时以 scrollStep 的值不停更新滚动值 scrollValue。
		 */		
		public function get delayFrame():int
		{
			return m_delayFrame;
		}
		
		/** @private */
		public function set delayFrame(value:int):void
		{
			m_delayFrame = value;
		}

		/**
		 * 根据滚动条类型获取或设置按钮与四边的间隙
		 * <ul>
		 * 	<li>水平滚动条时，获取或设置按钮与左、右两边的间隙</li>
		 * 	<li>垂直滚动条时，获取或设置按钮与上、下两边的间隙</li>
		 * </ul>
		 */		
		public function get btnGap():int
		{
			return m_btnGap;
		}

		public function set btnGap(value:int):void
		{
			if(m_btnGap != value)
			{
				m_btnGap = value;
				
				onPropertiesChanged(BUTTONGAP);
			}
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function dispose():void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, __mouseMoveHandler);
			
			DisposeUtil.free(m_background);
			m_background = null;
			
			DisposeUtil.free(m_upOrLeftBtn);
			m_upOrLeftBtn = null;
			
			DisposeUtil.free(m_downOrRightBtn);
			m_downOrRightBtn = null;
			
			DisposeUtil.free(m_bar);
			m_bar = null;
			
			DisposeUtil.free(m_thumb, m_freeBMD);
			m_thumb = null;
			
			m_startPoint = null;
			m_startGlobalPoint = null;
			
			super.dispose();
		}
	}
}