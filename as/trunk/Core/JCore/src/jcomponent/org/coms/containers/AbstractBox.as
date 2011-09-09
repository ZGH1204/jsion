package jcomponent.org.coms.containers
{
	import jcomponent.org.basic.Container;
	import jcomponent.org.basic.UIConstants;
	
	public class AbstractBox extends Container
	{
		public static const TOP:int = UIConstants.TOP;
		public static const MIDDLER:int = UIConstants.MIDDLE;
		public static const BOTTOM:int = UIConstants.BOTTOM;
		
		public static const LEFT:int = UIConstants.LEFT;
		public static const CENTER:int = UIConstants.CENTER;
		public static const RIGHT:int = UIConstants.RIGHT;
		
		protected var m_hAlign:int;
		
		protected var m_vAlign:int;
		
		protected var m_gap:int;
		
		public function AbstractBox(prefix:String=null, id:String=null)
		{
			m_hAlign = LEFT;
			m_vAlign = TOP;
			
			super(prefix, id);
		}
		
		public function get hAlign():int
		{
			return m_hAlign;
		}
		
		public function set hAlign(value:int):void
		{
			if(m_hAlign != value)
			{
				m_hAlign = value;
				
				invalidate();
			}
		}
		
		public function get vAlign():int
		{
			return m_vAlign;
		}
		
		public function set vAlign(value:int):void
		{
			if(m_vAlign != value)
			{
				m_vAlign = value;
				
				invalidate();
			}
		}
		
		public function get gap():int
		{
			return m_gap;
		}
		
		public function set gap(value:int):void
		{
			if(m_gap != value)
			{
				m_gap = value;
				
				invalidate();
			}
		}
	}
}