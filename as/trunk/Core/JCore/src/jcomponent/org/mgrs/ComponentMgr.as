package jcomponent.org.mgrs
{
	import jcomponent.org.basic.Component;
	
	import jutils.org.util.InstanceUtil;

	public class ComponentMgr
	{
		private var components:HashMap = new HashMap();

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
			components.remove(id);
		}

		public static function get Instance():ComponentMgr
		{
			return InstanceUtil.createSingletion(ComponentMgr) as ComponentMgr;
		}
	}
}

