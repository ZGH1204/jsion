package jsion.components
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import jsion.comps.CompGlobal;
	import jsion.comps.Component;
	import jsion.comps.events.UIEvent;
	import jsion.core.ddrop.DDropMgr;
	import jsion.utils.DisposeUtil;
	
	[Event(name="change", type="jsion.comps.events.UIEvent")]
	public class Slider extends Component
	{
		public static const BACKGROUND:String = CompGlobal.BACKGROUND;
		
		public static const HORIZONTAL:String = CompGlobal.HORIZONTAL;
		public static const VERTICAL:String = CompGlobal.VERTICAL;
		
		public static const UP_IMG:String = CompGlobal.UP_IMG;
		public static const OVER_IMG:String = CompGlobal.OVER_IMG;
		public static const DOWN_IMG:String = CompGlobal.DOWN_IMG;
		public static const DISABLED_IMG:String = CompGlobal.DISABLED_IMG;
		
		public static const UP_FILTERS:String = CompGlobal.UP_FILTERS;
		public static const OVER_FILTERS:String = CompGlobal.OVER_FILTERS;
		public static const DOWN_FILTERS:String = CompGlobal.DOWN_FILTERS;
		public static const DISABLED_FILTERS:String = CompGlobal.DISABLED_FILTERS;
		
		private var m_minimum:Number;
		private var m_maximum:Number;
		private var m_sliderValue:Number;
		private var m_step:Number;
		
		private var m_bar:SliderBar;
		private var m_rule:Sprite;
		private var m_background:DisplayObject;
		
		private var m_orientation:String;
		private var m_minPosLimit:Number;
		private var m_maxPosLimit:Number;
		
		
		private var m_showRule:Boolean;
		private var m_ruleH:Number;
		private var m_ruleOffset:Number;
		private var m_ruleCount:int;
		
		private var m_barFixPos:Number;
		private var m_barOffset:Number;
		
		
		public function Slider(orientation:String = HORIZONTAL,container:DisplayObjectContainer=null, xPos:Number=0, yPos:Number=0)
		{
			m_orientation = orientation;
			
			m_ruleH = 5;
			m_ruleOffset = 5;
			m_ruleCount = 1;
			
			m_barOffset = 0;
			
			m_step = 0.02;
			
			m_minimum = 0;
			m_maximum = 1;
			m_sliderValue = 0;
			
			super(container, xPos, yPos);
			
			if(m_orientation != HORIZONTAL && m_orientation != VERTICAL)
				throw new ArgumentError("orientation");
		}
		
		public function get barFixPos():Number
		{
			return m_barFixPos;
		}
		
		public function get minPosLimit():Number
		{
			return m_minPosLimit;
		}
		
		public function get maxPosLimit():Number
		{
			return m_maxPosLimit;
		}
		
		public function get step():Number
		{
			return m_step;
		}
		
		public function set step(value:Number):void
		{
			m_step = value;
		}
		
		public function get minimum():Number
		{
			return m_minimum;
		}
		
		public function set minimum(value:Number):void
		{
			if(m_minimum != value)
			{
				m_minimum = value;
				
				correctValue();
				positionBar();
				fireChangeEvent();
			}
		}
		
		public function get maximum():Number
		{
			return m_maximum;
		}
		
		public function set maximum(value:Number):void
		{
			if(m_maximum != value)
			{
				if(value < m_minimum)
				{
					throw new Error("最大值不能小于最小值");
					return;
				}
				
				m_maximum = value;
				
				correctValue();
				positionBar();
				fireChangeEvent();
			}
		}
		
		public function get sliderValue():Number
		{
			return m_sliderValue;
		}
		
		public function set sliderValue(val:Number):void
		{
			if(m_sliderValue != val)
			{
				m_sliderValue = val;
				
				correctValue();
				positionBar();
				fireChangeEvent();
			}
		}
		
		public function get showRule():Boolean
		{
			return m_showRule;
		}
		
		public function set showRule(value:Boolean):void
		{
			if(m_showRule != value)
			{
				m_showRule = value;
				
				invalidate();
			}
		}
		
		public function get ruleH():Number
		{
			return m_ruleH;
		}
		
		public function set ruleH(value:Number):void
		{
			if(m_ruleH != value)
			{
				m_ruleH = value;
				
				if(m_showRule) invalidate();
			}
		}
		
		public function get ruleOffset():Number
		{
			return m_ruleOffset;
		}
		
		public function set ruleOffset(value:Number):void
		{
			if(m_ruleOffset != value)
			{
				m_ruleOffset = value;
				
				if(m_showRule) invalidate();
			}
		}
		
		public function get ruleCount():int
		{
			return m_ruleCount;
		}
		
		public function set ruleCount(value:int):void
		{
			if(m_ruleCount != value && value >= 1)
			{
				m_ruleCount = value;
				
				if(m_showRule) invalidate();
			}
		}
		
		public function get barOffset():Number
		{
			return m_barOffset;
		}
		
		public function set barOffset(value:Number):void
		{
			if(m_barOffset != value)
			{
				m_barOffset = value;
				
				invalidate();
			}
		}
		
		public function calcHValue():void
		{
			sliderValue = (m_bar.x - minPosLimit) / (maxPosLimit - minPosLimit) * (maximum - minimum) + minimum;
		}
		
		public function calcVValue():void
		{
			sliderValue = (m_bar.y - minPosLimit) / (maxPosLimit - minPosLimit) * (maximum - minimum) + minimum;
		}
		
		private function fireChangeEvent():void
		{
			dispatchEvent(new UIEvent(UIEvent.CHANGE));
		}
		
		public function setSliderParams(minVal:Number, maxVal:Number, value:Number):void
		{
			minimum = minVal;
			maximum = maxVal;
			sliderValue = value;
		}
		
		public function setBarStyle(key:String, value:*, freeBMD:Boolean = true):void
		{
			m_bar.setStyle(key, value, freeBMD);
		}
		
		protected function correctValue():void
		{
			m_sliderValue = Math.min(m_sliderValue, m_maximum);
			m_sliderValue = Math.max(m_sliderValue, m_minimum);
		}
		
		protected function positionBar():void
		{
			if(m_orientation == HORIZONTAL)
			{
				m_bar.x = (m_sliderValue - minimum) / (maximum - minimum) * (maxPosLimit - minPosLimit) + minPosLimit;
			}
			else
			{
				m_bar.y = (m_sliderValue - minimum) / (maximum - minimum) * (maxPosLimit - minPosLimit) + minPosLimit;
			}
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			buttonMode = true;
			useHandCursor = true;
		}
		
		override protected function addChildren():void
		{
			m_background = getDisplayObject(BACKGROUND);
			addChild(m_background);
			
			m_rule = new Sprite();
			addChild(m_rule);
			
			m_bar = new SliderBar(m_orientation);//getDisplayObject(BAR) as SliderBar;
			m_bar.slider = this;
			m_bar.enableDrag = true;
			addChild(m_bar);
		}
		
		override protected function initEvents():void
		{
			addEventListener(MouseEvent.CLICK, __clickHandler);
			addEventListener(MouseEvent.MOUSE_WHEEL, __wheelHandler);
		}
		
		private function __clickHandler(e:MouseEvent):void
		{
			m_bar.x = e.localX - m_bar.realWidth / 2;
			m_bar.y = e.localY - m_bar.realHeight / 2;
			m_bar.dragingCallback();
		}
		
		private function __wheelHandler(e:MouseEvent):void
		{
			if(e.delta > 0)
			{
				sliderValue -= m_step;
			}
			else
			{
				sliderValue += m_step;
			}
			
			m_bar.dragingCallback();
		}
		
		override public function draw():void
		{
			m_bar.drawAtOnce();
			
			updateBackground();
			
			updateLimitPos();
			
			updateBarPos();
			
			correctValue();
			
			positionBar();
			
			drawRule();
			
			graphics.clear();
			graphics.beginFill(0x0, 0);
			if(m_orientation == HORIZONTAL)
			{
				graphics.drawRect(m_minPosLimit, m_barFixPos, m_maxPosLimit - m_minPosLimit, m_bar.realHeight);
			}
			else
			{
				graphics.drawRect(m_barFixPos, m_minPosLimit, m_bar.realWidth, m_maxPosLimit - m_minPosLimit);
			}
			graphics.endFill();
			
			super.draw();
		}
		
		private function updateLimitPos():void
		{
			m_minPosLimit = m_barOffset;
			
			if(m_orientation == HORIZONTAL)
			{
				m_maxPosLimit = realWidth;
				m_maxPosLimit -= m_bar.realWidth;
			}
			else
			{
				m_maxPosLimit = realHeight;
				m_maxPosLimit -= m_bar.realHeight;
			}
			
			m_maxPosLimit -= m_barOffset;
		}
		
		private function updateBackground():void
		{
			if(m_background)
			{
				m_background.x = 0;
				m_background.y = 0;
				
				if(width > 0) m_background.width = width;
				else m_background.width = originalWidth;
				
				if(height > 0) m_background.height = height;
				else m_background.height = originalHeight;
			}
		}
		
		private function updateBarPos():void
		{
			if(m_orientation == HORIZONTAL)
			{
				m_bar.y = realHeight - m_bar.realHeight;
				m_bar.y /= 2;
				
				m_barFixPos = m_bar.y;
			}
			else
			{
				m_bar.x = realWidth - m_bar.realWidth;
				m_bar.x /= 2;
				
				m_barFixPos = m_bar.x;
			}
		}
		
		private function drawRule():void
		{
			var tmp:Number;
			var dis:Number;
			var cur:Number;
			
			var g:Graphics = m_rule.graphics;
			
			g.clear();
			g.lineStyle(1, 0x0);
			
			if(m_showRule)
			{
				cur = m_minPosLimit;
				
				if(m_orientation == HORIZONTAL)
				{
					m_rule.y = -m_ruleOffset;
					
					cur += m_bar.realWidth / 2;
					
					tmp = realWidth - 2 * cur;
					dis = tmp / m_ruleCount;
					
					for(var i:int = 0; i <= m_ruleCount; i++)
					{
						g.moveTo(cur, 0);
						g.lineTo(cur, m_ruleH);
						
						cur += dis;
					}
				}
				else
				{
					m_rule.x = -m_ruleOffset;
					
					cur += m_bar.realHeight / 2;
					
					tmp = realHeight - 2 * cur;
					dis = tmp / m_ruleCount;
					
					for(var j:int = 0; j <= m_ruleCount; j++)
					{
						g.moveTo(0, cur);
						g.lineTo(m_ruleH, cur);
						
						cur += dis;
					}
				}
			}
		}
		
		override public function dispose():void
		{
			removeEventListener(MouseEvent.CLICK, __clickHandler);
			removeEventListener(MouseEvent.MOUSE_WHEEL, __wheelHandler);
			
			DisposeUtil.free(m_background);
			m_background = null;
			
			DisposeUtil.free(m_bar);
			m_bar = null;
			
			DisposeUtil.free(m_rule);
			m_rule = null;
			
			super.dispose();
		}
	}
}
import flash.display.DisplayObjectContainer;

import jsion.components.JButton;
import jsion.components.Slider;
import jsion.comps.CompGlobal;

class SliderBar extends JButton
{
	public static const HORIZONTAL:String = CompGlobal.HORIZONTAL;
	public static const VERTICAL:String = CompGlobal.VERTICAL;
	
	private var m_orientation:String;
	
	private var m_slider:Slider;
	
	public function SliderBar(orientation:String = HORIZONTAL, container:DisplayObjectContainer=null, xPos:Number=0, yPos:Number=0)
	{
		m_orientation = orientation;
		
		super("", container, xPos, yPos);
	}
	
	public function get slider():Slider
	{
		return m_slider;
	}
	
	public function set slider(value:Slider):void
	{
		m_slider = value;
	}
	
	override public function get stopPropagation():Boolean
	{
		return true;
	}
	
	override public function get reviseInStage():Boolean
	{
		return false;
	}
	
	override public function dragingCallback():void
	{
		if(m_orientation == HORIZONTAL)
		{
			if(x < m_slider.minPosLimit) x = m_slider.minPosLimit;
			else if(x > m_slider.maxPosLimit) x = m_slider.maxPosLimit;
			
			y = m_slider.barFixPos;
			
			m_slider.calcHValue();
		}
		else
		{
			x = m_slider.barFixPos;
			
			if(y < m_slider.minPosLimit) y = m_slider.minPosLimit;
			else if(y > m_slider.maxPosLimit) y = m_slider.maxPosLimit;
			
			m_slider.calcVValue();
		}
	}
	
	override public function dispose():void
	{
		m_slider = null;
		
		super.dispose();
	}
}

