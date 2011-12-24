package jsion.components
{
	import jsion.IDispose;
	import jsion.utils.ArrayUtil;

	public class RadioButtonGroup implements IDispose
	{
		private var m_list:Array;
		
		private var m_selected:RadioButton;
		
		public function RadioButtonGroup()
		{
			m_list = [];
		}
		
		public function add(groupButton:RadioButton):void
		{
			if(ArrayUtil.push(m_list, groupButton) != -1)
			{
				groupButton.group = this;
				groupButton.selected = false;
			}
		}
		
		public function get selected():RadioButton
		{
			return m_selected;
		}
		
		public function set selected(value:RadioButton):void
		{
			if(m_selected == value)
			{
				m_selected.selected = true;
				
				return;
			}
			
			if(m_selected) m_selected.selected = false;
			
			m_selected = value;
			
			if(m_selected) m_selected.selected = true;
		}
		
		public function dispose():void
		{
			ArrayUtil.removeAll(m_list);
			m_list = null;
			
			m_selected = null;
		}
	}
}