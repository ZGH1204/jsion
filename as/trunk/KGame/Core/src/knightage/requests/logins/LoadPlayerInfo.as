package knightage.requests.logins
{
	import jsion.debug.DEBUG;
	import jsion.loaders.JsionLoader;
	import jsion.utils.DateUtil;
	import jsion.utils.XmlUtil;
	
	import knightage.display.Alert;
	import knightage.mgrs.DateMgr;
	import knightage.mgrs.PlayerMgr;
	import knightage.player.SelfPlayer;
	import knightage.player.heros.PlayerHero;
	import knightage.requests.BaseRequest;
	
	public class LoadPlayerInfo extends BaseRequest
	{
		private static const File:String = "LoadPlayerInfo.ashx";
		
		public function LoadPlayerInfo(playerID:int)
		{
			super(File);
			
			setURLVariables("id", playerID);
		}
		
		override protected function onLoadCompleted():void
		{
			super.onLoadCompleted();
			
			if(m_status != COMPLETE)
			{
				DEBUG.error("玩家信息加载失败");
				
				throw new Error("玩家信息加载失败");
				return;
			}
			
			var xml:XML = data as XML;
			
			var date:Date = DateUtil.parse(String(xml.player.@today));
			
			DateMgr.setup(date);
			
			
			
			if(String(xml.@value) != "true")
			{
				Alert.show(String(xml.@message));
				return;
			}
			
			var player:SelfPlayer = new SelfPlayer();
			
			XmlUtil.decodeWithProperty(player, xml.player[0]);
			
			var heroList:XMLList = xml.HeroList.hero;
			
			for each(var heroXml:XML in heroList)
			{
				var hero:PlayerHero = new PlayerHero();
				
				XmlUtil.decodeWithProperty(hero, heroXml);
				
				player.heroMode.addHero(hero);
			}
			
			PlayerMgr.setup(player);
			PlayerMgr.onLogin();
			
			//trace(xml.toString());
		}
	}
}