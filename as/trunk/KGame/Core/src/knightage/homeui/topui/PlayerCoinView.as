package knightage.homeui.topui
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	
	import jsion.display.ProgressBar;
	import jsion.utils.DisposeUtil;
	
	import knightage.StaticRes;
	import knightage.events.PlayerEvent;
	import knightage.mgrs.PlayerMgr;

	public class PlayerCoinView extends InfoView
	{
		private var m_progress:ProgressBar;
		
		public function PlayerCoinView()
		{
			super(1);
		}
		
		override protected function initialized():void
		{
			super.initialized();
			
			m_icon = new Bitmap(StaticRes.CoinsIcon);
			addChild(m_icon);
			
			m_progress = new ProgressBar();
			m_progress.beginChanges();
			m_progress.freeBMD = false;
			m_progress.progressBar = new Bitmap(StaticRes.ProgressBarBMD);
			m_progress.maxValue = PlayerMgr.self.coinsLimit;
			m_progress.value = PlayerMgr.self.coins;
			m_progress.commitChanges();
			addChild(m_progress);
			
			m_icon.x = 6;
			m_icon.y = 4;
			
			m_progress.x = 46;
			m_progress.y = 15;
			
			PlayerMgr.addEventListener(PlayerEvent.COIN_CHANGED, __coinChangedHandler);
		}
		
		private function __coinChangedHandler(e:PlayerEvent):void
		{
			// TODO Auto Generated method stub
			
			m_progress.beginChanges();
			m_progress.maxValue = PlayerMgr.self.coinsLimit;
			m_progress.value = PlayerMgr.self.coins;
			m_progress.commitChanges();
		}
		
		override public function dispose():void
		{
			PlayerMgr.removeEventListener(PlayerEvent.COIN_CHANGED, __coinChangedHandler);
			
			DisposeUtil.free(m_icon, false);
			m_icon = null;
			
			DisposeUtil.free(m_progress, false);
			m_progress = null;
			
			super.dispose();
		}
	}
}