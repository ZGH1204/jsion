package knightage.homeui.topui
{
	import flash.display.Bitmap;
	
	import jsion.display.Label;
	import jsion.display.ProgressBar;
	import jsion.utils.DisposeUtil;
	
	import knightage.StaticRes;
	import knightage.events.PlayerEvent;
	import knightage.mgrs.PlayerMgr;

	public class PlayerExpView extends InfoView
	{
		private var m_lvLabel:Label;
		
		private var m_progress:ProgressBar;
		
		public function PlayerExpView()
		{
			super(1);
		}
		
		override protected function initialized():void
		{
			super.initialized();
			
			m_icon = new Bitmap(StaticRes.LvIcon);
			addChild(m_icon);
			
			m_progress = new ProgressBar();
			m_progress.beginChanges();
			m_progress.freeBMD = false;
			m_progress.progressBar = new Bitmap(StaticRes.ProgressBarBMD);
			m_progress.maxValue = StaticRes.CastleUpGradeExp[PlayerMgr.self.castleTID];
			m_progress.value = PlayerMgr.self.experience;
			m_progress.commitChanges();
			addChild(m_progress);
			
			m_lvLabel = new Label();
			m_lvLabel.beginChanges();
			m_lvLabel.text = PlayerMgr.self.castleTID.toString();
			m_lvLabel.filters = StaticRes.TopUINumFilters;
			m_lvLabel.textColor = StaticRes.TopUINumColor;
			m_lvLabel.textFormat = StaticRes.TopUINumTextFormat;
			m_lvLabel.commitChanges();
			addChild(m_lvLabel);
			
			m_icon.x = 4;
			m_icon.y = 6;
			
			m_progress.x = 46;
			m_progress.y = 15;
			
			refreshLvLabelPos();
			
			PlayerMgr.addEventListener(PlayerEvent.EXP_CHANGED, __expChangeHandler);
		}
		
		private function __expChangeHandler(e:PlayerEvent):void
		{
			// TODO Auto Generated method stub
			
			m_lvLabel.text = PlayerMgr.self.castleTID.toString();
			
			m_progress.beginChanges();
			m_progress.maxValue = StaticRes.CastleUpGradeExp[PlayerMgr.self.castleTID];
			m_progress.value = PlayerMgr.self.experience;
			m_progress.commitChanges();
			
			refreshLvLabelPos();
		}
		
		private function refreshLvLabelPos():void
		{
			m_lvLabel.x = m_icon.x + (m_icon.width - m_lvLabel.width) / 2;
			m_lvLabel.y = m_icon.y + 3;
		}
		
		override public function dispose():void
		{
			PlayerMgr.removeEventListener(PlayerEvent.EXP_CHANGED, __expChangeHandler);
			
			DisposeUtil.free(m_icon, false);
			m_icon = null;
			
			DisposeUtil.free(m_progress, false);
			m_progress = null;
			
			DisposeUtil.free(m_lvLabel);
			m_lvLabel = null;
			
			super.dispose();
		}
	}
}