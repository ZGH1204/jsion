package jsion.components
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import jsion.comps.CompGlobal;
	import jsion.comps.Component;
	import jsion.utils.DepthUtil;
	import jsion.utils.DisposeUtil;
	
	public class JProgressBar extends Component
	{
		public static const BACKGROUND:String = CompGlobal.BACKGROUND;
		
		public static const HORIZONTAL:String = CompGlobal.HORIZONTAL;
		public static const VERTICAL:String = CompGlobal.VERTICAL;
		
		public static const SCALE:String = CompGlobal.SCALE;
		public static const MASK:String = CompGlobal.MASK;
		
		public static const BAR:String = "bar";
		
		private var m_background:DisplayObject;
		
		private var m_bar:DisplayObject;
		
		private var m_orientation:String;
		
		private var m_minValue:Number;
		
		private var m_maxValue:Number;
		
		private var m_value:Number;
		
		private var m_progressType:String;
		
		public function JProgressBar(orientation:String = HORIZONTAL, container:DisplayObjectContainer=null, xPos:Number=0, yPos:Number=0)
		{
			m_orientation = orientation;
			
			m_minValue = 0;
			
			m_maxValue = 100;
			
			m_value = 0;
			
			super(container, xPos, yPos);
			
			if(m_orientation != HORIZONTAL && m_orientation != VERTICAL)
				throw new ArgumentError("orientation");
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
				
				if(m_minValue > m_maxValue)
				{
					m_minValue = m_minValue - m_maxValue;
					m_maxValue = m_maxValue + m_minValue;
					m_minValue = m_maxValue - m_minValue;
				}
				
				invalidate();
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
				
				if(m_minValue > m_maxValue)
				{
					m_minValue = m_minValue - m_maxValue;
					m_maxValue = m_maxValue + m_minValue;
					m_minValue = m_maxValue - m_minValue;
				}
				
				invalidate();
			}
		}
		
		public function get val():Number
		{
			return m_value;
		}
		
		public function set val(value:Number):void
		{
			if(m_value != value)
			{
				m_value = value;
				
				if(m_value < m_minValue) m_value = m_minValue;
				if(m_value > m_maxValue) m_value = m_maxValue;
				
				invalidate();
			}
		}
		
		override public function draw():void
		{
			if(m_background == null)
			{
				m_background = getDisplayObject(BACKGROUND);
				addChild(m_background);
				DepthUtil.bringToBottom(m_background);
				safeDrawAtOnceByDisplay(m_background);
			}
			
			if(m_bar == null)
			{
				m_bar = getDisplayObject(BAR);
				addChild(m_bar);
				DepthUtil.bringToTop(m_bar);
				safeDrawAtOnceByDisplay(m_bar);
			}
			
			if(m_background)
			{
				if(width <= 0) width = m_background.width;
				if(height <= 0) height = m_background.height;
				
				if(m_orientation == VERTICAL)
				{
					m_background.height = realHeight;
				}
				else
				{
					m_background.width = realWidth;
				}
			}
			
			if(m_bar)
			{
				var tmp:Number = Math.abs((m_value - m_minValue) / (m_maxValue - m_minValue));
				
				if(m_orientation == VERTICAL)
				{
					m_bar.height = realHeight * tmp;
					
					m_bar.x = (realWidth - m_bar.width) / 2;
					m_bar.y = realHeight - m_bar.height;
				}
				else
				{
					m_bar.width = realWidth * tmp;
					m_bar.x = 0;
					m_bar.y = (realHeight - m_bar.height) / 2;
				}
			}
			
			super.draw();
		}
		
		override public function dispose():void
		{
			DisposeUtil.free(m_background);
			m_background = null;
			
			DisposeUtil.free(m_bar);
			m_bar = null;
			
			super.dispose();
		}
	}
}