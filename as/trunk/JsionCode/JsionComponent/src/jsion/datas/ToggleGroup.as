package jsion.datas
{
	import jsion.IDispose;
	import jsion.display.ToggleButton;
	import jsion.utils.ArrayUtil;
	
	public class ToggleGroup implements IDispose
	{
		private var m_list:Array;
		
		private var m_selected:ToggleButton;
		
		private var m_autoSelected:Boolean;
		
		public function ToggleGroup()
		{
			m_list = [];
			
			m_autoSelected = true;
		}
		
		public function get autoSelected():Boolean
		{
			return m_autoSelected;
		}
		
		public function set autoSelected(value:Boolean):void
		{
			if(m_autoSelected != value)
			{
				m_autoSelected = value;
				
				if(m_autoSelected && m_selected == null && m_list.length > 0)
				{
					selected = m_list[0];
				}
			}
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
				
				if(m_selected) m_selected.selected = true;
			}
		}
		
		public function add(btn:ToggleButton):void
		{
			if(btn == null) return;
			
			ArrayUtil.push(m_list, btn);
			
			if(m_selected == null && m_autoSelected)
			{
				m_selected = btn;
				m_selected.selected = true;
			}
			else
			{
				btn.selected = false;
			}
		}
		
		public function remove(btn:ToggleButton):void
		{
			if(btn == null) return;
			
			if(m_selected == btn)
			{
				m_selected = null;
				
				if(m_autoSelected && m_list.length > 0)
				{
					selected = m_list[0];
				}
			}
			
			ArrayUtil.remove(m_list, btn);
		}
		
		public function dispose():void
		{
			ArrayUtil.removeAll(m_list);
			m_list = null;
		}
	}
}