package knightage.homeui.topui.items
{
	import flash.display.Bitmap;
	import flash.filters.ColorMatrixFilter;
	import flash.text.TextFormat;
	
	import jsion.display.Label;
	import jsion.utils.DisposeUtil;
	
	import knightage.StaticRes;
	import knightage.display.YellowButton;
	import knightage.events.PlayerEvent;
	import knightage.mgrs.PlayerMgr;

	public class PlayerGoldView extends InfoView
	{
		private var m_numLabel:Label;
		
		private var m_selectBtn:YellowButton;
		
		public function PlayerGoldView()
		{
			super(2);
		}
		
		override protected function initialized():void
		{
			super.initialized();
			
			
			m_icon = new Bitmap(StaticRes.GoldsIcon);
			addChild(m_icon);
			
			m_numLabel = new Label();
			m_numLabel.beginChanges();
			m_numLabel.text = PlayerMgr.self.gold.toString();
			m_numLabel.filters = StaticRes.TextFilters4;
			m_numLabel.textColor = StaticRes.WhiteColor;
			m_numLabel.textFormat = StaticRes.TextFormat15;
			m_numLabel.commitChanges();
			addChild(m_numLabel);
			
			
			
			m_selectBtn = new YellowButton("查询");
			m_selectBtn.beginChanges();
			m_selectBtn.width = 52;
			m_selectBtn.height = 35;
			//m_selectBtn.enabled = false;
			m_selectBtn.embedFonts = true;
			m_selectBtn.textFormat = new TextFormat("MyFont1", 16, null, true);
			m_selectBtn.labelUpFilters = StaticRes.TextFilters8;
			m_selectBtn.labelOverFilters = StaticRes.TextFilters8;
			m_selectBtn.labelDownFilters = StaticRes.TextFilters8;
			m_selectBtn.commitChanges();
			addChild(m_selectBtn);
			
			
			
			m_background.x = m_icon.width - 17;
			m_background.y = 2;
			
			refreshNumLabelPos();
			
			m_selectBtn.x = m_background.x + m_background.width;
			
			PlayerMgr.addEventListener(PlayerEvent.GOLD_CHANGED, __goldChangedHandler);
		}
		
		private function __goldChangedHandler(e:PlayerEvent):void
		{
			// TODO Auto Generated method stub
			
			m_numLabel.text = PlayerMgr.self.gold.toString();
			
			refreshNumLabelPos();
		}
		
		private function refreshNumLabelPos():void
		{
			m_numLabel.x = width - m_numLabel.width - 10;
			m_numLabel.y = m_background.y + (m_background.height - m_numLabel.height) / 2 - 2;
		}
		
		override public function dispose():void
		{
			PlayerMgr.removeEventListener(PlayerEvent.GOLD_CHANGED, __goldChangedHandler);
			
			DisposeUtil.free(m_icon, false);
			m_icon = null;
			
			DisposeUtil.free(m_numLabel);
			m_numLabel = null;
			
			DisposeUtil.free(m_selectBtn);
			m_selectBtn = null;
			
			super.dispose();
		}
	}
}