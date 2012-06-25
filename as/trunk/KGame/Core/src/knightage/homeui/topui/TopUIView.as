package knightage.homeui.topui
{
	import flash.display.Sprite;
	
	import jsion.IDispose;
	import jsion.utils.DisposeUtil;
	
	public class TopUIView extends Sprite implements IDispose
	{
		private static const OFFSET:int = 10;
		
		private var m_playerExpView:PlayerExpView;
		
		private var m_playerCoinView:PlayerCoinView;
		
		private var m_playerGoldView:PlayerGoldView;
		
		private var m_playerSoliderView:PlayerSoliderView;
		
		private var m_playerFoodView:PlayerFoodView;
		
		public function TopUIView()
		{
			super();
			
			initialized();
		}
		
		private function initialized():void
		{
			m_playerExpView = new PlayerExpView();
			addChild(m_playerExpView);
			
			m_playerCoinView = new PlayerCoinView();
			addChild(m_playerCoinView);
			m_playerCoinView.x = m_playerExpView.x + m_playerExpView.width + OFFSET;
			
			m_playerGoldView = new PlayerGoldView();
			addChild(m_playerGoldView);
			m_playerGoldView.x = m_playerCoinView.x + m_playerCoinView.width + OFFSET;
			m_playerGoldView.y = 5;
			
			m_playerSoliderView = new PlayerSoliderView();
			addChild(m_playerSoliderView);
			m_playerSoliderView.x = m_playerGoldView.x + m_playerGoldView.width + OFFSET;
			
			m_playerFoodView = new PlayerFoodView();
			addChild(m_playerFoodView);
			m_playerFoodView.x = m_playerSoliderView.x + m_playerSoliderView.width + OFFSET;
		}
		
		public function dispose():void
		{
			DisposeUtil.free(m_playerExpView);
			m_playerExpView = null;
			
			DisposeUtil.free(m_playerCoinView);
			m_playerCoinView = null;
			
			DisposeUtil.free(m_playerGoldView);
			m_playerGoldView = null;
		}
	}
}