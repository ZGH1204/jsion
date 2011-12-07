package jsion.ui.components.labels
{
	import jsion.*;
	import jsion.ui.Component;
	import jsion.ui.DefaultConfigKeys;
	import jsion.ui.UIConstants;
	
	public class Label extends Component
	{
		public static const LEFT:int = UIConstants.LEFT;
		
		public static const CENTER:int = UIConstants.CENTER;
		
		public static const RIGHT:int = UIConstants.RIGHT;
		
		public static const TOP:int = UIConstants.TOP;
		
		public static const MIDDLE:int = UIConstants.MIDDLE;
		
		public static const BOTTOM:int = UIConstants.BOTTOM;
		
		private var m_text:String;
		
		private var m_verticalTextAlginment:int;
		private var m_horizontalTextAlginment:int;
		
		public function Label(text:String = null, id:String = null)
		{
			super(null, id);
			
			m_text = text;
			m_verticalTextAlginment = MIDDLE;
			m_horizontalTextAlginment = CENTER;
		}

		public function get text():String
		{
			return m_text;
		}

		public function set text(value:String):void
		{
			if(m_text != value)
			{
				m_text = value;
				
				if(m_text == null) m_text = "";
				
				invalidate();
			}
		}

		public function get verticalTextAlginment():int
		{
			return m_verticalTextAlginment;
		}

		public function set verticalTextAlginment(value:int):void
		{
			if(m_verticalTextAlginment != value)
			{
				m_verticalTextAlginment = value;
				
				invalidate();
			}
		}

		public function get horizontalTextAlginment():int
		{
			return m_horizontalTextAlginment;
		}

		public function set horizontalTextAlginment(value:int):void
		{
			if(m_horizontalTextAlginment != value)
			{
				m_horizontalTextAlginment = value;
				
				invalidate();
			}
		}

		override public function setSizeWH(w:int, h:int):void
		{
			var min:IntDimension = getMinimumSize();
			
			if(w < min.width) w = min.width;
			if(h < min.height) h = min.height;
			
			super.setSizeWH(w, h);
		}
		
		override public function getUIDefaultBasicClass():Class
		{
			return BasicLabelUI;
		}
		
		override protected function getUIDefaultClassID():String
		{
			return DefaultConfigKeys.LABEL_UI;
		}
	}
}