package jsion.components
{
	import jsion.IDispose;
	import jsion.utils.ArrayUtil;

	public class ButtonGroup implements IDispose
	{
		private var m_list:Array;
		
		private var m_selected:RadioButton;
		
		public function ButtonGroup()
		{
		}
		
		public function add(radioButton:RadioButton):void
		{
			if(ArrayUtil.push(m_list, radioButton) != -1)
			{
				radioButton.group = this;
				radioButton.selected = false;
			}
		}
		
		public function get selected():RadioButton
		{
			return m_selected;
		}
		
		public function set selected(value:RadioButton):void
		{
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