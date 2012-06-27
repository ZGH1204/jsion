package knightage.hall
{
	import jsion.scenes.BaseScene;
	import jsion.utils.DisposeUtil;
	
	import knightage.events.VisitEvent;
	import knightage.mgrs.VisitMgr;
	
	public class HallScene extends BaseScene
	{
		private var m_hall:HallView;
		
		public function HallScene()
		{
			super();
		}
		
		override public function getSceneType():String
		{
			return SceneType.HALL;
		}
		
		override public function enter(preScene:BaseScene, data:Object=null):void
		{
			m_hall = new HallView(VisitMgr.player);
			
			addChild(m_hall);
			
			VisitMgr.addEventListener(VisitEvent.VISIT_FRIEND, __visitFriendHandler);
		}
		
		private function __visitFriendHandler(e:VisitEvent):void
		{
			// TODO Auto Generated method stub
			
			DisposeUtil.free(m_hall);
			
			m_hall = new HallView(VisitMgr.player);
			
			addChild(m_hall);
		}
		
		override public function leaving(nextScene:BaseScene):void
		{
			DisposeUtil.free(m_hall);
			m_hall = null;
			
			
			VisitMgr.removeEventListener(VisitEvent.VISIT_FRIEND, __visitFriendHandler);
		}
		
		override public function getBackType():String
		{
			return null;
		}
	}
}