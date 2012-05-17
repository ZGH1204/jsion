package jsion.comps
{
	import jsion.HashMap;
	import jsion.events.DisplayEvent;
	import jsion.utils.DisposeUtil;
	import jsion.utils.StringUtil;

	public class Component extends JsionSprite
	{
		public static const WIDTH:String = "width";
		public static const HEIGHT:String = "height";
		
		private var m_changeNum:int;
		
		protected var m_changeProperties:HashMap;
		
		protected var m_width:int;
		
		protected var m_height:int;
		
		public function Component()
		{
			super();
		}
		
		override public function get width():Number
		{
			return m_width;
		}
		
		override public function set width(value:Number):void
		{
			if(m_width != value)
			{
				m_width = value;
				
				onPropertiesChanged(WIDTH);
			}
		}
		
		override public function get height():Number
		{
			return m_height;
		}
		
		override public function set height(value:Number):void
		{
			if(m_height != value)
			{
				m_height = value;
				
				onPropertiesChanged(HEIGHT);
			}
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
			
			dispatchEvent(new DisplayEvent(DisplayEvent.PROPERTIES_CHANGED, m_changeProperties));
			
			m_changeProperties.removeAll();
		}
		
		protected function onPropertiesChanged(propName:String = null):void
		{
//			if(StringUtil.isNullOrEmpty(propName) == false)
//			{
//				m_changeProperties.put(propName, true);
//			}
			
			m_changeProperties.put(propName, true);
			
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