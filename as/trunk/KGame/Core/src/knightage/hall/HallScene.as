package knightage.hall
{
	import jsion.scenes.BaseScene;
	import jsion.utils.DisposeUtil;
	
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
			m_hall = new HallView();
			addChild(m_hall);
		}
		
		override public function leaving(nextScene:BaseScene):void
		{
			DisposeUtil.free(m_hall);
			m_hall = null;
		}
		
		override public function getBackType():String
		{
			return null;
		}
	}
}