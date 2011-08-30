package jcomponent.org.coms.buttons
{
	import flash.display.DisplayObject;
	
	import jcomponent.org.basic.DefaultConfigKeys;
	import jcomponent.org.basic.UIConstants;

	public class CheckBox extends ToggleButton
	{
		public static const LEFT:int = UIConstants.LEFT;
		
		public static const CENTER:int = UIConstants.CENTER;
		
		public static const RIGHT:int = UIConstants.RIGHT;
		
		public static const TOP:int = UIConstants.TOP;
		
		public static const MIDDLE:int = UIConstants.MIDDLE;
		
		public static const BOTTOM:int = UIConstants.BOTTOM;
		
		
		private var m_textHGap:int = 0;
		private var m_textVGap:int = 0;
		
		private var m_boxHGap:int = 0;
		private var m_boxVGap:int = 0;
		
		private var m_boxDir:int;
		
		public function CheckBox(text:String = null, textDir:int = LEFT, id:String = null)
		{
			super(text, id);
			
			m_boxDir = textDir;
			
			m_horizontalTextAlginment = LEFT;
			
			//model = new ToggleButtonModel();
		}
		
		override public function getUIDefaultBasicClass():Class
		{
			return CheckBoxUI;
		}
		
		override protected function getUIDefaultClassID():String
		{
			return DefaultConfigKeys.CHECK_BOX_UI;
		}

		public function get textHGap():int
		{
			return m_textHGap;
		}

		public function set textHGap(value:int):void
		{
			if(m_textHGap != value)
			{
				m_textHGap = value;
				
				invalidate();
			}
		}

		public function get boxHGap():int
		{
			return m_boxHGap;
		}

		public function set boxHGap(value:int):void
		{
			if(m_boxHGap != value)
			{
				m_boxHGap = value;
				
				invalidate();
			}
		}
		
		public function get boxDir():int
		{
			return m_boxDir;
		}

		public function get textVGap():int
		{
			return m_textVGap;
		}

		public function set textVGap(value:int):void
		{
			m_textVGap = value;
		}

		public function get boxVGap():int
		{
			return m_boxVGap;
		}

		public function set boxVGap(value:int):void
		{
			m_boxVGap = value;
		}
		
//		override public function set mask(value:DisplayObject):void
//		{
//			value.visible = false;
//		}
	}
}