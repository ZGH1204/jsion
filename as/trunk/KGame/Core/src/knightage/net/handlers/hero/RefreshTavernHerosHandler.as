package knightage.net.handlers.hero
{
	import core.net.GamePacket;
	import core.net.IPacketHandler;
	
	import knightage.mgrs.VisitMgr;
	
	public class RefreshTavernHerosHandler implements IPacketHandler
	{
		public function RefreshTavernHerosHandler()
		{
		}
		
		public function get code():int
		{
			return PacketCodes.RefreshTavernHeros;
		}
		
		public function handle(pkg:GamePacket):void
		{
			pkg.readInt();
			
			var tid1:int = pkg.readInt();
			var tid2:int = pkg.readInt();
			var tid3:int = pkg.readInt();
			var d:Date = pkg.readDate();
			
			VisitMgr.updateTavernHeros(tid1, tid2, tid3, d);
		}
	}
}