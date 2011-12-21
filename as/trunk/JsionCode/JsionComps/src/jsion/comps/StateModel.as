package jsion.comps
{
	import flash.events.EventDispatcher;
	
	import jsion.IDispose;
	import jsion.comps.events.StateEvent;
	
	[Event(name="stateChanged", type="jsion.comps.events.StateEvent")]
	[Event(name="selectionChanged", type="jsion.comps.events.StateEvent")]
	public class StateModel extends EventDispatcher implements IDispose
	{
		protected var m_enabled:Boolean;
		protected var m_rollOver:Boolean;
		protected var m_armed:Boolean;
		protected var m_pressed:Boolean;
//		protected var m_selected:Boolean;
		
		public function StateModel()
		{
			m_enabled = true;
			m_rollOver = false;
			m_armed = false;
			m_pressed = false;
//			m_selected = false;
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
		}
		
//		public function get selected():Boolean
//		{
//			return m_selected;
//		}
//		
//		public function set selected(value:Boolean):void
//		{
//			if(m_selected == value) return;
//			
//			m_selected = value;
//			
//			fireStateChanged();
//			
//			fireSelectionChanged();
//		}
		
		
		
		
		protected function fireStateChanged():void
		{
			dispatchEvent(new StateEvent(StateEvent.STATE_CHANGED));
		}
		
		protected function fireSelectionChanged():void
		{
			dispatchEvent(new StateEvent(StateEvent.SELECTION_CHANGED));
		}
		
		public function dispose():void
		{
			
		}
	}
}