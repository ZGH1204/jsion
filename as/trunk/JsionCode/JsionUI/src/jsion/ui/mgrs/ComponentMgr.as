package jsion.ui.mgrs
{
	import flash.events.Event;
	
	import jsion.ui.Component;
	
	import jsion.utils.InstanceUtil;

	public class ComponentMgr
	{
		private var invalidates:HashSet = new HashSet();
		
		private var components:HashMap = new HashMap();
		
		private var hasInvalidates:Boolean;
		
		private var m_rendering:Boolean;
		private var m_waiteRender:Boolean;
		
		public function registe(component:Component):void
		{
			if(component == null) return;

			if(components.containsKey(component.id))
			{
				throw new Error("组件ID不能重复.");
				return;
			}

			components.put(component.id, component);
		}

		public function unregiste(id:String):void
		{
			var comp:Component = components.remove(id);
			if(comp) invalidates.remove(comp);
		}

		public static function get Instance():ComponentMgr
		{
			return InstanceUtil.createSingletion(ComponentMgr) as ComponentMgr;
		}
		
		public function addInvalidate(component:Component):void
		{
			invalidates.add(component);
			
			hasInvalidates = true;
			
			renderLater();
		}
		
		private function renderLater():void
		{
			if(m_waiteRender == false && m_rendering == false)
			{
				StageRef.addEventListener(Event.RENDER, __renderHandler);
				
				StageRef.invalidate();
				
				m_waiteRender = true;
			}
		}
		
		private function __renderHandler(e:Event):void
		{
			StageRef.removeEventListener(Event.RENDER, __renderHandler);
			
			m_rendering = true;
			
			while(hasInvalidates)
			{
				var list:Array = invalidates.toArray();
				invalidates.clear();
				
				hasInvalidates = false;
				
				for each(var component:Component in list)
				{
					component.paint();
				}
			}
			
			m_waiteRender = false;
			
			m_rendering = false;
		}
	}
}

