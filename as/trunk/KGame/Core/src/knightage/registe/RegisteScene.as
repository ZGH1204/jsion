package knightage.registe
{
	import jsion.scenes.BaseScene;
	import jsion.utils.DisposeUtil;
	
	public class RegisteScene extends BaseScene
	{
		public function RegisteScene()
		{
			super();
		}
		
		private var m_registeView:RegisteView;
		
		override public function enter(preScene:BaseScene, data:Object=null):void
		{
			m_registeView = new RegisteView();
			
			addChild(m_registeView);
		}
		
		override public function leaving(nextScene:BaseScene):void
		{
			DisposeUtil.free(m_registeView);
			m_registeView = null;
		}
	}
}