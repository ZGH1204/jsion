package knightage.net
{
	import core.net.GamePacket;
	
	import knightage.mgrs.PlayerMgr;
	
	public class LogicPacket extends GamePacket
	{
		public function LogicPacket(code:int = 0)
		{
			super(code, PacketCodes.LogicCode, PlayerMgr.self.playerID);
		}
	}
}