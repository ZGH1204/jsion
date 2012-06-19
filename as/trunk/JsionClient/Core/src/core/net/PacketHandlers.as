package core.net
{
	import jsion.HashMap;
	import jsion.reflection.Assembly;
	import jsion.reflection.Type;
	
	public class PacketHandlers
	{
		private static var m_handlers:HashMap = new HashMap();
		
		public function PacketHandlers()
		{
		}
		
		public static function receivePacket(pkg:GamePacket):void
		{
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
			searchHandler(ass);
		}
		
		public static function searchHandler(ass:Assembly):void
		{
			var list:Vector.<Type> = ass.getTypesByInterface(IPacketHandler);
			
			for each(var type:Type in list)
			{
				var handler:IPacketHandler = type.create() as IPacketHandler;
				
				m_handlers.put(handler.code, handler);
			}
		}
		
		public static function clearHandlers():void
		{
			if(m_handlers) m_handlers.clear();
		}
	}
}