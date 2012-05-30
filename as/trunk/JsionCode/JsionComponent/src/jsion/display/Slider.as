package jsion.display
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import jsion.comps.Component;
	import jsion.events.ReleaseEvent;
	import jsion.utils.DisposeUtil;
	
	public class Slider extends Component
	{
		public static const BACKGROUND:String = "background";
		
		public static const SLIDERBAR:String = "sliderBar";
		
		public static const SLIDERDATA:String = "sliderData";
		
		public static const BAROFFSET:String = "barOffset";
		
		/**
		 * 横向滑动条
		 */		
		public static const HORIZONTAL:int = 1;
		
		/**
		 * 纵向滑动条
		 */		
		public static const VERTICAL:int = 2;
		
		
		private var m_orientation:int;
		
		
		private var m_background:DisplayObject;
		
		private var m_sliderBar:Button;
		
		
		private var m_barOffsetX:int;
		
		private var m_barOffsetY:int;
		
		
		private var m_minValue:Number;
		
		private var m_maxValue:Number;
		
		private var m_value:Number;
		
		
		private var m_freeBMD:Boolean;
		
		
		/**
		 * 鼠标按下时拖动条的起始位置
		 */		
		private var m_startPoint:Point;
		/**
		 * 鼠标按下时拖动条的舞台鼠标位置
		 */		
		private var m_startGlobalPoint:Point;
		
		private var m_minPos:int;
		private var m_maxPos:int;
		
		
		public function Slider(orientation:int = HORIZONTAL)
		{
			m_orientation = orientation;
			
			super();
		}
		
		override public function beginChanges():void
		{
			m_sliderBar.beginChanges();
			
			super.beginChanges();
		}
		
		override public function commitChanges():void
		{
			m_sliderBar.commitChanges();
			
			super.commitChanges();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			m_value = 0;
			m_minValue = 0;
			m_maxValue = 100;
			
			m_sliderBar = new Button();
			
			m_sliderBar.alpha = 0.8;
			
			m_startPoint = new Point();
			
			m_startGlobalPoint = new Point();
		}
		
		override protected function initEvents():void
		{
			super.initEvents();
			
			m_sliderBar.addEventListener(MouseEvent.MOUSE_DOWN, __barMouseDownHandler);
			m_sliderBar.addEventListener(ReleaseEvent.RELEASE, __barReleaseHandler);
		}
		
		private function __barMouseDownHandler(e:MouseEvent):void
		{
			m_startPoint.x = barPosX;
			m_startPoint.y = barPosY;
			m_startGlobalPoint.x = stage.mouseX;
			m_startGlobalPoint.y = stage.mouseY;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, __mouseMoveHandler);
			stage.addEventListener(Event.DEACTIVATE, __deactivateHandler);
		}
		
		private function __barReleaseHandler(e:ReleaseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, __mouseMoveHandler);
			stage.removeEventListener(Event.DEACTIVATE, __deactivateHandler);
		}
		
		private function __deactivateHandler(e:Event):void
		{
			__barReleaseHandler(null);
		}
		
		private function __mouseMoveHandler(e:MouseEvent):void
		{
			if(m_orientation == HORIZONTAL)
			{
				barPosX = m_startPoint.x + stage.mouseX - m_startGlobalPoint.x;
				
				if(barPosX < m_minPos)
				{
					barPosX = m_minPos;
				}
				else if(barPosX > m_maxPos)
				{
					barPosX = m_maxPos;
				}
			}
			else
			{
				barPosY = m_startPoint.y + stage.mouseY - m_startGlobalPoint.y;
				
				if(barPosY < m_minPos)
				{
					barPosY = m_minPos;
				}
				else if(barPosY > m_maxPos)
				{
					barPosY = m_maxPos;
				}
			}
		}
		
		override protected function addChildren():void
		{
			super.addChildren();
			
			if(m_background) addChild(m_background);
			
			addChild(m_sliderBar);
		}
		
		override protected function onProppertiesUpdate():void
		{
			super.onProppertiesUpdate();
			
			updateSliderViewSize();
			
			updateSliderViewPos();
		}
		
		private function updateSliderViewSize():void
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
		
		private function updateSliderViewPos():void
		{
			var temp:Number = (m_value - m_minValue) / (m_maxValue - m_minValue);
			
			var posX:Number, posY:Number;
			
			if(m_orientation == HORIZONTAL)
			{
				m_minPos = m_barOffsetX;
				m_maxPos = m_width - m_barOffsetX;
				
				posX = temp * (m_width - m_barOffsetX * 2) + m_barOffsetX;
				posY = m_height / 2 + m_barOffsetY;
			}
			else
			{
				m_minPos = m_barOffsetY;
				m_maxPos = m_height - m_barOffsetY;
				
				posX = m_width / 2 + m_barOffsetX;
				posY = temp * (m_height - m_barOffsetY * 2) + m_barOffsetY;
			}
			
			barPosX = posX;
			barPosY = posY;
		}
		
		protected function get barPosX():Number
		{
			return m_sliderBar.x + m_sliderBar.width / 2;
		}
		
		protected function set barPosX(value:Number):void
		{
			m_sliderBar.x = value - m_sliderBar.width / 2;
		}
		
		protected function get barPosY():Number
		{
			return m_sliderBar.y + m_sliderBar.height / 2;
		}
		
		protected function set barPosY(value:Number):void
		{
			m_sliderBar.y = value - m_sliderBar.height / 2;
		}
		
		public function get orientation():int
		{
			return m_orientation;
		}
		
		public function get barOffsetX():int
		{
			return m_barOffsetX;
		}
		
		public function set barOffsetX(value:int):void
		{
			if(m_barOffsetX != value)
			{
				m_barOffsetX = value;
				
				onPropertiesChanged(BAROFFSET);
			}
		}
		
		public function get barOffsetY():int
		{
			return m_barOffsetY;
		}
		
		public function set barOffsetY(value:int):void
		{
			if(m_barOffsetY != value)
			{
				m_barOffsetY = value;
				
				onPropertiesChanged(BAROFFSET);
			}
		}

		public function get background():DisplayObject
		{
			return m_background;
		}

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

		public function get minValue():Number
		{
			return m_minValue;
		}

		public function set minValue(value:Number):void
		{
			if(m_minValue != value)
			{
				m_minValue = value;
				
				if(m_value < m_minValue) m_value = m_minValue;
				
				onPropertiesChanged(SLIDERDATA);
			}
		}

		public function get maxValue():Number
		{
			return m_maxValue;
		}

		public function set maxValue(value:Number):void
		{
			if(m_maxValue != value)
			{
				m_maxValue = value;
				
				if(m_value > m_maxValue) m_value = m_maxValue;
				
				onPropertiesChanged(SLIDERDATA);
			}
		}

		public function get value():Number
		{
			return m_value;
		}

		public function set value(value:Number):void
		{
			if(m_value != value && value >= m_minValue && value <= m_maxValue)
			{
				m_value = value;
				
				onPropertiesChanged(SLIDERDATA);
			}
		}
		
		
		/**
		 * 按钮弹起时的显示对象资源
		 * 如果宽度和高度未设置时会根据此显示对象的宽高来设置对应的值
		 */		
		public function get upImage():DisplayObject
		{
			return m_sliderBar.upImage;
		}
		
		/** @private */
		public function set upImage(value:DisplayObject):void
		{
			if(m_sliderBar.upImage != value)
			{
				m_sliderBar.upImage = value;
				
				onPropertiesChanged(SLIDERBAR);
			}
		}
		
		/**
		 * 按钮鼠标经过时的显示对象资源
		 */		
		public function get overImage():DisplayObject
		{
			return m_sliderBar.overImage;
		}
		
		/** @private */
		public function set overImage(value:DisplayObject):void
		{
			if(m_sliderBar.overImage != value)
			{
				m_sliderBar.overImage = value;
				
				onPropertiesChanged(SLIDERBAR);
			}
		}
		
		/**
		 * 按钮按下时的显示对象资源
		 */		
		public function get downImage():DisplayObject
		{
			return m_sliderBar.downImage;
		}
		
		/** @private */
		public function set downImage(value:DisplayObject):void
		{
			if(m_sliderBar.downImage != value)
			{
				m_sliderBar.downImage = value;
				
				onPropertiesChanged(SLIDERBAR);
			}
		}
		
		/**
		 * 按钮禁用时的显示对象资源
		 */		
		public function get disableImage():DisplayObject
		{
			return m_sliderBar.disableImage;
		}
		
		/** @private */
		public function set disableImage(value:DisplayObject):void
		{
			if(m_sliderBar.disableImage != value)
			{
				m_sliderBar.disableImage = value;
				
				onPropertiesChanged(SLIDERBAR);
			}
		}
		
		/**
		 * 按钮弹起时的滤镜对象
		 */		
		public function get upFilters():Array
		{
			return m_sliderBar.upFilters;
		}
		
		/** @private */
		public function set upFilters(value:Array):void
		{
			if(m_sliderBar.upFilters != value)
			{
				m_sliderBar.upFilters = value;
				
				onPropertiesChanged(SLIDERBAR);
			}
		}
		
		/**
		 * 按钮鼠标经过时的滤镜对象
		 */		
		public function get overFilters():Array
		{
			return m_sliderBar.overFilters;
		}
		
		/** @private */
		public function set overFilters(value:Array):void
		{
			if(m_sliderBar.overFilters != value)
			{
				m_sliderBar.overFilters = value;
				
				onPropertiesChanged(SLIDERBAR);
			}
		}
		
		/**
		 * 按钮按下时的滤镜对象
		 */		
		public function get downFilters():Array
		{
			return m_sliderBar.downFilters;
		}
		
		/** @private */
		public function set downFilters(value:Array):void
		{
			if(m_sliderBar.downFilters != value)
			{
				m_sliderBar.downFilters = value;
				
				onPropertiesChanged(SLIDERBAR);
			}
		}
		
		/**
		 * 按钮禁用时的滤镜对象
		 */		
		public function get disableFilters():Array
		{
			return m_sliderBar.disableFilters;
		}
		
		/** @private */
		public function set disableFilters(value:Array):void
		{
			if(m_sliderBar.disableFilters != value)
			{
				m_sliderBar.disableFilters = value;
				
				onPropertiesChanged(SLIDERBAR);
			}
		}
		
		/**
		 * 按钮状态显示对象x坐标偏移量
		 */
		public function get offsetX():int
		{
			return m_sliderBar.offsetX;
		}
		
		/** @private */
		public function set offsetX(value:int):void
		{
			if(m_sliderBar.offsetX != value)
			{
				m_sliderBar.offsetX = value;
				
				onPropertiesChanged(SLIDERBAR);
			}
		}
		
		/**
		 * 按钮状态显示对象y坐标偏移量
		 */
		public function get offsetY():int
		{
			return m_sliderBar.offsetY;
		}
		
		/** @private */
		public function set offsetY(value:int):void
		{
			if(m_sliderBar.offsetY != value)
			{
				m_sliderBar.offsetY = value;
				
				onPropertiesChanged(SLIDERBAR);
			}
		}
		
		/**
		 * 按钮鼠标经过时状态显示对象x坐标偏移量
		 */
		public function get overOffsetX():int
		{
			return m_sliderBar.overOffsetX;
		}
		
		/** @private */
		public function set overOffsetX(value:int):void
		{
			if(m_sliderBar.overOffsetX != value)
			{
				m_sliderBar.overOffsetX = value;
				
				onPropertiesChanged(SLIDERBAR);
			}
		}
		
		/**
		 * 按钮鼠标经过时状态显示对象y坐标偏移量
		 */
		public function get overOffsetY():int
		{
			return m_sliderBar.overOffsetY;
		}
		
		/** @private */
		public function set overOffsetY(value:int):void
		{
			if(m_sliderBar.overOffsetY != value)
			{
				m_sliderBar.overOffsetY = value;
				
				onPropertiesChanged(SLIDERBAR);
			}
		}
		
		/**
		 * 按钮按下时状态显示对象x坐标偏移量
		 */
		public function get downOffsetX():int
		{
			return m_sliderBar.downOffsetX;
		}
		
		/** @private */
		public function set downOffsetX(value:int):void
		{
			if(m_sliderBar.downOffsetX != value)
			{
				m_sliderBar.downOffsetX = value;
				
				onPropertiesChanged(SLIDERBAR);
			}
		}
		
		/**
		 * 按钮按下时状态显示对象y坐标偏移量
		 */
		public function get downOffsetY():int
		{
			return m_sliderBar.downOffsetY;
		}
		
		/** @private */
		public function set downOffsetY(value:int):void
		{
			if(m_sliderBar.downOffsetY != value)
			{
				m_sliderBar.downOffsetY = value;
				
				onPropertiesChanged(SLIDERBAR);
			}
		}

		public function get freeBMD():Boolean
		{
			return m_freeBMD;
		}

		public function set freeBMD(value:Boolean):void
		{
			m_freeBMD = value;
			
			m_sliderBar.freeBMD = value;
		}

	}
}