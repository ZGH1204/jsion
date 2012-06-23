package knightage.net.handlers.logins
{
	import core.net.GamePacket;
	import core.net.IPacketHandler;
	
	import knightage.mgrs.PlayerMgr;
	import knightage.player.SelfPlayer;
	import knightage.requests.logins.LoadPlayerInfo;
	
	public class LoginPlayerHandler implements IPacketHandler
	{
		public function LoginPlayerHandler()
		{
		}
		
		public function get code():int
		{
			return PacketCodes.LoginPlayer;
		}
		
		public function handle(pkg:GamePacket):void
		{
			//trace("登陆成功");
			
			var playerID:int = pkg.readInt();
			
			new LoadPlayerInfo(playerID).loadAsync();;
			
//			var player:SelfPlayer = new SelfPlayer();
//			
//			player.playerID = pkg.readInt();
//			player.nickName = pkg.readUTF();
//			pkg.readInt();
//			player.grade = pkg.readInt();
//			player.experience = pkg.readInt();
//			player.orders = pkg.readInt();
//			player.ordersLimit = pkg.readInt();
//			player.coins = pkg.readInt();
//			player.coinsLimit = pkg.readInt();
//			player.soliders = pkg.readInt();
//			player.hurtSoliders = pkg.readInt();
//			player.peoples = pkg.readInt();
//			player.foods = pkg.readInt();
//			player.farmlandTID = pkg.readInt();
//			player.residenceTID = pkg.readInt();
//			player.barracksTID = pkg.readInt();
//			player.churchTID = pkg.readInt();
//			player.treasuryTID = pkg.readInt();
//			player.trainingTID = pkg.readInt();
//			player.pandoraTID = pkg.readInt();
//			player.blacksmithTID = pkg.readInt();
//			player.divinationTID = pkg.readInt();
//			player.pubTID = pkg.readInt();
//			player.marketTID = pkg.readInt();
//			player.legions = pkg.readInt();
//			player.heros = pkg.readInt();
//			player.chapterID = pkg.readInt();
//			player.missionsID = pkg.readInt();
//			player.currentTeam = pkg.readInt();
//			player.prestige = pkg.readInt();
//			player.prestigeLv = pkg.readInt();
//			player.lastRefreshTime = pkg.readDate();
//			player.lastHero1TID = pkg.readInt();
//			player.lastHero2TID = pkg.readInt();
//			player.lastHero3TID = pkg.readInt();
//			player.teamInfo = pkg.readUTF();
//			player.exploit = pkg.readInt();
//			
//			PlayerMgr.setup(player);
//			
//			var now:Date = pkg.readDate();
		}
	}
}