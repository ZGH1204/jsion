package jsion.components
{
	import jsion.IDispose;
	import jsion.utils.ArrayUtil;

	public class JToggleButtonGroup implements IDispose
	{
		private var m_list:Array;
		
		private var m_selected:JToggleButton;
		
		private var m_selectedList:Array;
		
		private var m_enableMultiple:Boolean;
		
		public function JToggleButtonGroup()
		{
			m_list = [];
			
			m_selectedList = [];
			
			m_enableMultiple = false;
		}
		
		public function add(groupButton:JToggleButton):void
		{
			if(ArrayUtil.push(m_list, groupButton) != -1)
			{
				groupButton.group = this;
				groupButton.selected = false;
			}
		}
		
		public function get enableMultiple():Boolean
		{
			return m_enableMultiple;
		}
		
		public function set enableMultiple(value:Boolean):void
		{
			if(m_enableMultiple == value) return;
			
			m_enableMultiple = value;
			
			if(m_enableMultiple == false)
			{
				while(m_selectedList && m_selectedList.length > 0)
				{
					var item:JToggleButton = m_selectedList.pop() as JToggleButton;
					
					item.selected = false;
				}
				
				ArrayUtil.removeAll(m_selectedList);
				
				m_selected = null;
			}
			else
			{
				if(m_selected)
				{
					ArrayUtil.push(m_selectedList, m_selected);
					m_selected.selected = true;
				}
			}
		}
		
		public function get selectedList():Array
		{
			return m_selectedList;
		}
		
		public function get selected():JToggleButton
		{
			return m_selected;
		}
		
		public function set selected(value:JToggleButton):void
		{
			if(m_selected == value && m_enableMultiple == false)
			{
				if(m_selected) m_selected.selected = true;
				
				return;
			}
			
			if(m_selected && m_enableMultiple == false) m_selected.selected = false;
			
			if(m_enableMultiple && value != null)
			{
				value.selected = !value.selected;
				
				if(value.selected)
				{
					ArrayUtil.push(m_selectedList, value);
				}
				else
				{
					ArrayUtil.remove(m_selectedList, value);
				}
			}
			
			m_selected = value;
			
			if(m_selected && m_enableMultiple == false) m_selected.selected = true;
		}
		
		public function dispose():void
		{
			ArrayUtil.removeAll(m_list);
			m_list = null;
			
			ArrayUtil.removeAll(m_selectedList);
			m_selectedList = null;
			
			m_selected = null;
		}
	}
}