package jsion.core.scenes
{
	public interface ISceneCreator
	{
		function create(type:String):BaseScene;
		
		function createAsync(type:String, callback:Function):void;
	}
}