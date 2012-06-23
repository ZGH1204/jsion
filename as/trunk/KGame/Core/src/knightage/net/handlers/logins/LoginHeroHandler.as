package knightage.net.handlers.logins
{
	import core.net.GamePacket;
	import core.net.IPacketHandler;
	
	import knightage.mgrs.PlayerMgr;
	import knightage.player.heros.PlayerHero;
	
	public class LoginHeroHandler implements IPacketHandler
	{
		public function LoginHeroHandler()
		{
		}
		
		public function get code():int
		{
			return PacketCodes.LoginHero;
		}
		
		public function handle(pkg:GamePacket):void
		{
//			trace("英雄信息");
//			
//			var hero:PlayerHero = new PlayerHero();
//			
//			hero.heroID = pkg.readInt();
//			hero.templateID = pkg.readInt();
//			hero.playerID = pkg.readInt();
//			hero.lv = pkg.readInt();
//			hero.soliderCategory = pkg.readInt();
//			hero.curSoliderType = pkg.readInt();
//			hero.faith = pkg.readInt();
//			hero.teamNum = pkg.readInt();
//			hero.teamIndex = pkg.readInt();
//			hero.isAtTeam = pkg.readBoolean();
//			hero.soliders = pkg.readInt();
//			hero.morale = pkg.readInt();
//			hero.attack = pkg.readInt();
//			hero.defense = pkg.readInt();
//			hero.speed = pkg.readInt();
//			hero.crit = pkg.readInt();
//			hero.parry = pkg.readInt();
//			hero.dodge = pkg.readInt();
//			
//			PlayerMgr.self.heroMode.addHero(hero);
//			
//			PlayerMgr.onLogin();
		}
	}
}