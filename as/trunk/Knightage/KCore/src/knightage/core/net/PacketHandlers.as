package knightage.core.net
{
	import jsion.*;
	import jsion.core.messages.Msg;
	import jsion.core.messages.MsgMonitor;
	import jsion.core.messages.MsgReceiver;
	import jsion.core.reflection.Assembly;
	import jsion.core.reflection.Type;
	import jsion.utils.ReflectionUtil;
	
	import knightage.core.MsgFlag;
	
	public class PacketHandlers extends MsgReceiver
	{
		public static const SLGPacketReceiveID:String = "KPacketReceive";
		
		private static var m_handlers:HashMap = new HashMap();
		
		public function PacketHandlers()
		{
			super(SLGPacketReceiveID);
			
			retisteMsgHandlers();
		}
		
		protected function retisteMsgHandlers():void
		{
			registeReceive(MsgFlag.SocketReceived, receivePacket);
		}
		
		protected function removeMsgHandlers():void
		{
			removeReceive(MsgFlag.SocketReceived);
		}
		
		protected function receivePacket(msg:Msg):void
		{
			var pkg:KPacket = msg.wParam as KPacket;
			
			var hander:IPacketHandler;
			
			if(m_handlers.containsKey(pkg.code))
			{
				hander = m_handlers.get(pkg.code);
				
				hander.handle(pkg);
			}
			else
			{
				throw new Error(pkg.code + "协议包处理类不存在,请添加!");
			}
		}
		
		public static function setup(ass:Assembly):void
		{
			if(MsgMonitor.hasReceiver(SLGPacketReceiveID)) return;
			
			searchHandler(ass);
			
			var handlers:PacketHandlers = new PacketHandlers();
		}
		
		public static function searchHandler(ass:Assembly):void
		{
			var list:Vector.<Type> = ass.getTypesByInterface(IPacketHandler);
			
			var clsPath:String = ReflectionUtil.getClassPath(IPacketHandler);
			
			for each(var type:Type in list)
			{
//				if(type.getIsImplInterface(clsPath))
//				{
//					var handler:IPacketHandler = type.create() as IPacketHandler;
//					
//					m_handlers.put(handler.code, handler);
//				}
				
				var handler:IPacketHandler = type.create() as IPacketHandler;
				
				m_handlers.put(handler.code, handler);
			}
		}
		
		public static function clearHandlers():void
		{
			if(m_handlers) m_handlers.clear();
		}
		
		override public function dispose():void
		{
			removeMsgHandlers();
			
			super.dispose();
		}
	}
}