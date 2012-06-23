package knightage.mgrs
{
	import core.login.LoginMgr;
	
	import jsion.scenes.SceneMgr;
	
	import knightage.player.SelfPlayer;

	public class PlayerMgr
	{
		private static var m_self:SelfPlayer;
		
		public function PlayerMgr()
		{
		}
		
		public static function get logined():Boolean
		{
			return LoginMgr.logined;
		}
		
		public static function get self():SelfPlayer
		{
			return m_self;
		}
		
		public static function setup(player:SelfPlayer):void
		{
			m_self = player;
		}
		
		public static function onLogin():void
		{
			LoginMgr.logined = true;
			
			SceneMgr.setScene(SceneType.HALL);
		}
	}
}