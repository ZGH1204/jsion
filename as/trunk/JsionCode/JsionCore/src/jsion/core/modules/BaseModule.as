package jsion.core.modules
{
	import jsion.core.messages.MsgReceiver;
	
	/**
	 * 模块基类
	 * @author Jsion
	 * 
	 */	
	public class BaseModule extends MsgReceiver
	{
		protected var m_moduleInfo:ModuleInfo;
		
		public function BaseModule(info:ModuleInfo)
		{
			super(info.id);
			
			m_moduleInfo = info;
		}
		
		/**
		 * 模块信息
		 */		
		public function get moduleInfo():ModuleInfo
		{
			return m_moduleInfo;
		}
		
		/**
		 * 模块启动函数
		 */		
		public function startup():void
		{
			
		}
		
		/**
		 * 模块停止函数
		 */		
		public function stop():void
		{
			
		}
		
		
		override public function dispose():void
		{
			stop();
			m_moduleInfo = null;
			super.dispose();
		}
	}
}