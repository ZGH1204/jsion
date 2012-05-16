package jsion.comps
{
	import jsion.HashMap;
	import jsion.utils.DisposeUtil;
	import jsion.utils.StringUtil;

	public class Component extends JsionSprite
	{
		private var m_changeNum:int;
		
		private var m_changeProperties:HashMap;
		
		public function Component()
		{
			super();
		}
		
		public function beginChanges():void
		{
			m_changeNum++;
		}
		
		public function commitChanges():void
		{
			m_changeNum--;
			
			invalidate();
		}
		
		protected function invalidate():void
		{
			if(m_changeNum <= 0)
			{
				m_changeNum = 0;
				
				apply();
			}
		}
		
		protected function apply():void
		{
			onProppertiesUpdate();
			
			addChildren();
			
			m_changeProperties.removeAll();
		}
		
		protected function onPropertiesChanged(propName:String = null):void
		{
			if(StringUtil.isNullOrEmpty(propName) == false)
			{
				m_changeProperties.put(propName, true);
			}
			
			invalidate();
		}
		
		protected function onProppertiesUpdate():void
		{
			
		}
		
		protected function addChildren():void
		{
			
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			DisposeUtil.free(m_changeProperties);
			m_changeProperties = null;
		}
	}
}