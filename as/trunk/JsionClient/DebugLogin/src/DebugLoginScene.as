package
{
	import jsion.scenes.BaseScene;
	import jsion.utils.DisposeUtil;
	
	public class DebugLoginScene extends BaseScene
	{
		private var m_debugLoginView:DebugLoginView;
		
		public function DebugLoginScene()
		{
			super();
		}
		
		override public function getSceneType():String
		{
			return SceneType.DEBUG_LOGIN;
		}
		
		override public function enter(preScene:BaseScene, data:Object=null):void
		{
			DisposeUtil.free(m_debugLoginView);
			
			m_debugLoginView = new DebugLoginView();
			
			addChild(m_debugLoginView);
		}
		
		override public function leaving(nextScene:BaseScene):void
		{
			DisposeUtil.free(m_debugLoginView);
			m_debugLoginView = null;
		}
	}
}