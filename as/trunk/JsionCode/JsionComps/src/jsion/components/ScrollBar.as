package jsion.components
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import jsion.comps.CompGlobal;
	import jsion.comps.Component;
	import jsion.comps.events.UIEvent;
	
	import mx.controls.scrollClasses.ScrollThumb;
	
	public class ScrollBar extends Component
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
		
		private var m_orientation:String;
		
		private var m_background:DisplayObject;
		
		private var m_upButton:JButton;
		
		private var m_downButton:JButton;
		
		private var m_bar:ScrollThumb;
		
		private var m_minimum:Number;
		private var m_maximum:Number;
		
		private var m_viewSize:Number;
		private var m_scrollSize:Number;
		private var m_scrollValue:Number;
		
		private var m_minPosLimit:Number;
		private var m_maxPosLimit:Number;
		private var m_barFixPos:Number;
		
		private var m_buttonOffset:Number;
		
		public function ScrollBar(orientation:String = HORIZONTAL, container:DisplayObjectContainer=null, xPos:Number=0, yPos:Number=0)
		{
			m_viewSize = 0;
			m_scrollSize = 0;
			m_buttonOffset = 0;
			
			m_orientation = orientation;
			
			super(container, xPos, yPos);
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
		
		public function get viewSize():Number
		{
			return m_viewSize;
		}
		
		public function set viewSize(value:Number):void
		{
			if(m_viewSize != value)
			{
				m_viewSize = value;
				
				invalidate();
			}
		}
		
		public function get scrollSize():Number
		{
			return m_scrollSize;
		}
		
		public function set scrollSize(value:Number):void
		{
			if(m_scrollSize != value)
			{
				m_scrollSize = value;
				
				invalidate();
			}
		}
		
		public function get buttonOffset():Number
		{
			return m_buttonOffset;
		}
		
		public function set buttonOffset(value:Number):void
		{
			if(m_buttonOffset != value)
			{
				m_buttonOffset = value;
				
				invalidate();
			}
		}
		
		public function get scrollValue():Number
		{
			return m_scrollValue;
		}
		
		public function set scrollValue(value:Number):void
		{
			if(m_scrollValue != value)
			{
				m_scrollValue = value;
				
				fireChangeEvent();
			}
		}
		
		public function calcHScrollValue():void
		{
			scrollValue = (m_bar.x - minPosLimit) / (maxPosLimit - minPosLimit) * (m_maximum - m_minimum);
		}
		
		public function calcVScrollValue():void
		{
			scrollValue = (m_bar.y - minPosLimit) / (maxPosLimit - minPosLimit) * (m_maximum - m_minimum);
		}
		
		protected function correctValue():void
		{
			m_scrollValue = Math.min(m_scrollValue, m_maximum);
			m_scrollValue = Math.max(m_scrollValue, m_minimum);
		}
		
		protected function positionBar():void
		{
			if(m_orientation == HORIZONTAL)
			{
				m_bar.x = (m_scrollValue - 0) / (viewSize - scrollSize) * (maxPosLimit - minPosLimit) + minPosLimit;
			}
			else
			{
				m_bar.y = (m_scrollValue - 0) / (viewSize - scrollSize) * (maxPosLimit - minPosLimit) + minPosLimit;
			}
		}
		
		public function fireChangeEvent():void
		{
			dispatchEvent(new UIEvent(UIEvent.CHANGE));
		}
		
		override protected function addChildren():void
		{
			m_background = getDisplayObject(BACKGROUND);
			addChild(m_background);
			
			m_upButton = new JButton();
			addChild(m_upButton);
			
			m_downButton = new JButton();
			addChild(m_downButton);
			
			m_bar = new ScrollThumb();
			m_bar.scrollBar = this;
			m_bar.enableDrag = true;
			addChild(m_bar);
		}
		
		override public function draw():void
		{
			updateAtOnce();
			
			updateBackground();
			
			updateButtons();
			
			updateBarPos();
			
			updateLimitPos();
			
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
		
		private function updateAtOnce():void
		{
			m_upButton.drawAtOnce();
			m_downButton.drawAtOnce();
			m_bar.drawAtOnce();
			
			if(m_viewSize > m_scrollSize)
			{
				addChild(m_bar);
				m_upButton.enabled = true;
				m_downButton.enabled = true;
			}
			else
			{
				if(contains(m_bar)) removeChild(m_bar);
				
				m_upButton.enabled = false;
				m_downButton.enabled = false;
			}
		}
		
		private function updateLimitPos():void
		{
			if(m_orientation == HORIZONTAL)
			{
				m_minPosLimit = m_upButton.x + m_upButton.realWidth + m_buttonOffset;
				
				m_maxPosLimit = m_downButton.x - m_bar.realWidth - m_buttonOffset;
			}
			else
			{
				m_minPosLimit = m_upButton.y + m_upButton.realHeight + m_buttonOffset;
				
				m_maxPosLimit = m_downButton.y - m_bar.realHeight - m_buttonOffset;
			}
			
			m_minimum = 0;
			m_maximum = m_viewSize - m_scrollSize;
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
		
		private function updateButtons():void
		{
			if(m_orientation == HORIZONTAL)
			{
				m_upButton.x = m_buttonOffset;
				m_upButton.y = (realHeight - m_upButton.realHeight) / 2;
				
				m_downButton.x = realWidth - m_downButton.realWidth - m_buttonOffset;
				m_downButton.y = (realHeight - m_downButton.realHeight) / 2;
			}
			else
			{
				m_upButton.x = (realWidth - m_upButton.realWidth) / 2;
				m_upButton.y = m_buttonOffset;
				
				m_downButton.x = (realWidth - m_downButton.realWidth) / 2;
				m_downButton.y = realHeight - m_downButton.realHeight - m_buttonOffset;
			}
		}
		
		private function updateBarPos():void
		{
			var tmp:Number;
			
			if(m_orientation == HORIZONTAL)
			{
				tmp = realWidth - m_upButton.x - m_upButton.realWidth;
				tmp = tmp - m_downButton.x - m_downButton.realWidth;
				tmp = tmp - 2 * m_buttonOffset;
				
				if(m_viewSize > m_scrollSize)
				{
					m_bar.width = m_scrollSize / m_viewSize * tmp;
				}
				
				m_bar.y = (realHeight - m_bar.realHeight) / 2;
				
				m_barFixPos = m_bar.y;
			}
			else
			{
				tmp = realHeight - m_upButton.y - m_upButton.realHeight;
				tmp = tmp - m_downButton.y - m_downButton.realHeight;
				tmp = tmp - 2 * m_buttonOffset;
				
				if(m_viewSize > m_scrollSize)
				{
					m_bar.height = m_scrollSize / m_viewSize * tmp;
				}
				
				m_bar.x = (realWidth - m_bar.realWidth) / 2;
				
				m_barFixPos = m_bar.x;
			}
		}
	}
}


import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;

import jsion.components.JButton;
import jsion.components.ScrollBar;
import jsion.comps.CompGlobal;

class ScrollThumb extends JButton
{
	public static const THUMB:String = CompGlobal.THUMB;
	public static const HORIZONTAL:String = CompGlobal.HORIZONTAL;
	public static const VERTICAL:String = CompGlobal.VERTICAL;
	
	private var m_thumb:DisplayObject;
	
	private var m_orientation:String;
	
	private var m_scrollBar:ScrollBar;
	
	public function ScrollThumb(orientation:String = HORIZONTAL, container:DisplayObjectContainer=null, xPos:Number=0, yPos:Number=0)
	{
		m_orientation = orientation;
		
		super("", container, xPos, yPos);
	}
	
	public function get scrollBar():ScrollBar
	{
		return m_scrollBar;
	}
	
	public function set scrollBar(value:ScrollBar):void
	{
		m_scrollBar = value;
	}
	
	override protected function addChildren():void
	{
		super.addChildren();
		
		m_thumb = getDisplayObject(THUMB);
		addChild(m_thumb);
	}
	
	override public function draw():void
	{
		super.draw();
		
		if(m_thumb)
		{
			m_thumb.y = (realHeight - m_thumb.height) / 2;
			m_thumb.x = (realWidth - m_thumb.height) / 2;
		}
	}
	
	override public function set width(value:Number):void
	{
		if(m_orientation == HORIZONTAL)
		{
			if(value < minSize) value = minSize;
		}
		
		super.width = value;
	}
	
	override public function set height(value:Number):void
	{
		if(m_orientation != HORIZONTAL)
		{
			if(value < minSize) value = minSize;
		}
		
		super.height = value;
	}
	
	override public function setSize(w:Number, h:Number):void
	{
		throw new Error("请使用 width 或 height 属性.");
	}
	
	override public function get reviseInStage():Boolean
	{
		return false;
	}
	
	override public function dragingCallback():void
	{
		if(m_orientation == HORIZONTAL)
		{
			if(x < m_scrollBar.minPosLimit) x = m_scrollBar.minPosLimit;
			else if(x > m_scrollBar.maxPosLimit) x = m_scrollBar.maxPosLimit;
			
			y = m_scrollBar.barFixPos;
			
			m_scrollBar.calcHScrollValue();
		}
		else
		{
			x = m_scrollBar.barFixPos;
			
			if(y < m_scrollBar.minPosLimit) y = m_scrollBar.minPosLimit;
			else if(y > m_scrollBar.maxPosLimit) y = m_scrollBar.maxPosLimit;
			
			m_scrollBar.calcVScrollValue();
		}
	}
	
	public function get minSize():Number
	{
		if(m_thumb)
		{
			if(m_orientation == HORIZONTAL)
			{
				return m_thumb.width + 4;
			}
			else
			{
				return m_thumb.height + 4;
			}
		}
		
		return 10;
	}
}