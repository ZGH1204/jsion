package jsion.display
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import jsion.comps.Component;
	import jsion.events.DisplayEvent;
	import jsion.utils.DelayUtil;
	import jsion.utils.DisposeUtil;
	import jsion.utils.JUtil;
	
	/**
	 * 当进度显示对象缓动到最大时派发，事件数据为 null。
	 */	
	[Event(name="progressViewComplete", type="jsion.events.DisplayEvent")]
	/**
	 * 进度条。支持横向或纵向两种类型，缩放或遮罩两种模式。
	 * @author Jsion
	 * 
	 */	
	public class ProgressBar extends Component
	{
		/**
		 * 宽度属性变更
		 */		
		public static const WIDTH:String = Component.WIDTH;
		
		/**
		 * 高度属性变更
		 */		
		public static const HEIGHT:String = Component.HEIGHT;
		
		/**
		 * 背景显示对象发生变更
		 */		
		public static const BACKGROUND:String = "background";
		
		/**
		 * 进度显示对象发生变更
		 */		
		public static const PROGRESSBAR:String = "progressBar";
		
		/**
		 * 进度条数据发生变更
		 */		
		public static const PROGRESSDATA:String = "progressData";
		
		/**
		 * 进度显示对象宽度发生变更
		 */		
		public static const BARWIDTH:String = "barWidth";
		
		/**
		 * 进度显示对象高度发生变更
		 */		
		public static const BARHEIGHT:String = "barHeight";
		
		/**
		 * 进度显示对象偏移量发生变更
		 */		
		public static const BAROFFSET:String = "barOffset";
		
		/**
		 * 横向进度条
		 */		
		public static const HORIZONTAL:int = 1;
		
		/**
		 * 纵向进度条
		 */		
		public static const VERTICAL:int = 2;
		
		/**
		 * 遮罩模式
		 */		
		public static const MASK:int = 1;
		
		/**
		 * 缩放模式
		 */		
		public static const SCALE:int = 2;
		
		
		
		
		
		private var m_orientation:int;
		
		private var m_progressType:int;
		
		
		private var m_background:DisplayObject;
		
		private var m_progressBar:DisplayObject;
		
		private var m_barWidth:int;
		
		private var m_barHeight:int;
		
		private var m_barOffsetX:int;
		
		private var m_barOffsetY:int;
		
		private var m_manualBarWidth:Boolean;
		
		private var m_manualBarHeight:Boolean;
		
		
		private var m_minValue:Number;
		
		private var m_maxValue:Number;
		
		private var m_value:Number;
		
		
		
		
		private var m_dataIsAdded:Boolean;
		
		private var m_isAdd:Boolean;
		
		private var m_curLen:int;
		
		private var m_tarLen:int;
		
		private var m_viewVal:Number;
		
		private var m_stepMulti:Number;
		
		
		public function ProgressBar(orientation:int = HORIZONTAL, progressType:int = MASK)
		{
			m_orientation = orientation;
			m_progressType = progressType;
			
			super();
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function initialize():void
		{
			if(m_orientation != HORIZONTAL && m_orientation != VERTICAL)
			{
				throw new Error("进度条类型错误");
				return;
			}
			
			if(m_progressType != MASK && m_progressType != SCALE)
			{
				throw new Error("进度模式错误");
				return;
			}
			
			super.initialize();
			
			m_value = 0;
			m_viewVal = 0;
			m_minValue = 0;
			m_maxValue = 100;
			m_viewVal = 0;
			m_stepMulti = 0.1;
			
			m_isAdd = true;
			m_freeBMD = false;
			m_dataIsAdded = true;
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function addChildren():void
		{
			super.addChildren();
			
			if(m_background) addChild(m_background);
			
			if(m_progressBar) addChild(m_progressBar);
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function onProppertiesUpdate():void
		{
			super.onProppertiesUpdate();
			
			updateProgressViewSize();
			
			refreshBarView(m_curLen);
			
			updateProgressBar(m_value);
		}
		
		private function updateProgressViewSize():void
		{
			if(isChanged(BACKGROUND) || isChanged(WIDTH) || isChanged(HEIGHT))
			{
				if(m_background)
				{
					m_background.width = m_width;
					m_background.height = m_height;
				}
			}
			
			if(isChanged(PROGRESSBAR) || isChanged(BARWIDTH) || isChanged(BARHEIGHT))
			{
				if(m_progressBar)
				{
					m_progressBar.width = m_barWidth;
					m_progressBar.height = m_barHeight;
				}
			}
		}
		
		private function updateProgressBar(val:Number):void
		{
			if(m_progressBar)
			{
				if(val == m_viewVal) return;
				
				var temp:Number = (val - m_minValue) / (m_maxValue - m_minValue);
				
				if(isNaN(temp)) temp = 0;
				
				temp = Math.min(temp, 1);
				
				if(m_orientation == HORIZONTAL)
				{
					m_tarLen = int(temp * m_barWidth);
				}
				else
				{
					m_tarLen = int(temp * m_barHeight);
				}
				
				m_isAdd == m_tarLen > m_curLen;
				
				if(m_dataIsAdded)
				{
					if(m_tarLen > m_curLen)
					{
						JUtil.addEnterFrame(__updateProgressMask);
					}
					else
					{
						m_curLen = m_tarLen;
						
						refreshBarView(m_curLen);
					}
				}
				else
				{
					if(m_tarLen < m_curLen)
					{
						JUtil.addEnterFrame(__updateProgressMask);
					}
					else
					{
						m_curLen = m_tarLen;
						
						refreshBarView(m_curLen);
					}
				}
			}
		}
		
		private function __updateProgressMask(e:Event):void
		{
			var temp:Number = Math.abs((m_tarLen - m_curLen) * m_stepMulti);
			
			if(isNaN(temp) || temp < 2) temp = 2;
			else temp = Math.max(temp, 2);
			
			if(m_isAdd)
			{
				m_curLen += int(temp);
				
				if(m_curLen >= m_tarLen)
				{
					m_curLen = m_tarLen;
					
					JUtil.removeEnterFrame(__updateProgressMask);
				}
			}
			else
			{
				m_curLen -= int(temp);
				
				if(m_curLen <= m_tarLen)
				{
					m_curLen = m_tarLen;
					
					JUtil.removeEnterFrame(__updateProgressMask);
				}
			}
			
			refreshBarView(m_curLen);
		}
		
		private function refreshBarView(len:int):void
		{
			var rect:Rectangle = new Rectangle();
			
			m_progressBar.x = m_barOffsetX;
			m_progressBar.y = m_barOffsetY;
			
			if(m_orientation == HORIZONTAL)
			{
				rect.width = len;
				rect.height = m_barHeight;
			}
			else
			{
				rect.width = m_barWidth;
				rect.height = len;
				rect.x = 0;
				rect.y = m_barHeight - rect.height;
				
				m_progressBar.x += rect.x;
				m_progressBar.y += rect.y;
			}
			
			if(m_progressType == MASK)
			{
				m_progressBar.scrollRect = rect;
			}
			else
			{
				m_progressBar.width = rect.width;
				m_progressBar.height = rect.height;
			}
			
			if(m_tarLen > 0) m_viewVal = (len / m_tarLen) * m_value;
			
			onViewPercentChanged(m_viewVal);
			
			if(m_dataIsAdded)
			{
				if(m_viewVal == m_maxValue)
				{
					DelayUtil.setDelayApply(fireCompleteEvent);
				}
			}
			else
			{
				if(m_viewVal == m_minValue)
				{
					DelayUtil.setDelayApply(fireCompleteEvent);
				}
			}
		}
		
		/**
		 * 进度显示对象大小发生改变时被调用。
		 * @param viewValue 当前进度显示对象大小对应的进度值。
		 * 
		 */		
		protected function onViewPercentChanged(viewValue:int):void
		{
			
		}
		
		private function fireCompleteEvent():void
		{
			dispatchEvent(new DisplayEvent(DisplayEvent.PROGRESS_VIEW_COMPLETE));
		}
		
		/**
		 * 方向类型
		 */
		public function get orientation():int
		{
			return m_orientation;
		}
		
		/**
		 * 进度模式
		 */
		public function get progressType():int
		{
			return m_progressType;
		}
		
		/**
		 * 进度条的背景显示对象。如果 width 或 height 属性未设置将设置这两个属性值。
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
		 * 进度显示对象。如果 barWidth 或 barHeight 未设置则将设置这两个属性值。
		 */		
		public function get progressBar():DisplayObject
		{
			return m_progressBar;
		}
		
		/** @private */
		public function set progressBar(value:DisplayObject):void
		{
			if(m_progressBar != value)
			{
				DisposeUtil.free(m_progressBar, m_freeBMD);
				
				m_progressBar = value;
				
				if(m_progressBar)
				{
					if(m_manualBarWidth == false) m_barWidth = m_progressBar.width;
					if(m_manualBarHeight == false) m_barHeight = m_progressBar.height;
					
					if(m_background == null)
					{
						if(manualWidth == false) m_width = m_barWidth;
						if(manualHeight == false) m_height = m_barHeight;
					}
				}
				
				onPropertiesChanged(PROGRESSBAR);
			}
		}
		
		/**
		 * 进度显示对象的宽度
		 */		
		public function get barWidth():int
		{
			return m_barWidth;
		}
		
		/** @private */
		public function set barWidth(value:int):void
		{
			if(m_barWidth != value)
			{
				m_barWidth = value;
				
				m_manualBarWidth = true;
				
				onPropertiesChanged(BARWIDTH);
			}
		}
		
		/**
		 * 进度显示对象的高度
		 */		
		public function get barHeight():int
		{
			return m_barHeight;
		}
		
		/** @private */
		public function set barHeight(value:int):void
		{
			if(m_barHeight != value)
			{
				m_barHeight = value;
				
				m_manualBarHeight = true;
				
				onPropertiesChanged(BARHEIGHT);
			}
		}
		
		/**
		 * 进度显示对象的x坐标偏移量
		 */		
		public function get barOffsetX():int
		{
			return m_barOffsetX;
		}
		
		/** @private */
		public function set barOffsetX(value:int):void
		{
			if(m_barOffsetX != value)
			{
				m_barOffsetX = value;
				
				onPropertiesChanged(BAROFFSET);
			}
		}
		
		/**
		 * 进度显示对象的y坐标偏移量
		 */		
		public function get barOffsetY():int
		{
			return m_barOffsetY;
		}
		
		/** @private */
		public function set barOffsetY(value:int):void
		{
			if(m_barOffsetY != value)
			{
				m_barOffsetY = value;
				
				onPropertiesChanged(BAROFFSET);
			}
		}

		/**
		 * 最小值。默认为0。
		 * @default 0
		 */		
		public function get minValue():Number
		{
			return m_minValue;
		}

		/** @private */
		public function set minValue(value:Number):void
		{
			if(m_minValue != value)
			{
				m_minValue = value;
				
				if(m_value < m_minValue) m_value = m_minValue;
				
				onPropertiesChanged(PROGRESSDATA);
			}
		}

		/**
		 * 最大值。默认为100。
		 * @default 100
		 */		
		public function get maxValue():Number
		{
			return m_maxValue;
		}
		
		/** @private */
		public function set maxValue(value:Number):void
		{
			if(m_maxValue != value)
			{
				m_maxValue = value;
				
				if(m_value > m_maxValue) m_value = m_maxValue;
				
				onPropertiesChanged(PROGRESSDATA);
			}
		}

		/**
		 * 进度值
		 */		
		public function get value():Number
		{
			return m_value;
		}
		
		/** @private */
		public function set value(value:Number):void
		{
			if(m_value != value)// && value >= m_minValue && value <= m_maxValue)
			{
				m_value = value;
				
				onPropertiesChanged(PROGRESSDATA);
			}
		}
		
		/**
		 * 进度显示对象缓动系数。
		 * 此系数与所需缓动的距离相乘。
		 * 进度显示对象当前的目标长度-当前长度即为所需缓动的距离。
		 */		
		public function get stepMulti():Number
		{
			return m_stepMulti;
		}
		
		/** @private */
		public function set stepMulti(value:Number):void
		{
			if(m_stepMulti != value && value > 0 && value <= 1)
			{
				m_stepMulti = value;
			}
		}
		
		
		/**
		 * 当前进度条大小对应的进度值。
		 */		
		public function get viewValue():Number
		{
			return m_viewVal;
		}

		/**
		 * 指示设置的显示对象为Bitmap,被释放时是否释放 bitmapData 对象。默认为 false 。
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
		
		override public function dispose():void
		{
			JUtil.removeEnterFrame(__updateProgressMask);
			DelayUtil.removeDelayApply(fireCompleteEvent);
			
			DisposeUtil.free(m_background, m_freeBMD);
			m_background = null;
			
			DisposeUtil.free(m_progressBar, m_freeBMD);
			m_progressBar = null;
			
			super.dispose();
		}

		/**
		 * 获取或设置数据是否为递增趋势，当需要进度条缓动为倒退时才需要设置为 false，默认为 true。
		 * <ul>
		 * 	<li>true表示递增，进度预期值为最小值向最大值递增。</li>
		 * 	<li>false表示递增，进度预期值为最大值向最小值递减。</li>
		 * </ul>
		 */		
		public function get dataIsAdded():Boolean
		{
			return m_dataIsAdded;
		}
		
		/** @private */
		public function set dataIsAdded(value:Boolean):void
		{
			m_dataIsAdded = value;
		}

	}
}