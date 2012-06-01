package jsion.comps
{
	import jsion.IDispose;
	import jsion.display.ToggleButton;
	import jsion.events.DisplayEvent;
	import jsion.utils.ArrayUtil;
	
	/**
	 * 当允许多选并且选择对象变更时派发，事件数据为当前已选择对象。
	 */	
	[Event(name="selectChanged", type="jsion.events.DisplayEvent")]
	
	/**
	 * 当允许多选并且任一对象状态变更时派发，事件数据为已选择对象列表。
	 */	
	[Event(name="multipleSelectChanged", type="jsion.events.DisplayEvent")]
	/**
	 * ToggleButton编组。支持多选。
	 * @author Jsion
	 */	
	public class ToggleGroup extends JsionEventDispatcher
	{
		private var m_list:Array;
		
		private var m_selectedList:Array;
		
		private var m_selected:ToggleButton;
		
		private var m_selectedIndex:int;
		
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
		
		/** @private */
		public function set selected(value:ToggleButton):void
		{
			if(m_multiple) return;
			
			if(m_selected != value)
			{
				if(m_selected) m_selected.selected = false;
				
				m_selected = value;
				
				if(m_selected) m_selected.selected = true;
				
				m_selectedIndex = m_list.indexOf(m_selected);
			}
			
			if(m_multiple)
			{
				dispatchEvent(new DisplayEvent(DisplayEvent.MULTIPLE_SELECTE_CHANGED, m_selectedList));
			}
			else
			{
				dispatchEvent(new DisplayEvent(DisplayEvent.SELECT_CHANGED, m_selected));
			}
		}
		
		/**
		 * 获取或设置选中对象的子索引位置。
		 * 当允许多选时，返回 -1，请使用 selectedList 属性获取所有选中对象，setMultipleSelected() 方法设置选中/取消选中对象。
		 */		
		public function get selectedIndex():int
		{
			if(m_multiple) return -1;
			return m_selectedIndex;
		}
		
		/** @private */
		public function set selectedIndex(value:int):void
		{
			if(m_multiple) return;
			
			if(value < 0 || value >= m_list.length)
			{
				selected = null;
				
				return;
			}
			
			var toggleBtn:ToggleButton = m_list[value];
			
			selected = toggleBtn;
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
		 * @param button 要选中或取消选中的ToggleButton对象
		 * 
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
		public function addItem(button:ToggleButton):void
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
					selected = button;
				}
				else
				{
					button.selected = false;
				}
			}
		}
		
		/**
		 * 将指定的对象从编组中移除。当不允许多选时，如果移除的对象为当前选中对象则根据 autoSelected 属性设置选中第一个对象。
		 * @param btn 要移除的ToggleButton对象
		 * 
		 */		
		public function remove(button:ToggleButton):void
		{
			if(button == null) return;
			
			if(m_selected == button)
			{
				selected = null;
				
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
		override public function dispose():void
		{
			ArrayUtil.removeAll(m_list);
			m_list = null;
			
			ArrayUtil.removeAll(m_selectedList);
			m_selectedList = null;
			
			m_selected = null;
			
			super.dispose();
		}
	}
}