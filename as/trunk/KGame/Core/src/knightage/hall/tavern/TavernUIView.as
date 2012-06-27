package knightage.hall.tavern
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import jsion.display.ProgressBar;
	import jsion.utils.DisposeUtil;
	import jsion.utils.InstanceUtil;
	import jsion.utils.JUtil;
	
	import knightage.display.Frame;
	import knightage.mgrs.MsgTipMgr;
	
	public class TavernUIView extends Frame
	{
		private var m_titleIcon:DisplayObject;
		
		private var m_tavernBackground:DisplayObject;
		
		private var m_item1:TavernHeroInfoView;
		
		private var m_item2:TavernHeroInfoView;
		
		private var m_item3:TavernHeroInfoView;
		
		private var m_partyButton:PartyButton;
		
		private var m_grandPartyButton:PartyButton;
		
		private var m_progress:ProgressBar;
		
		private var m_countDown:CountDown;
		
		public function TavernUIView()
		{
			super("", false);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			
			m_tavernBackground = new Bitmap(new TavernBackgroundAsset(0, 0));
			
			addToContent(m_tavernBackground);
			
			var posY:int = 230;
			
			
			m_item1 = new TavernHeroInfoView();
			m_item1.x = 20;
			m_item1.y = posY;
			addToContent(m_item1);
			
			m_item2 = new TavernHeroInfoView();
			m_item2.y = posY;
			addToContent(m_item2);
			
			m_item3 = new TavernHeroInfoView();
			m_item3.y = posY;
			addToContent(m_item3);
			
			JUtil.layeroutOneByOneHorizontal(0, m_item1, m_item2, m_item3);
			
			
			
			
			
			
			
			beginChanges();
			contentOffsetX = 20;
			contentOffsetY = 17;
			titleBarVOffset = -27;
			setContentSize(m_tavernBackground.width, m_tavernBackground.height);
			m_titleIcon = new Bitmap(new TavernTitleIcon(0, 0));
			titleView = m_titleIcon;
			titleVOffset = -5;
			commitChanges();
			
			
			
			
			
			
			m_progress = new ProgressBar();
			m_progress.beginChanges();
			m_progress.x = 38;
			m_progress.y = 425;
			m_progress.value = 50;
			m_progress.freeBMD = true;
			m_progress.progressBar = new Bitmap(new LivelyBarAsset(0, 0));
			m_progress.commitChanges();
			addToContent(m_progress);
			
			
			
			m_countDown = new CountDown();
			m_countDown.x = 498;
			m_countDown.y = 423;
			m_countDown.setSeconds(5000);
			addToContent(m_countDown);
			
			
			
			
			m_partyButton = new PartyButton(PartyButton.Party);
			m_partyButton.x = 205;
			m_partyButton.y = 388;
			addToContent(m_partyButton);
			m_partyButton.setMoney(1000);
			
			m_grandPartyButton = new PartyButton(PartyButton.GrandParty);
			m_grandPartyButton.x = m_partyButton.x + m_partyButton.width + 3;
			m_grandPartyButton.y = m_partyButton.y;
			addToContent(m_grandPartyButton);
			m_grandPartyButton.setMoney(30);
			
			
			
			
			
			
			
			
			
			m_partyButton.addEventListener(MouseEvent.CLICK, __partyClickHandler);
			
			m_grandPartyButton.addEventListener(MouseEvent.CLICK, __grandPartyClickHandler);
		}
		
		private function __partyClickHandler(e:MouseEvent):void
		{
			MsgTipMgr.show("举行派对开发中...");
		}
		
		private function __grandPartyClickHandler(e:MouseEvent):void
		{
			MsgTipMgr.show("豪华派对开发中...");
		}
		
		
		
		
		
		public function setData():void
		{
			
		}
		
		
		
		
		override public function dispose():void
		{
			InstanceUtil.removeSingletion(TavernUIView);
			
			DisposeUtil.free(m_titleIcon);
			m_titleIcon = null;
			
			DisposeUtil.free(m_item1);
			m_item1 = null;
			
			DisposeUtil.free(m_item2);
			m_item2 = null;
			
			DisposeUtil.free(m_item3);
			m_item3 = null;
			
			super.dispose();
		}
	}
}