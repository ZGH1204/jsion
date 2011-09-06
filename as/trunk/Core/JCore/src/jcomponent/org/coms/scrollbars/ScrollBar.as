package jcomponent.org.coms.scrollbars
{
	import jcomponent.org.basic.Component;
	import jcomponent.org.basic.DefaultConfigKeys;
	import jcomponent.org.basic.UIConstants;
	
	public class ScrollBar extends Component
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
		
		public function ScrollBar(dir:int = VERTICAL, prefix:String=null, id:String=null)
		{
			if(dir == HORIZONTAL)
			{
				m_dir = HORIZONTAL;
			}
			else
			{
				m_dir = VERTICAL;
			}
			
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
	}
}