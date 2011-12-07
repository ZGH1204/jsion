package jsion
{
	import flash.utils.Dictionary;
		
	/**
	 * 弱引用类,value值为弱引用.
	 * @author Jsion
	 */
	public class WeakReference
	{
		
		private var weakDic:Dictionary;
		
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
	}
}