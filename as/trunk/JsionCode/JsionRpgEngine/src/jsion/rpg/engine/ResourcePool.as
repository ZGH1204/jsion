package jsion.rpg.engine
{
	import jsion.HashMap;
	import jsion.IDispose;
	import jsion.utils.DisposeUtil;

	public class ResourcePool implements IDispose
	{
		private var m_list:HashMap;
		
		public function ResourcePool()
		{
			m_list = new HashMap();
		}
		
		public function hasResource(key:*):Boolean
		{
			return m_list.containsKey(key);
		}
		
		public function addResource(key:*, resource:*):void
		{
			if(hasResource(key)) return;
			
			m_list.put(key, resource);
		}
		
		public function getResource(key:*):*
		{
			return m_list.get(key);
		}
		
		public function updateResource(key:*, resource:*):void
		{
			var old:* = m_list.put(key, resource);
			
			DisposeUtil.free(old);
		}
		
		public function clear():void
		{
			m_list.removeAll();
		}
		
		public function removeResource(key:*):void
		{
			var val:* = m_list.remove(key);
			DisposeUtil.free(val);
		}
		
		public function dispose():void
		{
			DisposeUtil.free(m_list);
			m_list = null;
		}
	}
}