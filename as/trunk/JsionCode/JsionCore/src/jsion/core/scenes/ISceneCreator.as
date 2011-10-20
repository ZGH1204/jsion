package jsion.core.scenes
{
	/**
	 * 场景创建者
	 * @author Jsion
	 */	
	public interface ISceneCreator
	{
		/**
		 * 创建场景
		 * @param type 场景类型
		 */		
		function create(type:String):BaseScene;
		
		/**
		 * 异步创建场景
		 * @param type 场景类型
		 * @param callback 回调函数
		 */		
		function createAsync(type:String, callback:Function):void;
	}
}