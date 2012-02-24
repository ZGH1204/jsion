package knightage.core.net
{
	import jsion.socket.Packet;
	
	/**
	 * 数据包基类
	 * @author Jsion
	 * 
	 */	
	public class KPacket extends Packet
	{
		private var m_code:int;
		
		private var m_code2:int;
		
		private var m_playerID:uint;
		
		public function KPacket(code:int = 0, code2:int = 0)
		{
			super();
			
			m_code = code;
			
			m_code2 = code2;
			
			//m_playerID = PlayerMgr.Instance.self.id;
		}
		
		public function get code():int
		{
			return m_code;
		}
		
		public function set code(value:int):void
		{
			m_code = value;
		}
		
		public function get code2():int
		{
			return m_code2;
		}
		
		public function set code2(value:int):void
		{
			m_code2 = value;
		}
		
		public function get playerID():uint
		{
			return m_playerID;
		}
		
		public function set playerID(value:uint):void
		{
			m_playerID = value;
		}
		
		override public function get headerSize():int
		{
			return 14;
		}
		
		override public function readHeader():void
		{
			super.readHeader();
			
			position = 0;
			
			readShort();
			
			m_code = readInt();
			
			m_code2 = readInt();
			
			m_playerID = readUnsignedInt();
		}
		
		override public function writeHeader():void
		{
			super.writeHeader();
			
			position = 0;
			
			writeShort(length);
			
			writeInt(m_code);
			
			writeInt(m_code2);
			
			writeUnsignedInt(m_playerID);
		}
		
		override public function pack():void
		{
			position = 0;
			
			writeShort(length);
		}
	}
}