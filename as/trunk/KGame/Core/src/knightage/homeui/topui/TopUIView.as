package knightage.homeui.topui
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import jsion.IDispose;
	import jsion.display.Button;
	import jsion.utils.DisposeUtil;
	
	import knightage.StaticRes;
	import knightage.events.VisitEvent;
	import knightage.homeui.topui.items.PlayerCoinView;
	import knightage.homeui.topui.items.PlayerExpView;
	import knightage.homeui.topui.items.PlayerFoodView;
	import knightage.homeui.topui.items.PlayerGoldView;
	import knightage.homeui.topui.items.PlayerOrdersView;
	import knightage.homeui.topui.items.PlayerSoliderView;
	import knightage.mgrs.MsgTipMgr;
	import knightage.mgrs.VisitMgr;
	
	public class TopUIView extends Sprite implements IDispose
	{
		private static const OffsetY:int = 5;
		private static const PADDING:int = 6;
		
		private static const ButtonPadding:int = 16;
		
		private var m_playerExpView:PlayerExpView;
		
		private var m_playerCoinView:PlayerCoinView;
		
		private var m_playerGoldView:PlayerGoldView;
		
		private var m_playerSoliderView:PlayerSoliderView;
		
		private var m_playerFoodView:PlayerFoodView;
		
		private var m_playerOrderView:PlayerOrdersView;
		
		private var m_messageButton:Button;
		
		private var m_noticeButton:Button;
		
		private var m_giftButton:Button;
		
		public function TopUIView()
		{
			super();
			
			initialized();
		}
		
		private function initialized():void
		{
			m_playerExpView = new PlayerExpView();
			addChild(m_playerExpView);
			m_playerExpView.x = 8;
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
			
			
			
			
			m_messageButton = new Button();
			m_messageButton.clickSoundID = StaticRes.ButtonClickSoundID;
			m_messageButton.freeBMD = true;
			m_messageButton.upImage = new Bitmap(new MessageIcon(0, 0));
			addChild(m_messageButton);
			m_messageButton.x = 570;
			m_messageButton.y = 50;
			
			m_noticeButton = new Button();
			m_noticeButton.clickSoundID = StaticRes.ButtonClickSoundID;
			m_noticeButton.freeBMD = true;
			m_noticeButton.upImage = new Bitmap(new NoticeIcon(0, 0));
			addChild(m_noticeButton);
			m_noticeButton.x = m_messageButton.x + m_messageButton.width + ButtonPadding;
			m_noticeButton.y = m_messageButton.y;
			
			m_giftButton = new Button();
			m_giftButton.clickSoundID = StaticRes.ButtonClickSoundID;
			m_giftButton.freeBMD = true;
			m_giftButton.upImage = new Bitmap(new GiftIcon(0, 0));
			addChild(m_giftButton);
			m_giftButton.x = m_noticeButton.x + m_noticeButton.width + ButtonPadding;
			m_giftButton.y = m_noticeButton.y;
			
			
			
			
			m_messageButton.addEventListener(MouseEvent.CLICK, __messageClickHandler);
			m_noticeButton.addEventListener(MouseEvent.CLICK, __noticeClickHandler);
			m_giftButton.addEventListener(MouseEvent.CLICK, __giftClickHandler);
			
			
			
			VisitMgr.addEventListener(VisitEvent.VISIT_FRIEND, __visitFriendHandler);
		}
		
		private function __messageClickHandler(e:MouseEvent):void
		{
			MsgTipMgr.show("留言功能开发中...");
		}
		
		private function __noticeClickHandler(e:MouseEvent):void
		{
			MsgTipMgr.show("公告功能开发中...");
		}
		
		private function __giftClickHandler(e:MouseEvent):void
		{
			MsgTipMgr.show("礼物功能开发中...");
		}
		
		private function __visitFriendHandler(e:VisitEvent):void
		{
			// TODO Auto Generated method stub
			
			visible = VisitMgr.isSelf;
		}
		
		public function dispose():void
		{
			VisitMgr.removeEventListener(VisitEvent.VISIT_FRIEND, __visitFriendHandler);
			
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
			
			DisposeUtil.free(m_messageButton);
			m_messageButton = null;
			
			DisposeUtil.free(m_noticeButton);
			m_noticeButton = null;
			
			DisposeUtil.free(m_giftButton);
			m_giftButton = null;
		}
	}
}