package jsion.comps
{
	import jsion.IDispose;
	import jsion.events.JsionEventDispatcher;
	import jsion.events.StateEvent;
	
	/**
	 * 状态改变事件，在 enabled、rollOver、armed、pressed 任一属性变更时派发。
	 */	
	[Event(name="stateChanged", type="jsion.events.StateEvent")]
	/**
	 * 选择状态改变事件，在 selected 属性变更时派发。
	 */	
	[Event(name="selectionChanged", type="jsion.events.StateEvent")]
	/**
	 * 状态模型
	 * @author Jsion
	 * 
	 */	
	public class StateModel extends JsionEventDispatcher implements IDispose
	{
		/** @private */
		protected var m_enabled:Boolean;
		/** @private */
		protected var m_rollOver:Boolean;
		/** @private */
		protected var m_armed:Boolean;
		/** @private */
		protected var m_pressed:Boolean;
		/** @private */
		protected var m_selected:Boolean;
		
		public function StateModel()
		{
			m_enabled = true;
			m_rollOver = false;
			m_armed = false;
			m_pressed = false;
			m_selected = false;
		}
		
		
		/**
		 * 获取或设置是否可用
		 */		
		public function get enabled():Boolean
		{
			return m_enabled;
		}
		
		/** @private */
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
		
		/**
		 * 获取或设置鼠标是否经过
		 */		
		public function get rollOver():Boolean
		{
			return m_rollOver;
		}
		
		/** @private */
		public function set rollOver(value:Boolean):void
		{
			if(m_rollOver == value || enabled == false) return;
			
			m_rollOver = value;
			
			fireStateChanged();
		}
		
		/**
		 * 获取或设置鼠标是否按住
		 */		
		public function get armed():Boolean
		{
			return m_armed;
		}
		
		/** @private */
		public function set armed(value:Boolean):void
		{
			if(m_armed == value || enabled == false) return;
			m_armed = value;
			fireStateChanged();
		}
		
		/**
		 * 获取或设置鼠标是否按下
		 */		
		public function get pressed():Boolean
		{
			return m_pressed;
		}
		
		/** @private */
		public function set pressed(value:Boolean):void
		{
			if(m_pressed == value || enabled == false) return;
			
			m_pressed = value;
			
			fireStateChanged();
		}
		
		/**
		 * 获取或设置是否选中
		 */		
		public function get selected():Boolean
		{
			return m_selected;
		}
		
		/** @private */
		public function set selected(value:Boolean):void
		{
			if(m_selected == value) return;
			
			m_selected = value;
			
			fireStateChanged();
			
			fireSelectionChanged();
		}
		
		/**
		 * 派发 StateEvent.STATE_CHANGED 事件
		 */		
		protected function fireStateChanged():void
		{
			dispatchEvent(new StateEvent(StateEvent.STATE_CHANGED));
		}
		
		/**
		 * 派发 StateEvent.SELECTION_CHANGED 事件
		 */		
		protected function fireSelectionChanged():void
		{
			dispatchEvent(new StateEvent(StateEvent.SELECTION_CHANGED));
		}
	}
}