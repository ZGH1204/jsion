package jcore.org.moduls
{
	import jcore.org.message.DefaultReceiver;
	import jcore.org.message.DefaultSubReceiver;
	
	import jutils.org.reflection.Assembly;

	public class DefaultModule extends DefaultReceiver
	{
		protected var _moduleInfo:ModuleInfo;
		
		public function DefaultModule(moduleInfo:ModuleInfo)
		{
			_isInstalled = false;
			_moduleInfo = moduleInfo;
			
			super(moduleInfo.id);
		}
		
		/**
		 * 模块标识
		 */		
		override public function get id():String
		{
			return _moduleInfo.id;
		}
		
		/**
		 * 模块信息
		 */		
		public function get moduleInfo():ModuleInfo
		{
			return _moduleInfo;
		}
		
		////////////////////////////////////	消息系统相关		////////////////////////////////////
		
		
		////////////////////////////////////	模块相关		////////////////////////////////////
		
		/**
		 * IOC控制反转
		 * @param assembly 当前模块程序集信息
		 */		
		internal function reflection(assembly:Assembly):void
		{
			
		}
		
		public function registeSubModule(subID:String, subModuleCls:Class):void
		{
			var rlt:DefaultSubReceiver = registeSubReceive(subID, subModuleCls);
			
			var tmp:DefaultSubModule = rlt as DefaultSubModule;
			
			if(tmp) tmp.reflection(_moduleInfo.assembly);
		}
		
		////////////////////////////////////	模块相关		////////////////////////////////////
		
		override public function dispose():void
		{
			_moduleInfo = null;
			
			super.dispose();
		}
	}
}