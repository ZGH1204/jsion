package jsion
{
	/**
	 * 比较接口
	 * @author Jsion
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion JUtils 1
	 * 
	 */	
	public interface IComparable
	{
		/**
		 * 对象比较
		 * @param obj 要比较的对象
		 * @return 0表示比较的对象相同
		 * <p>1表示大于比较对象</p>
		 * <p>-1表示小于比较对象</p>
		 * <p>int.MIN_VALUE表示比较的对象不同</p>
		 */		
		function equals(obj:Object):int;
	}
}