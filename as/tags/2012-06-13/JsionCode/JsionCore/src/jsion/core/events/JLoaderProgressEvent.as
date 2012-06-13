package jsion.core.events
{
	import flash.events.ProgressEvent;
	
	/**
	 * 加载进程更新事件
	 * @author Jsion
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion JUtils 1
	 * 
	 */	
	public class JLoaderProgressEvent extends ProgressEvent
	{
		/**
		 * 当加载操作已开始或套接字已接收到数据时，将分派 JLoaderProgressEvent 对象。这些事件通常在将 SWF 文件、图像或数据加载到应用程序中时生成。
		 */		
		public static const PROGRESS:String = "progress";
		
		public function JLoaderProgressEvent(type:String, bytesLoaded:uint = 0, bytesTotal:uint = 0, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable, bytesLoaded, bytesTotal);
		}
	}
}