package jsion.ui.components.sliders
{
	import jsion.ui.Component;
	import jsion.ui.DefaultBoundedRangeModel;
	import jsion.ui.DefaultConfigKeys;
	import jsion.ui.IBoundedRangeModel;
	import jsion.ui.UIConstants;
	import jsion.ui.events.ComponentEvent;
	import jsion.utils.DisposeUtil;
	
	public class AbstractSlider extends Component
	{
		/** 
		 * Horizontal orientation. Used for scrollbars and sliders.
		 */
		public static const HORIZONTAL:int = UIConstants.HORIZONTAL;
		/** 
		 * Vertical orientation. Used for scrollbars and sliders.
		 */
		public static const VERTICAL:int   = UIConstants.VERTICAL;
		
		protected var m_dir:int;
		
		protected var m_model:IBoundedRangeModel;
		
		protected var m_hThumbHGap:int;
		protected var m_hThumbVGap:int;
		
		protected var m_vThumbHGap:int;
		protected var m_vThumbVGap:int;
		
		protected var m_needChangeThumb:Boolean;
		
		protected var m_autoScrollStep:Number = 1;
		
		
		public function AbstractSlider(dir:int = HORIZONTAL, prefix:String=null, id:String=null)
		{
			m_dir = dir;
			
			model = new DefaultBoundedRangeModel();
			
			super(prefix, id);
			
			DisposeUtil.free(mask);
			mask = null;
		}
		
		override public function getUIDefaultBasicClass():Class
		{
			return BasicSliderUI;
		}
		
		override protected function getUIDefaultClassID():String
		{
			return DefaultConfigKeys.SLIDER_UI;
		}

		public function get dir():int
		{
			return m_dir;
		}
		
		public function get hThumbHGap():int
		{
			return m_hThumbHGap;
		}
		
		public function set hThumbHGap(value:int):void
		{
			if(m_hThumbHGap != value)
			{
				m_hThumbHGap = value;
				
				invalidate();
			}
		}
		
		public function get hThumbVGap():int
		{
			return m_hThumbVGap;
		}
		
		public function set hThumbVGap(value:int):void
		{
			if(m_hThumbVGap != value)
			{
				m_hThumbVGap = value;
				
				invalidate();
			}
		}
		
		public function get vThumbHGap():int
		{
			return m_vThumbHGap;
		}
		
		public function set vThumbHGap(value:int):void
		{
			if(m_vThumbHGap != value)
			{
				m_vThumbHGap = value;
				
				invalidate();
			}
		}
		
		public function get vThumbVGap():int
		{
			return m_vThumbVGap;
		}
		
		public function set vThumbVGap(value:int):void
		{
			if(m_vThumbVGap != value)
			{
				m_vThumbVGap = value;
				
				invalidate();
			}
		}
		
		public function get model():IBoundedRangeModel
		{
			return m_model;
		}
		
		public function set model(value:IBoundedRangeModel):void
		{
			if(m_model != value)
			{
				if(m_model) m_model.removeStateListener(__modelStateListener);
				
				m_model = value;
				
				if(m_model) m_model.addStateListener(__modelStateListener);
				
				invalidate();
			}
		}
		
		public function get minimum():int
		{
			return model.getMinimum();
		}
		
		public function set minimum(value:int):void
		{
			model.setMinimum(value);
		}
		
		public function get maximum():int
		{
			return model.getMaximum();
		}
		
		public function set maximum(value:int):void
		{
			model.setMaximum(value);
		}
		
		public function get value():Number
		{
			return model.getValue();
		}
		
		public function set value(val:Number):void
		{
			m_needChangeThumb = true;
			
			model.setValue(val);
			
			m_needChangeThumb = false;
		}
		
		public function get autoScrollStep():Number
		{
			return m_autoScrollStep;
		}
		
		public function set autoScrollStep(value:Number):void
		{
			if(value <= 0) return;
			
			m_autoScrollStep = value;
		}
		
		public function scroll(addedValue:Number):void
		{
			if(value >= maximum && addedValue >= 0) return;
			if(value <= minimum && addedValue <= 0) return;
			
			value += addedValue;
		}
		
		internal function setValueUnChangeThumb(val:Number):void
		{
			model.setValue(val);
		}
		
		public function get needChangeThumb():Boolean
		{
			return m_needChangeThumb;
		}
		
		override public function set width(value:Number):void
		{
			if(dir == VERTICAL) return;
			
			super.width = value;
		}
		
		override public function set height(value:Number):void
		{
			if(dir == HORIZONTAL) return;
			
			super.height = value;
		}
		
		public function addStateListener(listener:Function, priority:int = 0, useWeakReference:Boolean = false):void
		{
			addEventListener(ComponentEvent.STATE_CHANGED, listener, false, priority, useWeakReference);
		}
		
		public function removeStateListener(listener:Function):void
		{
			removeEventListener(ComponentEvent.STATE_CHANGED, listener);
		}
		
		protected function __modelStateListener(event:ComponentEvent):void
		{
			dispatchEvent(new ComponentEvent(ComponentEvent.STATE_CHANGED));
		}
		
		override public function dispose():void
		{
			if(m_model) m_model.removeStateListener(__modelStateListener);
			
			DisposeUtil.free(m_model);
			m_model = null;
			
			super.dispose();
		}
	}
}