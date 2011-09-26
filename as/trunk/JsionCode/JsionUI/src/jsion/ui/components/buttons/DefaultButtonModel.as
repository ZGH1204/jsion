package jsion.ui.components.buttons
{
	import flash.events.EventDispatcher;
	
	import jsion.ui.events.ButtonEvent;

	public class DefaultButtonModel extends EventDispatcher implements IButtonModel, IDispose
	{
		protected var m_enabled:Boolean;
		protected var m_rollOver:Boolean;
		protected var m_armed:Boolean;
		protected var m_pressed:Boolean;
		protected var m_selected:Boolean;
		
		private var m_group:ButtonGroup;
		
		public function DefaultButtonModel()
		{
			m_enabled = true;
			m_rollOver = false;
			m_armed = false;
			m_pressed = false;
			m_selected = false;
		}

		public function get enabled():Boolean
		{
			return m_enabled;
		}

		public function set enabled(value:Boolean):void
		{
			if(m_enabled == value) return;
			
			m_enabled = value;
			
			if(m_enabled == false)
			{
				m_pressed = false;
				m_armed = false;
			}
			
			fireStateChanged();
		}

		public function get rollOver():Boolean
		{
			return m_rollOver;
		}

		public function set rollOver(value:Boolean):void
		{
			if(m_rollOver == value || enabled == false) return;
			
			m_rollOver = value;
			
			fireStateChanged();
		}

		public function get armed():Boolean
		{
			return m_armed;
		}

		public function set armed(value:Boolean):void
		{
			if(m_armed == value || enabled == false) return;
			m_armed = value;
			fireStateChanged();
		}

		public function get pressed():Boolean
		{
			return m_pressed;
		}

		public function set pressed(value:Boolean):void
		{
			if(m_pressed == value || enabled == false) return;
			
			m_pressed = value;
			
			fireStateChanged();
			
			if(m_pressed == false && armed) fireActionEvent();
		}

		public function get selected():Boolean
		{
			return m_selected;
		}

		public function set selected(value:Boolean):void
		{
			if(m_selected == value) return;
			
			m_selected = value;
			
			fireStateChanged();
			
			fireSelectionChanged();
		}
		
		public function get group():ButtonGroup
		{
			return m_group;
		}
		
		public function set group(value:ButtonGroup):void
		{
			m_group = value;
		}

		public function addActionListener(listener:Function, priority:int=0, useWeakReference:Boolean=false):void
		{
			addEventListener(ButtonEvent.ACTION, listener, false, priority);
		}
		
		public function removeActionListener(listener:Function):void
		{
			removeEventListener(ButtonEvent.ACTION, listener);
		}
		
		public function addSelectionListener(listener:Function, priority:int=0, useWeakReference:Boolean=false):void
		{
			addEventListener(ButtonEvent.SELECTION_CHANGED, listener, false, priority);
		}
		
		public function removeSelectionListener(listener:Function):void
		{
			removeEventListener(ButtonEvent.SELECTION_CHANGED, listener);
		}
		
		public function addStateListener(listener:Function, priority:int=0, useWeakReference:Boolean=false):void
		{
			addEventListener(ButtonEvent.STATE_CHANGED, listener, false, priority);
		}
		
		public function removeStateListener(listener:Function):void
		{
			removeEventListener(ButtonEvent.STATE_CHANGED, listener);
		}

		protected function fireActionEvent():void
		{
			dispatchEvent(new ButtonEvent(ButtonEvent.ACTION));
		}
		
		protected function fireStateChanged():void
		{
			dispatchEvent(new ButtonEvent(ButtonEvent.STATE_CHANGED));
		}
		
		protected function fireSelectionChanged():void
		{
			dispatchEvent(new ButtonEvent(ButtonEvent.SELECTION_CHANGED));
		}
		
		public function dispose():void
		{
			m_group = null;
		}
	}
}