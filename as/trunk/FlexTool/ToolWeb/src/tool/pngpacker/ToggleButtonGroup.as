package tool.pngpacker
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import jsion.events.JsionEventDispatcher;
	import jsion.utils.ArrayUtil;
	
	import spark.components.ToggleButton;
	
	[Event(name="change", type="flash.events.Event")]
	public class ToggleButtonGroup extends JsionEventDispatcher
	{
		protected var m_list:Array;
		
		protected var m_selected:ToggleButton;
		
		public function ToggleButtonGroup()
		{
			super();
			
			m_list = [];
		}
		
		public function get selected():ToggleButton
		{
			return m_selected;
		}

		public function set selected(value:ToggleButton):void
		{
			if(m_selected != value)
			{
				if(m_selected) m_selected.selected = false;
				
				m_selected = value;
				
				if(m_selected && m_selected.selected == false) m_selected.selected = true;
			}
			
			dispatchEvent(new Event(Event.CHANGE));
		}

		public function addToggle(button:ToggleButton):void
		{
			if(button == null || ArrayUtil.containsValue(m_list, button)) return;
			
			button.addEventListener(Event.CHANGE, __selectedChangedHandler);
		}
		
		public function removeToggle(button:ToggleButton):void
		{
			if(button == null) return;
			
			if(m_selected == button) selected = null;
			
			ArrayUtil.remove(m_list, button);
			
			button.removeEventListener(Event.CHANGE, __selectedChangedHandler);
		}
		
		protected function __selectedChangedHandler(event:Event):void
		{
			// TODO Auto-generated method stub
			var button:ToggleButton = event.currentTarget as ToggleButton;
			
			if(button.selected)
			{
				selected = button;
			}
			else if(selected == button)
			{
				selected = null;
			}
		}
		
		override public function dispose():void
		{
			// TODO Auto Generated method stub
			
			while(m_list && m_list.length > 0)
			{
				var button:ToggleButton = m_list.pop();
				
				button.removeEventListener(Event.CHANGE, __selectedChangedHandler);
			}
			
			m_list = null;
			
			m_selected = null;
			
			super.dispose();
		}
		
	}
}