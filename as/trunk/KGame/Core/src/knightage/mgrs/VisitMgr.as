package knightage.mgrs
{
	import flash.events.Event;
	
	import jsion.events.JsionEventDispatcher;
	
	import knightage.events.VisitEvent;
	import knightage.player.GamePlayer;

	public class VisitMgr
	{
		private static var m_player:GamePlayer;
		
		private static var m_dispatcher:JsionEventDispatcher;
		
		public function VisitMgr()
		{
		}
		
		public static function setup():void
		{
			if(m_player) return;
			
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
		
		private static function dispatchEvent(event:Event):Boolean
		{
			return m_dispatcher.dispatchEvent(event);
		}
		
		public static function get isSelf():Boolean
		{
			return m_player == PlayerMgr.self;
		}
		
		public static function get player():GamePlayer
		{
			return m_player;
		}
		
		public static function set player(value:GamePlayer):void
		{
			if(m_player != value)
			{
				m_player = value;
				
				dispatchEvent(new VisitEvent(VisitEvent.VISIT_FRIEND, m_player));
			}
		}
		
		
		public static function updateTavernHeros(heroTID1:int, heroTID2:int, heroTID3:int, lastTime:Date):void
		{
			m_player.lastHero1TID = heroTID1;
			m_player.lastHero2TID = heroTID2;
			m_player.lastHero3TID = heroTID3;
			m_player.lastRefreshTime = lastTime;
			
			dispatchEvent(new VisitEvent(VisitEvent.REFRESH_TAVERN_HERO, m_player));
		}
	}
}