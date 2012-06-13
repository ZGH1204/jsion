package jsion.rpg.interfaces
{
	import jsion.rpg.RPGGame;

	public interface IPrepareMap
	{
		function setGame(game:RPGGame):void;
		
		function startLoading():void;
		
		function progress(bytesLoaded:uint, bytesTotal:uint):void;
		
		function loadError(errorMsg:String):void;
		
		function loadComplete():void;
	}
}