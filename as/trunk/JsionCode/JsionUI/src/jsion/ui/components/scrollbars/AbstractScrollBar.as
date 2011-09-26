package jsion.ui.components.scrollbars
{
	import jsion.ui.Component;
	import jsion.ui.DefaultBoundedRangeModel;
	import jsion.ui.DefaultConfigKeys;
	import jsion.ui.IBoundedRangeModel;
	import jsion.ui.UIConstants;
	import jsion.ui.events.ComponentEvent;
	
	public class AbstractScrollBar extends Component
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
		
		protected var m_margin:int = int.MIN_VALUE;
		
		protected var m_scrollLength:int;
		
		protected var m_model:IBoundedRangeModel;
		
		protected var m_needChangeThumb:Boolean;
		
		protected var m_autoScrollDelay:int;
		
		protected var m_autoScrollStep:Number = 1;
		
		internal var autoScrollDelayFrameCount:int;
		
		protected var m_thumbMinSize:int;
		
		public function AbstractScrollBar(dir:int = VERTICAL, value:int = 0, min:int = 0, max:int = 100, prefix:String=null, id:String=null)
		{
			if(dir == HORIZONTAL)
			{
				m_dir = HORIZONTAL;
			}
			else
			{
				m_dir = VERTICAL;
			}
			
			model = new DefaultBoundedRangeModel(value, min, max);
			
			autoScrollDelay = 800;
			
			super(prefix, id);
		}
		
		override public function getUIDefaultBasicClass():Class
		{
			return BasicScrollBarUI;
		}
		
		override protected function getUIDefaultClassID():String
		{
			return DefaultConfigKeys.SCROLL_BAR_UI;
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

		public function get scrollLength():int
		{
			return m_scrollLength;
		}

		public function set scrollLength(value:int):void
		{
			if(m_scrollLength != value)
			{
				m_scrollLength = value;
				
				if(m_dir == HORIZONTAL)
				{
					if((m_scrollLength - width) >= 0)
					{
						model.setMaximum(m_scrollLength - width);
					}
					else
					{
						model.setMaximum(0);
					}
				}
				else
				{
					if((m_scrollLength - height) >= 0)
					{
						model.setMaximum(m_scrollLength - height);
					}
					else
					{
						model.setMaximum(0);
					}
				}
				
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
		
		public function scroll(addedValue:Number):void
		{
			if(value >= maximum && addedValue >= 0) return;
			if(value <= minimum && addedValue <= 0) return;
			
			value += addedValue;
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

		public function get autoScrollDelay():int
		{
			return m_autoScrollDelay;
		}

		public function set autoScrollDelay(value:int):void
		{
			if(value <= 0) return;
			
			m_autoScrollDelay = value;
			
			autoScrollDelayFrameCount = 1000 / StageRef.fps;
			
			autoScrollDelayFrameCount = Math.ceil(m_autoScrollDelay / autoScrollDelayFrameCount);
			
			if(autoScrollDelayFrameCount <= 0) autoScrollDelayFrameCount = 2;
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

		public function get thumbMinSize():int
		{
			return m_thumbMinSize;
		}

		public function set thumbMinSize(value:int):void
		{
			if(m_thumbMinSize != value)
			{
				m_thumbMinSize = value;
				
				invalidate();
			}
		}
		
		override public function dispose():void
		{
			if(m_model) m_model.removeStateListener(__modelStateListener);
			
			m_model = null;
			
			super.dispose();
		}
	}
}