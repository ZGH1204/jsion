package jsion.core.scenes
{
	import flash.display.Sprite;
	
	import jsion.IDispose;
	
	/**
	 * 场景过渡动画基类
	 * @author Jsion
	 * 
	 */	
	public class DefaultFading extends Sprite implements IFading, IDispose
	{
		public function DefaultFading()
		{
			super();
		}
		
		/**
		 * @copy jsion.core.scenes.IFading#setFading()
		 */		
		public function setFading(callback:Function):void
		{
			callback();
		}
		
		/**
		 * 释放资源
		 * 
		 */		
		public function dispose():void
		{
		}
	}
}