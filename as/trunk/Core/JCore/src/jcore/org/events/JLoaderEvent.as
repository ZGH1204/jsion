package jcore.org.events
{
	import flash.events.Event;
	
	/**
	 * 加载事件类
	 * @author Jsion
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion JUtils 1
	 * 
	 */	
	public class JLoaderEvent extends Event
	{
		/**
		 * 建立加载时分派
		 */		
		public static const Open:String = "open";
		/**
		 * 加载完成时分派
		 */		
		public static const Complete:String = "complete";
		/**
		 * 如果发生错误并导致发送或加载操作失败，将分派 Error 事件，其中事件数据data为要显示错误消息的文本。
		 * 
		 */		
		public static const Error:String = "error";
		/**
		 * 在网络请求返回 HTTP 状态代码时，应用程序将分派 HttpStatus 事件，其中事件数据data为Http状态代码。<br/><br/>
		 * 
		 * 在错误或完成事件之前，将始终发送 HttpStatus 事件。HttpStatus 事件不一定指示错误条件；
		 * 它仅反映网络堆栈提供的 HTTP 状态代码（如果有的话）。一些 Flash Player 环境可能无法检测到 HTTP 状态代码；
		 * 在这些情况下，将总是报告状态代码 0。 
		 */		
		public static const HttpStatus:String = "httpStatus";
		/**
		 * 资源加载总字节数获取后分派，其中事件数据data为资源总字节数。
		 */		
		public static const BytesTotal:String = "bytesTotal";
		
		/**
		 * 用于通知视频或音频可以开始播放
		 */		
		public static const CanBeginPlaying:String = "canBeginPlaying";
		
		private var _data:*;
		
		/**
		 * 事件相关数据/状态
		 * @return 
		 * 
		 */		
		public function get data():*
		{
			return _data;
		}
		
		public function JLoaderEvent(type:String, data:* = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			_data = data;
		}
		
		override public function clone():Event
		{
			return new JLoaderEvent(type, _data, bubbles, cancelable);
		}
	}
}