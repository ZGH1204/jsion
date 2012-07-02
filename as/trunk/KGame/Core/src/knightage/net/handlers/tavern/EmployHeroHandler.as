package knightage.net.handlers.tavern
{
	import core.net.GamePacket;
	import core.net.IPacketHandler;
	
	import knightage.GameUtil;
	import knightage.mgrs.MsgTipMgr;
	import knightage.mgrs.PlayerMgr;
	import knightage.mgrs.TemplateMgr;
	import knightage.player.heros.PlayerHero;
	
	public class EmployHeroHandler implements IPacketHandler
	{
		public function EmployHeroHandler()
		{
		}
		
		public function get code():int
		{
			return PacketCodes.EmployHero;
		}
		
		public function handle(pkg:GamePacket):void
		{
			var index:int = pkg.readUnsignedByte();
			var heroID:int = pkg.readInt();
			var templateID:int = pkg.readInt();
			
			var hero:PlayerHero = GameUtil.createHero(templateID, PlayerMgr.self.playerID);
			
			hero.heroID = heroID;
			
			PlayerMgr.employ(hero, index);
			
			MsgTipMgr.show(hero.TemplateName + " 雇佣成功!");
		}
	}
}