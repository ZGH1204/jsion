package jsion.display
{
	import flash.display.DisplayObject;
	
	import jsion.comps.Component;
	import jsion.utils.DisposeUtil;
	
	public class Image extends Component
	{
		private var m_display:DisplayObject;
		
		public function Image()
		{
			super();
			
			mouseEnabled = false;
			mouseChildren = false;
		}
		
		protected function get display():DisplayObject
		{
			return m_display;
		}
		
		override protected function addChildren():void
		{
			//super.addChildren();
			
			if(m_display) addChild(m_display);
		}
		
		/**
		 * 设置显示对象 并返回旧的显示对象
		 * 此方法会重置宽度和高度
		 */		
		public function setDisplay(disObj:DisplayObject):DisplayObject
		{
			var temp:DisplayObject = null;
			
			if(disObj)
			{
				temp = m_display;
				
				if(m_display && m_display.parent) m_display.parent.removeChild(m_display);
				
				m_display = disObj;
				
				m_width = m_display.width;
				m_height = m_display.height;
				
				invalidate();
			}
			
			return null;
		}
		
		override protected function onProppertiesUpdate():void
		{
			if(m_changeProperties.containsKey(WIDTH) || m_changeProperties.containsKey(HEIGHT))
			{
				if(m_display)
				{
					m_display.width = m_width;
					m_display.height = m_height;
				}
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			DisposeUtil.free(m_display);
			m_display = null;
		}
	}
}