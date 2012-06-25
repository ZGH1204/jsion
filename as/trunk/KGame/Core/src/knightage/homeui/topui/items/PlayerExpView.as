package knightage.homeui.topui.items
{
	import flash.display.Bitmap;
	
	import jsion.display.ProgressBar;
	import jsion.utils.DisposeUtil;
	
	import knightage.StaticConfig;
	import knightage.StaticRes;
	import knightage.events.PlayerEvent;
	import knightage.homeui.LevelView;
	import knightage.mgrs.PlayerMgr;

	public class PlayerExpView extends InfoView
	{
		private var m_progress:ProgressBar;
		
		public function PlayerExpView()
		{
			super(1);
		}
		
		override protected function initialized():void
		{
			super.initialized();
			
			m_icon = new LevelView(PlayerMgr.self.castleTID, LevelView.TOP);
			addChild(m_icon);
			
			m_progress = new ProgressBar();
			m_progress.beginChanges();
			m_progress.freeBMD = false;
			m_progress.progressBar = new Bitmap(StaticRes.ProgressBarBMD);
			m_progress.maxValue = StaticConfig.CastleUpGradeExp[PlayerMgr.self.castleTID];
			m_progress.value = PlayerMgr.self.experience;
			m_progress.commitChanges();
			addChild(m_progress);
			
			m_icon.x = 4;
			m_icon.y = 6;
			
			m_progress.x = 46;
			m_progress.y = 15;
			
			PlayerMgr.addEventListener(PlayerEvent.EXP_CHANGED, __expChangeHandler);
		}
		
		private function __expChangeHandler(e:PlayerEvent):void
		{
			// TODO Auto Generated method stub
			
			LevelView(m_icon).setLevel(PlayerMgr.self.castleTID);
			
			m_progress.beginChanges();
			m_progress.maxValue = StaticConfig.CastleUpGradeExp[PlayerMgr.self.castleTID];
			m_progress.value = PlayerMgr.self.experience;
			m_progress.commitChanges();
		}
		
		override public function dispose():void
		{
			PlayerMgr.removeEventListener(PlayerEvent.EXP_CHANGED, __expChangeHandler);
			
			DisposeUtil.free(m_icon);
			m_icon = null;
			
			DisposeUtil.free(m_progress, false);
			m_progress = null;
			
			super.dispose();
		}
	}
}