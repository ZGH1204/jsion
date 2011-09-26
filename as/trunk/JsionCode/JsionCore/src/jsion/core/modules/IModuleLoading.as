package jsion.core.modules
{
	public interface IModuleLoading
	{
		function showLoadingView():void;
		
		function progress(bytesLoaded:int, bytesTotal:int):void;
		
		function complete():void;
	}
}