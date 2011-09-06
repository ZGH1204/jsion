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
	}
}