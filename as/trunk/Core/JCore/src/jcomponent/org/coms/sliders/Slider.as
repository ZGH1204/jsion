package jcomponent.org.coms.sliders
{
	import jcomponent.org.basic.Component;
	import jcomponent.org.basic.DefaultBoundedRangeModel;
	import jcomponent.org.basic.DefaultConfigKeys;
	import jcomponent.org.basic.IBoundedRangeModel;
	import jcomponent.org.basic.UIConstants;
	import jcomponent.org.events.ComponentEvent;
	
	public class Slider extends Component
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
		
		
		protected var m_hDirHGap:int;
		protected var m_hDirVGap:int;
		
		protected var m_vDirHGap:int;
		protected var m_vDirVGap:int;
		
		protected var m_hThumbHGap:int;
		protected var m_hThumbVGap:int;
		
		protected var m_vThumbHGap:int;
		protected var m_vThumbVGap:int;
		
		protected var m_model:IBoundedRangeModel;
		
		protected var m_margin:int = int.MIN_VALUE;
		
		protected var m_needChangeThumb:Boolean;
		
		
		public function Slider(dir:int = HORIZONTAL, prefix:String=null, id:String=null)
		{
			m_dir = dir;
			
			model = new DefaultBoundedRangeModel();
			
			super(prefix, id);
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
		
		public function get hDirHGap():int
		{
			return m_hDirHGap;
		}
		
		public function set hDirHGap(value:int):void
		{
			if(m_hDirHGap != value)
			{
				m_hDirHGap = value;
				
				invalidate();
			}
		}
		
		public function get hDirVGap():int
		{
			return m_hDirVGap;
		}
		
		public function set hDirVGap(value:int):void
		{
			if(m_hDirVGap != value)
			{
				m_hDirVGap = value;
				
				invalidate();
			}
		}
		
		public function get vDirHGap():int
		{
			return m_vDirHGap;
		}
		
		public function set vDirHGap(value:int):void
		{
			if(m_vDirHGap != value)
			{
				m_vDirHGap = value;
				
				invalidate();
			}
		}
		
		public function get vDirVGap():int
		{
			return m_vDirVGap;
		}
		
		public function set vDirVGap(value:int):void
		{
			if(m_vDirVGap != value)
			{
				m_vDirVGap = value;
				
				invalidate();
			}
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
		
		public function get margin():int
		{
			return m_margin;
		}
		
		public function set margin(value:int):void
		{
			if(m_margin != value)
			{
				m_margin = value;
				
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
		}
		
		internal function setValueUnChangeThumb(val:Number):void
		{
			model.setValue(val);
			
			//m_needChangeThumb = false;
		}
		
		public function get needChangeThumb():Boolean
		{
			return m_needChangeThumb;
		}
		
		public function set needChangeThumb(value:Boolean):void
		{
			m_needChangeThumb = value;
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
	}
}