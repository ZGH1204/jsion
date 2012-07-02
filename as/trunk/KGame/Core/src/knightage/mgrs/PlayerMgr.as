package knightage.mgrs
{
	import core.login.LoginMgr;
	
	import jsion.comps.UIMgr;
	import jsion.events.JsionEventDispatcher;
	import jsion.scenes.SceneMgr;
	
	import knightage.GameUtil;
	import knightage.events.PlayerEvent;
	import knightage.homeui.bottomui.BottomUIView;
	import knightage.homeui.topui.TopUIView;
	import knightage.player.SelfPlayer;
	import knightage.player.heros.PlayerHero;
	import knightage.templates.BuildTemplate;

	public class PlayerMgr
	{
		private static var m_self:SelfPlayer;
		
		private static var m_dispatcher:JsionEventDispatcher;
		
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
			if(m_self) return;
			
			m_self = player;
			
			m_dispatcher = new JsionEventDispatcher();
		}
		
		public static function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			m_dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public static function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			m_dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		private static function dispatchEvent(event:PlayerEvent):Boolean
		{
			return m_dispatcher.dispatchEvent(event);
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		public static function updateBuildTID(type:int, tid:int):void
		{
			var template:BuildTemplate = TemplateMgr.findBuildTemplate(tid);
			
			if(template == null)
			{
				throw new Error("找不到此建筑模板");
				return;
			}
			
			if(template.BuildType != type)
			{
				throw new Error("建筑类型不匹配");
				return;
			}
			
			var oldTID:int = GameUtil.getBuildTID(m_self, type);
			
			if(oldTID != tid && tid > 0)
			{
				GameUtil.setBuildTID(m_self, type, tid);
				
				dispatchEvent(new PlayerEvent(PlayerEvent.BUILD_UPGRADE, type));
				dispatchEvent(new PlayerEvent(PlayerEvent.EXP_CHANGED, m_self.experience));
			}
		}
		
		public static function subPlayerExp(value:int):void
		{
			if(m_self.experience != value)
			{
				m_self.experience -= value;
				
				dispatchEvent(new PlayerEvent(PlayerEvent.EXP_CHANGED, m_self.experience));
			}
		}
		
		public static function subPlayerCoin(value:int):void
		{
			if(m_self.coins != value)
			{
				m_self.coins -= value;
				
				dispatchEvent(new PlayerEvent(PlayerEvent.COIN_CHANGED, m_self.coins));
			}
		}
		
		public static function updatePlayerCoinLimit(value:int):void
		{
			if(m_self.coinsLimit != value)
			{
				m_self.coinsLimit = value;
				
				dispatchEvent(new PlayerEvent(PlayerEvent.COIN_CHANGED, m_self.coins));
			}
		}
		
		public static function subPlayerGold(value:int):void
		{
			if(m_self.gold != value)
			{
				m_self.gold -= value;
				
				dispatchEvent(new PlayerEvent(PlayerEvent.GOLD_CHANGED, m_self.gold));
			}
		}
		
		public static function subPlayerSolider(value:int):void
		{
			if(m_self.soliders != value)
			{
				m_self.soliders -= value;
				
				dispatchEvent(new PlayerEvent(PlayerEvent.SOLIDER_CHANGED, m_self.soliders));
			}
		}
		
		public static function subPlayerFood(value:int):void
		{
			if(m_self.foods != value)
			{
				m_self.foods -= value;
				
				dispatchEvent(new PlayerEvent(PlayerEvent.FOOD_CHANGED, m_self.foods));
			}
		}
		
		public static function subPlayerOrder(value:int):void
		{
			if(m_self.orders != value)
			{
				m_self.orders -= value;
				
				dispatchEvent(new PlayerEvent(PlayerEvent.ORDER_CHANGED, m_self.orders));
			}
		}
		
		public static function updatePlayerOrderLimit(value:int):void
		{
			if(m_self.ordersLimit!= value)
			{
				m_self.ordersLimit = value;
				
				dispatchEvent(new PlayerEvent(PlayerEvent.ORDER_CHANGED, m_self.orders));
			}
		}
		
		
		public static function addPrestige(prestige:int):void
		{
			m_self.prestige += prestige;
			
			var upgradePrestige:int = GameUtil.getPrestigeUpgradeExp(m_self);
			
			if(m_self.prestige >= upgradePrestige)
			{
				m_self.prestige -= upgradePrestige;
				m_self.prestigeLv += 1;
			}
			
			dispatchEvent(new PlayerEvent(PlayerEvent.PRESTIGE_CHANGED, m_self));
		}
		
		public static function updateTavernHeros(heroTID1:int, heroTID2:int, heroTID3:int, lastTime:Date):void
		{
			m_self.lastHero1TID = heroTID1;
			m_self.lastHero2TID = heroTID2;
			m_self.lastHero3TID = heroTID3;
			m_self.lastRefreshTime = lastTime;
			
			dispatchEvent(new PlayerEvent(PlayerEvent.REFRESH_TAVERN_HERO, m_self));
		}
		
		public static function addGrandPartyGold(gold:int):void
		{
			m_self.partyGold += gold;
			
			dispatchEvent(new PlayerEvent(PlayerEvent.GRAND_PARTY_PRICE_CHANGED, m_self.partyGold));
		}
		
		
		
		public static function employ(hero:PlayerHero, index:int):void
		{
			m_self.heroMode.addHero(hero);
			
			switch(index)
			{
				case 1:
					m_self.lastHero1TID = 0;
					break;
				case 2:
					m_self.lastHero2TID = 0;
					break;
				case 3:
					m_self.lastHero3TID = 0;
					break;
			}
			
			dispatchEvent(new PlayerEvent(PlayerEvent.EMPLOY_HERO, index));
		}
		
		public static function onLogin():void
		{
			if(LoginMgr.logined) return;
			
			LoginMgr.logined = true;
			
			m_self.checkResetProp();
			
			UIMgr.addFixUI(new TopUIView());
			
			UIMgr.addFixUI(new BottomUIView());
			
			VisitMgr.player = m_self;
			
			SceneMgr.setScene(SceneType.HALL);
		}
	}
}