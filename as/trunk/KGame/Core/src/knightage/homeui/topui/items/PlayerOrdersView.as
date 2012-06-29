package knightage.homeui.topui.items
{
	import flash.display.Bitmap;
	
	import jsion.display.Label;
	import jsion.display.ProgressBar;
	import jsion.utils.DisposeUtil;
	
	import knightage.StaticRes;
	import knightage.events.PlayerEvent;
	import knightage.mgrs.PlayerMgr;

	public class PlayerOrdersView extends InfoView
	{
		private var m_numLabel:Label;
		
		private var m_progress:ProgressBar;
		
		public function PlayerOrdersView()
		{
			super(2);
		}
		
		override protected function initialized():void
		{
			super.initialized();
			
			
			m_icon = new Bitmap(StaticRes.OrderIcon);
			m_icon.y = -5;
			addChild(m_icon);
			
			m_progress = new ProgressBar();
			m_progress.beginChanges();
			m_progress.freeBMD = true;
			m_progress.background = new Bitmap(new OrdersProgressBGAsset(0, 0));
			m_progress.progressBar = new Bitmap(new OrdersProgressBarAsset(0, 0));
			m_progress.maxValue = PlayerMgr.self.ordersLimit;
			m_progress.value = PlayerMgr.self.orders;
			m_progress.commitChanges();
			addChild(m_progress);
			
			m_numLabel = new Label();
			m_numLabel.beginChanges();
			m_numLabel.text = PlayerMgr.self.orders.toString();
			m_numLabel.filters = StaticRes.TextFilters4;
			m_numLabel.textColor = StaticRes.WhiteColor;
			m_numLabel.textFormat = StaticRes.TextFormat15;
			m_numLabel.commitChanges();
			addChild(m_numLabel);
			
			m_progress.x = 33;
			m_progress.y = 10;
			
			m_background.x = m_icon.width - 19;
			m_background.y = 7;
			
			refreshNumLabelPos();
			
			PlayerMgr.addEventListener(PlayerEvent.ORDER_CHANGED, __ordersChangedHandler);
		}
		
		private function __ordersChangedHandler(e:PlayerEvent):void
		{
			// TODO Auto Generated method stub
			
			m_progress.beginChanges();
			m_progress.maxValue = PlayerMgr.self.ordersLimit;
			m_progress.value = PlayerMgr.self.orders;
			m_progress.commitChanges();
			
			m_numLabel.text = PlayerMgr.self.orders.toString();
			
			refreshNumLabelPos();
		}
		
		private function refreshNumLabelPos():void
		{
			m_numLabel.x = m_progress.x + (m_progress.width - m_numLabel.width) / 2;
			m_numLabel.y = m_progress.y + (m_progress.height - m_numLabel.height) / 2;
		}
		
		override public function dispose():void
		{
			PlayerMgr.removeEventListener(PlayerEvent.ORDER_CHANGED, __ordersChangedHandler);
			
			DisposeUtil.free(m_icon, false);
			m_icon = null;
			
			DisposeUtil.free(m_numLabel);
			m_numLabel = null;
			
			DisposeUtil.free(m_progress);
			m_progress = null;
			
			super.dispose();
		}
	}
}