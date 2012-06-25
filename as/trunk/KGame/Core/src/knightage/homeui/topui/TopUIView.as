package knightage.homeui.topui
{
	import flash.display.Sprite;
	
	import jsion.IDispose;
	import jsion.utils.DisposeUtil;
	import knightage.homeui.topui.items.PlayerCoinView;
	import knightage.homeui.topui.items.PlayerExpView;
	import knightage.homeui.topui.items.PlayerFoodView;
	import knightage.homeui.topui.items.PlayerGoldView;
	import knightage.homeui.topui.items.PlayerOrdersView;
	import knightage.homeui.topui.items.PlayerSoliderView;
	
	public class TopUIView extends Sprite implements IDispose
	{
		private static const OffsetY:int = 5;
		private static const PADDING:int = 6;
		
		private var m_playerExpView:PlayerExpView;
		
		private var m_playerCoinView:PlayerCoinView;
		
		private var m_playerGoldView:PlayerGoldView;
		
		private var m_playerSoliderView:PlayerSoliderView;
		
		private var m_playerFoodView:PlayerFoodView;
		
		private var m_playerOrderView:PlayerOrdersView;
		
		public function TopUIView()
		{
			super();
			
			initialized();
		}
		
		private function initialized():void
		{
			m_playerExpView = new PlayerExpView();
			addChild(m_playerExpView);
			m_playerExpView.y = OffsetY;
			
			m_playerCoinView = new PlayerCoinView();
			addChild(m_playerCoinView);
			m_playerCoinView.x = m_playerExpView.x + m_playerExpView.width + PADDING;
			m_playerCoinView.y = OffsetY;
			
			m_playerGoldView = new PlayerGoldView();
			addChild(m_playerGoldView);
			m_playerGoldView.x = m_playerCoinView.x + m_playerCoinView.width + PADDING;
			m_playerGoldView.y = OffsetY + 5;
			
			m_playerSoliderView = new PlayerSoliderView();
			addChild(m_playerSoliderView);
			m_playerSoliderView.x = m_playerGoldView.x + m_playerGoldView.width + PADDING;
			m_playerSoliderView.y = OffsetY;
			
			m_playerFoodView = new PlayerFoodView();
			addChild(m_playerFoodView);
			m_playerFoodView.x = m_playerSoliderView.x + m_playerSoliderView.width + PADDING;
			m_playerFoodView.y = OffsetY;
			
			m_playerOrderView = new PlayerOrdersView();
			addChild(m_playerOrderView);
			m_playerOrderView.x = m_playerFoodView.x + m_playerFoodView.width + PADDING;
			m_playerOrderView.y = OffsetY;
		}
		
		public function dispose():void
		{
			DisposeUtil.free(m_playerExpView);
			m_playerExpView = null;
			
			DisposeUtil.free(m_playerCoinView);
			m_playerCoinView = null;
			
			DisposeUtil.free(m_playerGoldView);
			m_playerGoldView = null;
			
			DisposeUtil.free(m_playerSoliderView);
			m_playerSoliderView = null;
			
			DisposeUtil.free(m_playerFoodView);
			m_playerFoodView = null;
			
			DisposeUtil.free(m_playerOrderView);
			m_playerOrderView = null;
		}
	}
}