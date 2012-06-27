package knightage.mgrs
{
	import core.login.LoginMgr;
	
	import jsion.comps.UIMgr;
	import jsion.events.JsionEventDispatcher;
	import jsion.scenes.SceneMgr;
	
	import knightage.GameUtil;
	import knightage.StaticConfig;
	import knightage.events.PlayerEvent;
	import knightage.hall.build.BuildType;
	import knightage.homeui.bottomui.BottomUIView;
	import knightage.homeui.topui.TopUIView;
	import knightage.player.GamePlayer;
	import knightage.player.SelfPlayer;
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
		
		public static function updatePlayerExp(value:int):void
		{
			if(m_self.experience != value)
			{
				m_self.experience = value;
				
				dispatchEvent(new PlayerEvent(PlayerEvent.EXP_CHANGED, m_self.experience));
			}
		}
		
		public static function updatePlayerCoin(value:int):void
		{
			if(m_self.coins != value)
			{
				m_self.coins = value;
				
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
		
		public static function updatePlayerGold(value:int):void
		{
			if(m_self.gold != value)
			{
				m_self.gold = value;
				
				dispatchEvent(new PlayerEvent(PlayerEvent.GOLD_CHANGED, m_self.gold));
			}
		}
		
		public static function updatePlayerSolider(value:int):void
		{
			if(m_self.soliders != value)
			{
				m_self.soliders = value;
				
				dispatchEvent(new PlayerEvent(PlayerEvent.SOLIDER_CHANGED, m_self.soliders));
			}
		}
		
		public static function updatePlayerFood(value:int):void
		{
			if(m_self.foods != value)
			{
				m_self.foods = value;
				
				dispatchEvent(new PlayerEvent(PlayerEvent.FOOD_CHANGED, m_self.foods));
			}
		}
		
		public static function updatePlayerOrder(value:int):void
		{
			if(m_self.orders != value)
			{
				m_self.orders = value;
				
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
		
		public static function onLogin():void
		{
			if(LoginMgr.logined) return;
			
			LoginMgr.logined = true;
			
			UIMgr.addFixUI(new TopUIView());
			
			UIMgr.addFixUI(new BottomUIView());
			
			VisitMgr.player = m_self;
			
			SceneMgr.setScene(SceneType.HALL);
		}
	}
}