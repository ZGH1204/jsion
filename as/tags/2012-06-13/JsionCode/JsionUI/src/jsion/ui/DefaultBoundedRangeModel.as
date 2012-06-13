package jsion.ui
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import jsion.ui.events.ComponentEvent;
	
	public class DefaultBoundedRangeModel extends EventDispatcher implements IBoundedRangeModel
	{
		protected var m_minimum:int;
		
		protected var m_maximum:int;
		
		protected var m_value:Number;
		
		public function DefaultBoundedRangeModel(value:int=0, min:int=0, max:int=100)
		{
			if(max >= min && value >= min && value <= max)
			{
				m_value = value;
				m_minimum = min;
				m_maximum = max;
			}
		}
		
		public function getMinimum():int
		{
			return m_minimum;
		}
		
		public function setMinimum(value:int):void
		{
			if(m_minimum != value)
			{
				var newMax:int = Math.max(value, m_maximum);
				var newValue:int = Math.max(value, m_value);
				setRangeProperties(newValue, value, newMax);
			}
		}
		
		public function getMaximum():int
		{
			return m_maximum;
		}
		
		public function setMaximum(value:int):void
		{
			if(m_maximum != value)
			{
				var newMin:int = Math.min(value, m_minimum);
				var newValue:int = Math.min(value, m_value);
				setRangeProperties(newValue, newMin, value);
			}
		}
		
		public function getValue():Number
		{
			return m_value;
		}
		
		public function setValue(value:Number):void
		{
			if(m_value != value)
			{
				value = Math.min(value, m_maximum);
				var newValue:Number = Math.max(value, m_minimum);
				setRangeProperties(newValue, m_minimum, m_maximum);
				//trace("当前Value为：" + newValue);
			}
		}
		
		public function setRangeProperties(newValue:Number, newMin:int, newMax:int):void
		{
			if(newMin > newMax) newMin = newMax;
			
			if(newValue > newMax) newMax = newValue;
			
			if(newValue < newMin) newMin = newValue;
			
			var isChange:Boolean = newValue != m_value || newMin != m_minimum || newMax != m_maximum;
			
			if(isChange)
			{
				m_value = newValue;
				m_minimum = newMin;
				m_maximum = newMax;
				
				fireStateChange();
			}
		}
		
		public function addStateListener(listener:Function, priority:int=0, useWeakReference:Boolean=false):void
		{
			addEventListener(ComponentEvent.STATE_CHANGED, listener, false, priority, useWeakReference);
		}
		
		public function removeStateListener(listener:Function):void
		{
			removeEventListener(ComponentEvent.STATE_CHANGED, listener);
		}
		
		protected function fireStateChange():void
		{
			dispatchEvent(new ComponentEvent(ComponentEvent.STATE_CHANGED));
		}
		
		override public function toString():String
		{
			var modelString:String = "value=" + getValue() + ", " + "min=" + getMinimum() + ", " + "max=" + getMaximum();
			
			return "DefaultBoundedRangeModel" + "[" + modelString + "]";
		}
	}
}