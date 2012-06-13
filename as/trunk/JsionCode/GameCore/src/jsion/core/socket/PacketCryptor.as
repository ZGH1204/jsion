package jsion.core.socket
{
	/**
	 * 数据包加密器
	 * @author Jsion
	 */	
	public class PacketCryptor implements IPacketCryptor
	{
		private static const FSM_ADDER:int = 0xabcdef;
		private static const FSM_MULIT:int = 2212;
		
		private var fsm:FSM = new FSM(FSM_ADDER, FSM_MULIT);
		
		public function encrypt(bytes:Packet):void
		{
			for(var i:int = 0; i < bytes.length; i++)
			{
				bytes[i] = (bytes[i] ^ fsm.State);
			}
		}
		
		public function decrypt(bytes:Packet):void
		{
			for(var i:int = 0; i < bytes.length; i++)
			{
				bytes[i] = (bytes[i] ^ fsm.State);
			}
		}
		
		public function update():void
		{
			fsm.updateState();
		}
	}
}