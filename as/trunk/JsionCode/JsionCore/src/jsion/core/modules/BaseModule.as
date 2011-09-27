package jsion.core.modules
{
	import jsion.core.messages.MsgReceiver;
	
	public class BaseModule extends MsgReceiver
	{
		protected var m_moduleInfo:ModuleInfo;
		
		public function BaseModule(info:ModuleInfo)
		{
			super(info.id);
			
			m_moduleInfo = info;
		}
		
		public function get moduleInfo():ModuleInfo
		{
			return m_moduleInfo;
		}
		
		public function startup():void
		{
			
		}
		
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