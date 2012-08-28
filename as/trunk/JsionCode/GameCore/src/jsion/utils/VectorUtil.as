package jsion.utils
{
	public class VectorUtil
	{
		
		/**
		 * 移除数组中的所有对象
		 * @param v
		 * 
		 */		
		public static function removeAll(v:Vector.<*>):void
		{
			if(v == null || v.length == 0) return;
			
			v.splice(0, v.length);
		}
	}
}