package jcomponent.org.coms.buttons
{
	import jcomponent.org.basic.Component;
	import jcomponent.org.basic.UIConstants;
	import jcomponent.org.events.ButtonEvent;
	
	public class AbstractButton extends Component
	{
		public static const LEFT:int = UIConstants.LEFT;
		
		public static const CENTER:int = UIConstants.CENTER;
		
		public static const RIGHT:int = UIConstants.RIGHT;
		
		public static const TOP:int = UIConstants.TOP;
		
		public static const MIDDLE:int = UIConstants.MIDDLE;
		
		public static const BOTTOM:int = UIConstants.BOTTOM;
		
		private var m_model:DefaultButtonModel;
		
		private var m_text:String;
		
		private var m_verticalTextAlginment:int;
		private var m_horizontalTextAlginment:int;
		
		public function AbstractButton(text:String = null, id:String = null)
		{
			super(id);
			
			m_text = text;
			m_verticalTextAlginment = MIDDLE;
			m_horizontalTextAlginment = CENTER;
			
			buttonMode = true;
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

		public function get model():DefaultButtonModel
		{
			return m_model;
		}

		public function set model(value:DefaultButtonModel):void
		{
			if(value == model) return;
			
			var old:DefaultButtonModel = model;
			
			if(old)
			{
				old.removeActionListener(__modelActionListener);
				old.removeSelectionListener(__modelSelectionListener);
				old.removeStateListener(__modelStateListener);
			}
			
			m_model = value;
			
			if(m_model)
			{
				m_model.addActionListener(__modelActionListener);
				m_model.addSelectionListener(__modelSelectionListener);
				m_model.addStateListener(__modelStateListener);
			}
			
			invalidate();
		}
		
		private function __modelActionListener(e:ButtonEvent):void
		{
			dispatchEvent(new ButtonEvent(ButtonEvent.ACTION));
		}
		
		private function __modelStateListener(e:ButtonEvent):void
		{
			invalidate();
			
			dispatchEvent(new ButtonEvent(ButtonEvent.STATE_CHANGED));
		}
		
		private function __modelSelectionListener(e:ButtonEvent):void
		{
			dispatchEvent(new ButtonEvent(ButtonEvent.SELECTION_CHANGED));
		}
	}
}