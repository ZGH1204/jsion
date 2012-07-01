package knightage.net.handlers.tavern
{
	import core.net.GamePacket;
	import core.net.IPacketHandler;
	
	import knightage.GameUtil;
	import knightage.mgrs.PlayerMgr;
	import knightage.mgrs.VisitMgr;
	
	public class PartyHandler implements IPacketHandler
	{
		public function PartyHandler()
		{
		}
		
		public function get code():int
		{
			return PacketCodes.Party;
		}
		
		public function handle(pkg:GamePacket):void
		{
			var type:int = pkg.readUnsignedByte();
			var price:int = pkg.readInt();
			var heroTID1:int = pkg.readInt();
			var heroTID2:int = pkg.readInt();
			var heroTID3:int = pkg.readInt();
			var date:Date = pkg.readDate();
			
			if(type == 1) //普通派对
			{
				PlayerMgr.subPlayerCoin(price);
				
				PlayerMgr.addPrestige(GameUtil.getPartyPrestige(PlayerMgr.self));
			}
			else
			{
				PlayerMgr.subPlayerGold(price);
				
				PlayerMgr.addGrandPartyGold(GameUtil.getGrandPartyPriceStep(PlayerMgr.self));
				
				PlayerMgr.addPrestige(GameUtil.getGrandPartyPrestige(PlayerMgr.self));
			}
			
			//TODO: 加上声望值，更新声望等级，更新酒馆英雄列表。
			
			if(VisitMgr.isSelf)
			{
				VisitMgr.updateTavernHeros(heroTID1, heroTID2, heroTID3, date);
			}
			else
			{
				PlayerMgr.updateTavernHeros(heroTID1, heroTID2, heroTID3, date);
			}
		}
	}
}