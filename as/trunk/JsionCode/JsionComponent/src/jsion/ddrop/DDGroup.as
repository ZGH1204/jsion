package jsion.ddrop
{
	import jsion.IDispose;

	/**
	 * 拖拽组信息
	 * @author Jsion
	 * 
	 */	
	internal class DDGroup implements IDispose
	{
		private var m_group:String;
		
		private var m_elements:Array;
		
		public function DDGroup(group:String)
		{
			super();
			m_group = group;
			
			m_elements = [];
		}
		
		/**
		 * 分组名称
		 */		
		public function get group():String
		{
			return m_group;
		}
		
		/**
		 * 拖拽对象个数
		 */		
		public function get count():int
		{
			if(m_elements == null) return 0;
			return m_elements.length;
		}
		
		/**
		 * 获取指定索引位置的对象
		 * @param index 要获取的索引位置
		 * @return 
		 * 
		 */		
		public function get(index:int):*
		{
			if(index >= m_elements.length) return null;
			
			return m_elements[index];
		}
		
		/**
		 * 获取拖拽组中是否包含指定对象
		 * @param element 指定对象
		 * @return 拖拽组中是否包含指定对象
		 */		
		public function contains(element:*):Boolean
		{
			return m_elements.indexOf(element) >= 0;
		}
		
		/**
		 * 把对拖拽组中的每个对象当做 <code>fn</code> 的第一个参数,并执行 <code>fn</code> 函数
		 * @param fn 对每个对象执行的函数
		 * 
		 */		
		public function each(fn:Function):void
		{
			for each(var val:* in m_elements)
			{
				fn(val);
			}
		}
		
		
		
		/**
		 * 将指定对象插入到指定的索引位置
		 * @param element 要插入的对象
		 * @param index 要插入的索引位置
		 * 
		 */		
		public function add(element:*, index:int = -1):void
		{
			if(index < 0)
				m_elements.push(element);
			else
				m_elements.splice(index, 0, element);
		}
		
		/**
		 * 从拖拽组中删除指定对象
		 * @param element 要删除的指定对象
		 * @return 被删除的对象
		 */		
		public function remove(element:*):*
		{
			var index:int = m_elements.indexOf(element);
			if(index > -1)
				return removeAt(index);
			else
				return null;
		}
		
		/**
		 * 从拖拽组中删除指定索引位置的对象
		 * @param index 要删除的索引位置
		 * @return 被删除的对象
		 */		
		public function removeAt(index:int):*
		{
			if(index < 0 || index >= count) return null;
			
			var tmp:* = m_elements[index];
			m_elements.splice(index, 1);
			return tmp;
		}
		
		/**
		 * 返回拖拽对象数组
		 */		
		public function toArray():Array
		{
			return m_elements.concat();
		}
		
		/**
		 * 释放资源
		 */		
		public function dispose():void
		{
			
		}
	}
}