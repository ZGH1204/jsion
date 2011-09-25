package jsion.core.scenes
{
	import flash.events.IEventDispatcher;

	public interface IFading extends IEventDispatcher
	{
		function setFading(callback:Function):void;
	}
}