package knightage.mgrs
{
	import core.login.LoginMgr;
	
	import jsion.comps.UIMgr;
	import jsion.events.JsionEventDispatcher;
	import jsion.scenes.SceneMgr;
	
	import knightage.events.PlayerEvent;
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
		
		public static function onLogin():void
		{
			if(LoginMgr.logined) return;
			
			LoginMgr.logined = true;
			
			UIMgr.addFixUI(new TopUIView());
			
			SceneMgr.setScene(SceneType.HALL);
		}
	}
}