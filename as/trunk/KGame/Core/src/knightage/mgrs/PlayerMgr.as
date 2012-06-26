package knightage.mgrs
{
	import core.login.LoginMgr;
	
	import jsion.comps.UIMgr;
	import jsion.events.JsionEventDispatcher;
	import jsion.scenes.SceneMgr;
	
	import knightage.StaticConfig;
	import knightage.events.PlayerEvent;
	import knightage.hall.build.BuildType;
	import knightage.homeui.bottomui.BottomUIView;
	import knightage.homeui.topui.TopUIView;
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
		
		/**
		 * 获取玩家等级
		 */		
		public static function getPlayerLv():int
		{
			var temp:BuildTemplate = getBuildTemplate(BuildType.Castle);
			
			if(temp) return temp.Lv;
			
			return 0;
		}
		
		/**
		 * 获取指定建筑类型一级对应的建筑模板
		 * @param type
		 * @return 
		 * 
		 */		
		public static function getBuildFirstLvTemplate(type:int):BuildTemplate
		{
			var tid:int = StaticConfig.BuildFirstLvTIDList[type];
			
			return TemplateMgr.findBuildTemplate(tid);
		}
		
		/**
		 * 获取当前玩家指定建筑类型下一级的建筑模板
		 * @param type
		 * @return 
		 * 
		 */		
		public static function getBuildNextTemplate(type:int):BuildTemplate
		{
			var tid:int = getBuildTID(type);
			
			var temp:BuildTemplate = TemplateMgr.findBuildTemplate(tid);
			
			if(temp == null) return null;
			
			tid = temp.NextTemplateID;
			
			return TemplateMgr.findBuildTemplate(tid);
		}
		
		/**
		 * 获取当前玩家城堡升下一级所需的经验值
		 * @param type
		 * @return 
		 * 
		 */		
		public static function getCastleNextUpgradeExp():int
		{
			var tid:int = getBuildTID(BuildType.Castle);
			
			var nextTemplate:BuildTemplate = getBuildNextTemplate(BuildType.Castle);
			
			if(tid == 0)
			{
				nextTemplate = getBuildFirstLvTemplate(BuildType.Castle);
			}
			
			if(nextTemplate)
			{
				return StaticConfig.CastleUpGradeExp[nextTemplate.Lv];
			}
			
			return int.MAX_VALUE;
		}
		
		/**
		 * 获取当前玩家指定建筑类型的建筑模板
		 * @param type
		 * @return 
		 * 
		 */		
		public static function getBuildTemplate(type:int):BuildTemplate
		{
			var tid:int = getBuildTID(type);
			
			return TemplateMgr.findBuildTemplate(tid);
		}
		
		/**
		 * 获取当前玩家指定建筑类型的建筑模板ID
		 * @param type
		 * 
		 */		
		public static function getBuildTID(type:int):int
		{
			var m_templateID:int;
			
			switch(type)
			{
				case BuildType.Castle:
					m_templateID = PlayerMgr.self.castleTID;
					break;
				case BuildType.Framland:
					m_templateID = PlayerMgr.self.farmlandTID;
					break;
				case BuildType.Tavern:
					m_templateID = PlayerMgr.self.tavernTID;
					break;
				case BuildType.College:
					m_templateID = PlayerMgr.self.collegeTID;
					break;
				case BuildType.Barracks:
					m_templateID = PlayerMgr.self.barracksTID;
					break;
				case BuildType.Training:
					m_templateID = PlayerMgr.self.trainingTID;
					break;
				case BuildType.Market:
					m_templateID = PlayerMgr.self.marketTID;
					break;
				case BuildType.Prison:
					m_templateID = PlayerMgr.self.prisonTID;
					break;
				case BuildType.Divine:
					m_templateID = PlayerMgr.self.divineTID;
					break;
				case BuildType.Pandora:
					m_templateID = PlayerMgr.self.pandoraTID;
					break;
				case BuildType.Efigy:
					m_templateID = PlayerMgr.self.efigyTID;
					break;
				case BuildType.Smithy:
					m_templateID = PlayerMgr.self.smithyTID;
					break;
			}
			
			return m_templateID;
		}
		
		public static function setBuildTID(type:int, tid:int):void
		{
			switch(type)
			{
				case BuildType.Castle:
					PlayerMgr.self.castleTID = tid;
					break;
				case BuildType.Framland:
					PlayerMgr.self.farmlandTID = tid;
					break;
				case BuildType.Tavern:
					PlayerMgr.self.tavernTID = tid;
					break;
				case BuildType.College:
					PlayerMgr.self.collegeTID = tid;
					break;
				case BuildType.Barracks:
					PlayerMgr.self.barracksTID = tid;
					break;
				case BuildType.Training:
					PlayerMgr.self.trainingTID = tid;
					break;
				case BuildType.Market:
					PlayerMgr.self.marketTID = tid;
					break;
				case BuildType.Prison:
					PlayerMgr.self.prisonTID = tid;
					break;
				case BuildType.Divine:
					PlayerMgr.self.divineTID = tid;
					break;
				case BuildType.Pandora:
					PlayerMgr.self.pandoraTID = tid;
					break;
				case BuildType.Efigy:
					PlayerMgr.self.efigyTID = tid;
					break;
				case BuildType.Smithy:
					PlayerMgr.self.smithyTID = tid;
					break;
			}
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
			
			var oldTID:int = getBuildTID(type);
			
			if(oldTID != tid && tid > 0)
			{
				setBuildTID(type, tid);
				
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
			
			SceneMgr.setScene(SceneType.HALL);
		}
	}
}