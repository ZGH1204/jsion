package knightage.homeui.topui
{
	import flash.display.Bitmap;
	
	import jsion.display.Label;
	import jsion.utils.DisposeUtil;
	
	import knightage.StaticRes;
	import knightage.display.YellowButton;
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
			m_numLabel.text = PlayerMgr.self.coins.toString();
			m_numLabel.filters = StaticRes.TopUINumFilters;
			m_numLabel.textColor = StaticRes.TopUINumColor;
			m_numLabel.textFormat = StaticRes.TopUINumTextFormat;
			m_numLabel.commitChanges();
			addChild(m_numLabel);
			
			
			
			m_selectBtn = new YellowButton("查询");
			m_selectBtn.beginChanges();
			m_selectBtn.width = 60;
			m_selectBtn.height = 36;
			m_selectBtn.enabled = false;
			m_selectBtn.commitChanges();
			addChild(m_selectBtn);
			
			
			
			m_background.x = m_icon.width - 12;
			m_background.y = 2;
			
			m_numLabel.x = width - m_numLabel.width - 10;
			m_numLabel.y = m_background.y + (m_background.height - m_numLabel.height) / 2 - 2;
			
			m_selectBtn.x = m_background.x + m_background.width;
		}
		
		override public function dispose():void
		{
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