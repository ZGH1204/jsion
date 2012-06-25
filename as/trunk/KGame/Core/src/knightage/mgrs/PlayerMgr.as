package knightage.mgrs
{
	import core.login.LoginMgr;
	
	import jsion.comps.UIMgr;
	import jsion.events.JsionEventDispatcher;
	import jsion.scenes.SceneMgr;
	
	import knightage.events.PlayerEvent;
	import knightage.homeui.bottomui.BottomUIView;
	import knightage.homeui.topui.TopUIView;
	import knightage.player.SelfPlayer;

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
		
		public static function updatePlayerExp(value:int):void
		{
			m_self.experience = value;
			
			dispatchEvent(new PlayerEvent(PlayerEvent.EXP_CHANGED, m_self.experience));
		}
		
		public static function updatePlayerCoin(value:int):void
		{
			m_self.coins = value;
			
			dispatchEvent(new PlayerEvent(PlayerEvent.COIN_CHANGED, m_self.coins));
		}
		
		public static function updatePlayerGold(value:int):void
		{
			m_self.gold = value;
			
			dispatchEvent(new PlayerEvent(PlayerEvent.GOLD_CHANGED, m_self.gold));
		}
		
		public static function updatePlayerSolider(value:int):void
		{
			m_self.soliders = value;
			
			dispatchEvent(new PlayerEvent(PlayerEvent.SOLIDER_CHANGED, m_self.soliders));
		}
		
		public static function updatePlayerFood(value:int):void
		{
			m_self.foods = value;
			
			dispatchEvent(new PlayerEvent(PlayerEvent.FOOD_CHANGED, m_self.foods));
		}
		
		public static function updatePlayerOrder(value:int):void
		{
			m_self.orders = value;
			
			dispatchEvent(new PlayerEvent(PlayerEvent.ORDER_CHANGED, m_self.orders));
		}
		
		public static function onLogin():void
		{
			if(LoginMgr.logined) return;
			
			LoginMgr.logined = true;
			
			UIMgr.addFixUI(new TopUIView());
			
			UIMgr.addFixUI(new BottomUIView());
			
			SceneMgr.setScene(SceneType.HALL);
		}
	}
}