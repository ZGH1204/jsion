package jsion
{
	import flash.utils.Dictionary;
		
	/**
	 * 弱引用类,value值为弱引用.
	 * @author Jsion
	 */
	public class WeakReference implements IDispose
	{
		
		private var weakDic:Dictionary;
		
		/**
		 * @private
		 */		
		public function set value(v:*):void
		{
			if(v == null)
			{
				weakDic = null;
			}
			else
			{
				weakDic = new Dictionary(true);
				weakDic[v] = null;
			}
		}
		
		/**
		 * 获取或设置要弱引用的对象
		 */		
		public function get value():*
		{
			if(weakDic)
			{
				for(var v:* in weakDic)
				{
					return v;
				}
			}
			return null;
		}
		
		/**
		 * Clear the value, same to <code>WeakReference.value=null;</code>
		 */
		public function clear():void
		{
			weakDic = null;
		}
		
		/**
		 * 释放资源
		 */		
		public function dispose():void
		{
			clear();
		}
	}
}