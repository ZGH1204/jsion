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
		
		public function startup():void
		{
			
		}
	}
}