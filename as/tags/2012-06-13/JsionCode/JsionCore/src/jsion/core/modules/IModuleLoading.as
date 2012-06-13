package jsion.core.modules
{
	/**
	 * 模块加载时的等待接口
	 * @author Jsion
	 */	
	public interface IModuleLoading
	{
		/**
		 * 显示加载界面，开始加载时调用。
		 */		
		function showLoadingView():void;
		
		/**
		 * 加载进度变更时被调用执行。
		 * @param bytesLoaded 已加载的字节数
		 * @param bytesTotal 需要加载的字节数
		 */		
		function progress(bytesLoaded:int, bytesTotal:int):void;
		
		/**
		 * 加载完成时调用。
		 */		
		function complete():void;
	}
}