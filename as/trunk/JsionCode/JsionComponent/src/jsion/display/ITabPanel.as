package jsion.display
{
	/**
	 * <p>标签面板显示回调接口。</p>
	 * <p>当 TabPanel.autoFreePane 属性被设置为 true 时，仅 showPanel() 方法有效。</p>
	 * @author Jsion
	 */	
	public interface ITabPanel
	{
		/**
		 * 显示面板时被调用
		 */		
		function showPanel():void;
		
		/**
		 * 隐藏面板时被调用
		 */		
		function hidePanel():void;
	}
}