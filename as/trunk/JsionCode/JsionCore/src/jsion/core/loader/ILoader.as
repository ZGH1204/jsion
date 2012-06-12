package jsion.core.loader
{
	import flash.events.IEventDispatcher;

	public interface ILoader extends IEventDispatcher
	{
		function get root():String;
		
		function get file():String;
		
		function get fullUrl():String;
		
		function get urlKey():String;
		
		function get data():Object;
		
		function get tag():Object;
		function set tag(value:Object):void;
		
		function get errorMsg():String;
		
		function loadAsync(callback:Function = null):void;
		
		function cancel():void;
	}
}