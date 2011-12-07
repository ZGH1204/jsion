package jsion.core.scenes
{
	import flash.display.Sprite;
	
	import jsion.IDispose;
	
	public class DefaultFading extends Sprite implements IFading, IDispose
	{
		public function DefaultFading()
		{
			super();
		}
		
		public function setFading(callback:Function):void
		{
			callback();
		}
		
		public function dispose():void
		{
		}
	}
}