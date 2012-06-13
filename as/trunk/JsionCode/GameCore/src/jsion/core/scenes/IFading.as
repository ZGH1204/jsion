package jsion.core.scenes
{
	import flash.events.IEventDispatcher;

	/**
	 * 场景过渡动画接口
	 * @author Jsion
	 */	
	public interface IFading extends IEventDispatcher
	{
		/**
		 * 开始场景过渡
		 * @param callback 过渡完成的回调函数
		 */		
		function setFading(callback:Function):void;
	}
}