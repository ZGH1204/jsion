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
	
	public class ScrollBar extends Component
	{
		public static const BACKGROUNDCHANGE:String = "backgroundChange";
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
		
		/** @private */
		protected var m_freeBMD:Boolean;
		
		private var m_scrollType:int;
		
		private var m_minPos:int;
		private var m_maxPos:int;
		private var m_maxSize:int;
		private var m_maxBarRect:int;
		
		private var m_startPoint:Point;
		private var m_startGlobalPoint:Point;
		
		private var m_scrollValue:int;
		//private var m_visableSize:int;
		private var m_viewSize:int;
		
		private var m_scrollValueOffset:int;
		private var m_maxScrollValue:int;
		
		private var m_wheelStep:int;
		
		public function ScrollBar(type:int = VERTICAL)
		{
			super();
			
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
			
			m_scrollValueOffset = 0;
			m_maxScrollValue = 0;
			m_wheelStep = 5;
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
			
			positionBar();
		}
		
		private function __barMouseDownHandler(e:MouseEvent):void
		{
			m_startPoint.x = m_bar.x;
			m_startPoint.y = m_bar.y;
			m_startGlobalPoint.x = stage.mouseX;
			m_startGlobalPoint.y = stage.mouseY;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, __mouseMoveHandler);
		}
		
		protected function __barReleaseHandler(e:Event):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, __mouseMoveHandler);
		}
		
		protected function __mouseMoveHandler(e:MouseEvent):void
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
			temp = Math.min(temp, m_maxScrollValue);
			
			if(m_scrollValue != temp)
			{
				m_scrollValue = temp;
				trace(m_scrollValue);
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
			   isChanged(WIDTH) || 
			   isChanged(HEIGHT))
			{
				if(m_scrollType == VERTICAL)
				{
					m_maxSize = Math.max(m_background.width, m_upOrLeftBtn.width, m_downOrRightBtn.width, m_bar.width);
					
					m_background.x = (m_maxSize - m_background.width) / 2;
					m_background.y = 0;
					
					m_upOrLeftBtn.x = (m_maxSize - m_upOrLeftBtn.width) / 2;
					m_upOrLeftBtn.y = 0;
					
					m_downOrRightBtn.x = (m_maxSize - m_downOrRightBtn.width) / 2;
					m_downOrRightBtn.y = m_height - m_downOrRightBtn.height;
					if(m_downOrRightBtn.y < (m_upOrLeftBtn.y + m_upOrLeftBtn.height))
					{
						m_downOrRightBtn.y = m_upOrLeftBtn.y + m_upOrLeftBtn.height;
					}
					
					m_bar.x = (m_maxSize - m_bar.width) / 2;
					m_bar.y = m_upOrLeftBtn.y + m_upOrLeftBtn.height;
				}
				else
				{
					m_maxSize = Math.max(m_background.height, m_upOrLeftBtn.height, m_downOrRightBtn.height, m_bar.height);
					
					m_background.x = 0;
					m_background.y = (m_maxSize - m_background.height) / 2;
					
					m_upOrLeftBtn.x = 0;
					m_upOrLeftBtn.y = (m_maxSize - m_upOrLeftBtn.height) / 2;
					
					m_downOrRightBtn.x = m_width - m_downOrRightBtn.width;
					m_downOrRightBtn.y = (m_maxSize - m_downOrRightBtn.height) / 2;
					if(m_downOrRightBtn.x < (m_upOrLeftBtn.x + m_upOrLeftBtn.width))
					{
						m_downOrRightBtn.x = m_upOrLeftBtn.x + m_upOrLeftBtn.width;
					}
					
					m_bar.x = m_upOrLeftBtn.x + m_upOrLeftBtn.width;
					m_bar.y = (m_maxSize - m_bar.height) / 2;
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
					}
					else
					{
						if(m_viewSize > m_height)
						{
							m_bar.height = temp * m_height / m_viewSize;
							//m_bar.enabled = true;
							m_bar.visible = true;
						}
						else
						{
							m_bar.height = temp;
							//m_bar.enabled = true;
							m_bar.visible = false;
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
			if(isChanged(UPORLEFTBTNCHANGE) || 
				isChanged(DOWNORRIGHTBTNCHANGE) || 
				isChanged(BARCHANGE) || 
				isChanged(WIDTH) || 
				isChanged(HEIGHT) || 
				isChanged(SCROLLDATA))
			{
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
			}
			
			if(isChanged(SCROLLVALUEOFFSET))
			{
				calcScrollValue();
				
				positionBar();
			}
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function dispose():void
		{
			super.dispose();
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
		
		public function get background():BitmapData
		{
			return m_background.source;
		}
		
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
		
		public function get UpOrLeftBtnUpAsset():DisplayObject
		{
			return m_upOrLeftBtn.upImage;
		}
		
		public function set UpOrLeftBtnUpAsset(value:DisplayObject):void
		{
			if(m_upOrLeftBtn.upImage != value)
			{
				m_upOrLeftBtn.upImage = value;
				
				onPropertiesChanged(UPORLEFTBTNCHANGE);
			}
		}
		
		public function get UpOrLeftBtnOverAsset():DisplayObject
		{
			return m_upOrLeftBtn.overImage;
		}
		
		public function set UpOrLeftBtnOverAsset(value:DisplayObject):void
		{
			if(m_upOrLeftBtn.overImage != value)
			{
				m_upOrLeftBtn.overImage = value;
				
				onPropertiesChanged(UPORLEFTBTNCHANGE);
			}
		}
		
		public function get UpOrLeftBtnDownAsset():DisplayObject
		{
			return m_upOrLeftBtn.downImage;
		}
		
		public function set UpOrLeftBtnDownAsset(value:DisplayObject):void
		{
			if(m_upOrLeftBtn.downImage != value)
			{
				m_upOrLeftBtn.downImage = value;
				
				onPropertiesChanged(UPORLEFTBTNCHANGE);
			}
		}
		
		public function get UpOrLeftBtnDisableAsset():DisplayObject
		{
			return m_upOrLeftBtn.disableImage;
		}
		
		public function set UpOrLeftBtnDisableAsset(value:DisplayObject):void
		{
			if(m_upOrLeftBtn.disableImage != value)
			{
				m_upOrLeftBtn.disableImage = value;
				
				onPropertiesChanged(UPORLEFTBTNCHANGE);
			}
		}
		
		public function get UpOrLeftBtnUpFilters():Array
		{
			return m_upOrLeftBtn.upFilters;
		}
		
		public function set UpOrLeftBtnUpFilters(value:Array):void
		{
			if(m_upOrLeftBtn.upFilters != value)
			{
				m_upOrLeftBtn.upFilters = value;
			}
		}
		
		public function get UpOrLeftBtnOverFilters():Array
		{
			return m_upOrLeftBtn.overFilters;
		}
		
		public function set UpOrLeftBtnOverFilters(value:Array):void
		{
			if(m_upOrLeftBtn.overFilters != value)
			{
				m_upOrLeftBtn.overFilters = value;
			}
		}
		
		public function get UpOrLeftBtnDownFilters():Array
		{
			return m_upOrLeftBtn.downFilters;
		}
		
		public function set UpOrLeftBtnDownFilters(value:Array):void
		{
			if(m_upOrLeftBtn.downFilters != value)
			{
				m_upOrLeftBtn.downFilters = value;
			}
		}
		
		public function get UpOrLeftBtnDisableFilters():Array
		{
			return m_upOrLeftBtn.disableFilters;
		}
		
		public function set UpOrLeftBtnDisableFilters(value:Array):void
		{
			if(m_upOrLeftBtn.disableFilters != value)
			{
				m_upOrLeftBtn.disableFilters = value;
			}
		}
		
		public function get UpOrLeftBtnImageOffsetX():int
		{
			return m_upOrLeftBtn.offsetX;
		}
		
		public function set UpOrLeftBtnImageOffsetX(value:int):void
		{
			if(m_upOrLeftBtn.offsetX != value)
			{
				m_upOrLeftBtn.offsetX = value;
			}
		}
		
		public function get UpOrLeftBtnImageOffsetY():int
		{
			return m_upOrLeftBtn.offsetY;
		}
		
		public function set UpOrLeftBtnImageOffsetY(value:int):void
		{
			if(m_upOrLeftBtn.offsetY != value)
			{
				m_upOrLeftBtn.offsetY = value;
			}
		}
		
		public function get UpOrLeftBtnImageOverOffsetX():int
		{
			return m_upOrLeftBtn.overOffsetX;
		}
		
		public function set UpOrLeftBtnImageOverOffsetX(value:int):void
		{
			if(m_upOrLeftBtn.overOffsetX != value)
			{
				m_upOrLeftBtn.overOffsetX = value;
			}
		}
		
		public function get UpOrLeftBtnImageOverOffsetY():int
		{
			return m_upOrLeftBtn.overOffsetY;
		}
		
		public function set UpOrLeftBtnImageOverOffsetY(value:int):void
		{
			if(m_upOrLeftBtn.overOffsetY != value)
			{
				m_upOrLeftBtn.overOffsetY = value;
			}
		}
		
		public function get UpOrLeftBtnImageDownOffsetX():int
		{
			return m_upOrLeftBtn.downOffsetX;
		}
		
		public function set UpOrLeftBtnImageDownOffsetX(value:int):void
		{
			if(m_upOrLeftBtn.downOffsetX != value)
			{
				m_upOrLeftBtn.downOffsetX = value;
			}
		}
		
		public function get UpOrLeftBtnImageDownOffsetY():int
		{
			return m_upOrLeftBtn.downOffsetY;
		}
		
		public function set UpOrLeftBtnImageDownOffsetY(value:int):void
		{
			if(m_upOrLeftBtn.downOffsetY != value)
			{
				m_upOrLeftBtn.downOffsetY = value;
			}
		}
		
		
		
		
		
		
		
		
		
		
		public function get DownOrRightBtnUpAsset():DisplayObject
		{
			return m_downOrRightBtn.upImage;
		}
		
		public function set DownOrRightBtnUpAsset(value:DisplayObject):void
		{
			if(m_downOrRightBtn.upImage != value)
			{
				m_downOrRightBtn.upImage = value;
				
				onPropertiesChanged(DOWNORRIGHTBTNCHANGE);
			}
		}
		
		public function get DownOrRightBtnOverAsset():DisplayObject
		{
			return m_downOrRightBtn.overImage;
		}
		
		public function set DownOrRightBtnOverAsset(value:DisplayObject):void
		{
			if(m_downOrRightBtn.overImage != value)
			{
				m_downOrRightBtn.overImage = value;
				
				onPropertiesChanged(DOWNORRIGHTBTNCHANGE);
			}
		}
		
		public function get DownOrRightBtnDownAsset():DisplayObject
		{
			return m_downOrRightBtn.downImage;
		}
		
		public function set DownOrRightBtnDownAsset(value:DisplayObject):void
		{
			if(m_downOrRightBtn.downImage != value)
			{
				m_downOrRightBtn.downImage = value;
				
				onPropertiesChanged(DOWNORRIGHTBTNCHANGE);
			}
		}
		
		public function get DownOrRightBtnDisableAsset():DisplayObject
		{
			return m_downOrRightBtn.disableImage;
		}
		
		public function set DownOrRightBtnDisableAsset(value:DisplayObject):void
		{
			if(m_downOrRightBtn.disableImage != value)
			{
				m_downOrRightBtn.disableImage = value;
				
				onPropertiesChanged(DOWNORRIGHTBTNCHANGE);
			}
		}
		
		public function get DownOrRightBtnUpFilters():Array
		{
			return m_downOrRightBtn.upFilters;
		}
		
		public function set DownOrRightBtnUpFilters(value:Array):void
		{
			if(m_downOrRightBtn.upFilters != value)
			{
				m_downOrRightBtn.upFilters = value;
			}
		}
		
		public function get DownOrRightBtnOverFilters():Array
		{
			return m_downOrRightBtn.overFilters;
		}
		
		public function set DownOrRightBtnOverFilters(value:Array):void
		{
			if(m_downOrRightBtn.overFilters != value)
			{
				m_downOrRightBtn.overFilters = value;
			}
		}
		
		public function get DownOrRightBtnDownFilters():Array
		{
			return m_downOrRightBtn.downFilters;
		}
		
		public function set DownOrRightBtnDownFilters(value:Array):void
		{
			if(m_downOrRightBtn.downFilters != value)
			{
				m_downOrRightBtn.downFilters = value;
			}
		}
		
		public function get DownOrRightBtnDisableFilters():Array
		{
			return m_downOrRightBtn.disableFilters;
		}
		
		public function set DownOrRightBtnDisableFilters(value:Array):void
		{
			if(m_downOrRightBtn.disableFilters != value)
			{
				m_downOrRightBtn.disableFilters = value;
			}
		}
		
		public function get DownOrRightBtnImageOffsetX():int
		{
			return m_downOrRightBtn.offsetX;
		}
		
		public function set DownOrRightBtnImageOffsetX(value:int):void
		{
			if(m_downOrRightBtn.offsetX != value)
			{
				m_downOrRightBtn.offsetX = value;
			}
		}
		
		public function get DownOrRightBtnImageOffsetY():int
		{
			return m_downOrRightBtn.offsetY;
		}
		
		public function set DownOrRightBtnImageOffsetY(value:int):void
		{
			if(m_downOrRightBtn.offsetY != value)
			{
				m_downOrRightBtn.offsetY = value;
			}
		}
		
		public function get DownOrRightBtnImageOverOffsetX():int
		{
			return m_downOrRightBtn.overOffsetX;
		}
		
		public function set DownOrRightBtnImageOverOffsetX(value:int):void
		{
			if(m_downOrRightBtn.overOffsetX != value)
			{
				m_downOrRightBtn.overOffsetX = value;
			}
		}
		
		public function get DownOrRightBtnImageOverOffsetY():int
		{
			return m_downOrRightBtn.overOffsetY;
		}
		
		public function set DownOrRightBtnImageOverOffsetY(value:int):void
		{
			if(m_downOrRightBtn.overOffsetY != value)
			{
				m_downOrRightBtn.overOffsetY = value;
			}
		}
		
		public function get DownOrRightBtnImageDownOffsetX():int
		{
			return m_downOrRightBtn.downOffsetX;
		}
		
		public function set DownOrRightBtnImageDownOffsetX(value:int):void
		{
			if(m_downOrRightBtn.downOffsetX != value)
			{
				m_downOrRightBtn.downOffsetX = value;
			}
		}
		
		public function get DownOrRightBtnImageDownOffsetY():int
		{
			return m_downOrRightBtn.downOffsetY;
		}
		
		public function set DownOrRightBtnImageDownOffsetY(value:int):void
		{
			if(m_downOrRightBtn.downOffsetY != value)
			{
				m_downOrRightBtn.downOffsetY = value;
			}
		}
		
		
		
		
		
		
		
		
		
		
		public function get BarUpAsset():DisplayObject
		{
			return m_bar.upImage;
		}
		
		public function set BarUpAsset(value:DisplayObject):void
		{
			if(m_bar.upImage != value)
			{
				m_bar.upImage = value;
				
				onPropertiesChanged(BARCHANGE);
			}
		}
		
		public function get BarOverAsset():DisplayObject
		{
			return m_bar.overImage;
		}
		
		public function set BarOverAsset(value:DisplayObject):void
		{
			if(m_bar.overImage != value)
			{
				m_bar.overImage = value;
				
				onPropertiesChanged(BARCHANGE);
			}
		}
		
		public function get BarDownAsset():DisplayObject
		{
			return m_bar.downImage;
		}
		
		public function set BarDownAsset(value:DisplayObject):void
		{
			if(m_bar.downImage != value)
			{
				m_bar.downImage = value;
				
				onPropertiesChanged(BARCHANGE);
			}
		}
		
		public function get BarDisableAsset():DisplayObject
		{
			return m_bar.disableImage;
		}
		
		public function set BarDisableAsset(value:DisplayObject):void
		{
			if(m_bar.disableImage != value)
			{
				m_bar.disableImage = value;
				
				onPropertiesChanged(BARCHANGE);
			}
		}
		
		public function get BarUpFilters():Array
		{
			return m_bar.upFilters;
		}
		
		public function set BarUpFilters(value:Array):void
		{
			if(m_bar.upFilters != value)
			{
				m_bar.upFilters = value;
			}
		}
		
		public function get BarOverFilters():Array
		{
			return m_bar.overFilters;
		}
		
		public function set BarOverFilters(value:Array):void
		{
			if(m_bar.overFilters != value)
			{
				m_bar.overFilters = value;
			}
		}
		
		public function get BarDownFilters():Array
		{
			return m_bar.downFilters;
		}
		
		public function set BarDownFilters(value:Array):void
		{
			if(m_bar.downFilters != value)
			{
				m_bar.downFilters = value;
			}
		}
		
		public function get BarDisableFilters():Array
		{
			return m_bar.disableFilters;
		}
		
		public function set BarDisableFilters(value:Array):void
		{
			if(m_bar.disableFilters != value)
			{
				m_bar.disableFilters = value;
			}
		}
		
		public function get BarImageOffsetX():int
		{
			return m_bar.offsetX;
		}
		
		public function set BarImageOffsetX(value:int):void
		{
			if(m_bar.offsetX != value)
			{
				m_bar.offsetX = value;
			}
		}
		
		public function get BarImageOffsetY():int
		{
			return m_bar.offsetY;
		}
		
		public function set BarImageOffsetY(value:int):void
		{
			if(m_bar.offsetY != value)
			{
				m_bar.offsetY = value;
			}
		}
		
		public function get BarImageOverOffsetX():int
		{
			return m_bar.overOffsetX;
		}
		
		public function set BarImageOverOffsetX(value:int):void
		{
			if(m_bar.overOffsetX != value)
			{
				m_bar.overOffsetX = value;
			}
		}
		
		public function get BarImageOverOffsetY():int
		{
			return m_bar.overOffsetY;
		}
		
		public function set BarImageOverOffsetY(value:int):void
		{
			if(m_bar.overOffsetY != value)
			{
				m_bar.overOffsetY = value;
			}
		}
		
		public function get BarImageDownOffsetX():int
		{
			return m_bar.downOffsetX;
		}
		
		public function set BarImageDownOffsetX(value:int):void
		{
			if(m_bar.downOffsetX != value)
			{
				m_bar.downOffsetX = value;
			}
		}
		
		public function get BarImageDownOffsetY():int
		{
			return m_bar.downOffsetY;
		}
		
		public function set BarImageDownOffsetY(value:int):void
		{
			if(m_bar.downOffsetY != value)
			{
				m_bar.downOffsetY = value;
			}
		}
		
		
		
		
		

		public function get thumb():DisplayObject
		{
			return m_thumb;
		}

		public function set thumb(value:DisplayObject):void
		{
			if(m_thumb != value)
			{
				if(m_thumb) DisposeUtil.free(m_thumb, m_freeBMD);
				
				m_thumb = value;
				
				onPropertiesChanged(THUMBCHANGE);
			}
		}

		public function get freeBMD():Boolean
		{
			return m_freeBMD;
		}

		public function set freeBMD(value:Boolean):void
		{
			m_freeBMD = value;
			
			m_bar.freeBMD = value;
			m_upOrLeftBtn.freeBMD = value;
			m_downOrRightBtn.freeBMD = value;
		}

		public function get scrollValue():int
		{
			return m_scrollValue;
		}

		public function set scrollValue(value:int):void
		{
			value = Math.max(value, m_scrollValueOffset);
			value = Math.min(value, m_maxScrollValue);
			
			if(m_scrollValue != value)
			{
				m_scrollValue = value;
				
				positionBar();
				trace(m_scrollValue);
				dispatchEvent(new DisplayEvent(DisplayEvent.CHANGED, m_scrollValue));
			}
		}

//		public function get visableSize():int
//		{
//			return m_visableSize;
//		}
//
//		public function set visableSize(value:int):void
//		{
//			if(m_visableSize != value)
//			{
//				m_visableSize = value;
//				
//				onPropertiesChanged(SCROLLDATA);
//			}
//		}

		public function get viewSize():int
		{
			return m_viewSize;
		}

		public function set viewSize(value:int):void
		{
			if(m_viewSize != value)
			{
				m_viewSize = value;
				
				onPropertiesChanged(SCROLLDATA);
			}
		}

		public function get scrollValueOffset():int
		{
			return m_scrollValueOffset;
		}

		public function set scrollValueOffset(value:int):void
		{
			if(m_scrollValueOffset != value)
			{
				m_scrollValueOffset = value;
				
				onPropertiesChanged(SCROLLVALUEOFFSET);
			}
		}
	}
}