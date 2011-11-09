package jsion.rpg
{
	import jsion.utils.DisposeUtil;

	public class ResourcePool implements IDispose
	{
		protected var m_pool:HashMap;
		
		public function ResourcePool()
		{
			m_pool = new HashMap();
		}
		
		public function hasRes(key:String):Boolean
		{
			return m_pool.containsKey(key);
		}
		
		public function addRes(key:String, obj:*):void
		{
			m_pool.put(key, obj);
		}
		
		public function removeRes(key:String):void
		{
			var obj:* = m_pool.remove(key);
			
			DisposeUtil.free(obj);
		}
		
		public function getRes(key:String):*
		{
			return m_pool.get(key);
		}
		
		public function dispose():void
		{
			DisposeUtil.free(m_pool);
			m_pool = null;
		}
	}
}