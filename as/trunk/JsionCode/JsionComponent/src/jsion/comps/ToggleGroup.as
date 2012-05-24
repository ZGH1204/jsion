package jsion.comps
{
	import jsion.IDispose;
	import jsion.display.ToggleButton;
	import jsion.utils.ArrayUtil;
	
	/**
	 * ToggleButton编组。支持多选。
	 * @author Jsion
	 * 
	 */	
	public class ToggleGroup implements IDispose
	{
		private var m_list:Array;
		
		private var m_selectedList:Array;
		
		private var m_selected:ToggleButton;
		
		private var m_autoSelected:Boolean;
		
		private var m_multiple:Boolean;
		
		public function ToggleGroup(multiple:Boolean = false)
		{
			m_multiple = multiple
			
			m_list = [];
			
			if(m_multiple) m_selectedList = [];
			
			m_autoSelected = true;
		}
		
		/**
		 * 是否允许多选。
		 * <ul>
		 * <li>当允许多选时，autoSelected 自动选中属性无效，selected 选中对象无效 selectedList生效;</li>
		 * <li>当不允许多选时，autoSelected 自动选中属性有效，selected 选中对象生效 selectedList无效;</li>
		 * </ul>
		 */		
		public function get multiple():Boolean
		{
			return m_multiple;
		}
		
		/**
		 * 获取或设置是否自动选中
		 */		
		public function get autoSelected():Boolean
		{
			return m_autoSelected;
		}
		
		/**
		 * @private
		 */		
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
		
		/**
		 * 获取或设置选中对象。
		 * 当允许多选时，返回 null，请使用 selectedList 属性获取所有选中对象，setMultipleSelected() 方法设置选中/取消选中对象。
		 */		
		public function get selected():ToggleButton
		{
			if(m_multiple) return null;
			return m_selected;
		}
		
		/**
		 * @private
		 */		
		public function set selected(value:ToggleButton):void
		{
			if(m_multiple) return;
			
			if(m_selected != value)
			{
				if(m_selected) m_selected.selected = false;
				
				m_selected = value;
				
				if(m_selected) m_selected.selected = true;
			}
		}
		
		/**
		 * 当允许多选时获取当前所有选中/取消选中的对象，否则为 null 。
		 */		
		public function get selectedList():Array
		{
			return m_selectedList;
		}
		
		/**
		 * 当允许多选时使用此方法设置选中对象，否则使用 selected 属性。
		 */		
		public function setMultipleSelected(button:ToggleButton):void
		{
			if(m_multiple)
			{
				if(button.selected)
				{
					button.selected = false;
					ArrayUtil.remove(m_selectedList, button);
				}
				else
				{
					button.selected = true;
					ArrayUtil.push(m_selectedList, button);
				}
			}
		}
		
		/**
		 * 将指定的ToggleButton对象加入编组
		 * @param btn 要加入的ToggleButton对象
		 * 
		 */		
		public function add(button:ToggleButton):void
		{
			if(button == null) return;
			
			button.group = this;
			ArrayUtil.push(m_list, button);
			
			if(m_multiple)
			{
				if(button.selected) ArrayUtil.push(m_selectedList, button);
			}
			else
			{
				if(m_selected == null && m_autoSelected)
				{
					m_selected = button;
					m_selected.selected = true;
				}
				else
				{
					button.selected = false;
				}
			}
		}
		
		/**
		 * 将指定的对象从编组中移除。当不允许多选时，如果移除的对象为当前选中对象则根据 autoSelected 属性设置选中第一个对象。
		 * @param btn 要移除的对象
		 * 
		 */		
		public function remove(button:ToggleButton):void
		{
			if(button == null) return;
			
			if(m_selected == button)
			{
				m_selected = null;
				
				if(m_autoSelected && m_list.length > 0)
				{
					selected = m_list[0];
				}
			}
			
			ArrayUtil.remove(m_list, button);
			
			ArrayUtil.remove(m_selectedList, button);
		}
		
		/**
		 * 释放资源
		 */		
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