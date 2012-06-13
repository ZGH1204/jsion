package jsion
{
	import flash.net.LocalConnection;

	/**
	 * 垃圾强制回收类
	 * @author Jsion
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion JUtils 1
	 * 
	 */	
	public class GC
	{
		/**
		 * 强制内存回收资源
		 * 通过 new LocalConnection().connect("hack") hack方式回收
		 */		
		public static function collect():void
		{
			try
			{
				new LocalConnection().connect("FreeMemory");
				new LocalConnection().connect("FreeMemory");
			}
			catch(error : Error)
			{
				//trace("清理内存");
			}
		}
	}
}