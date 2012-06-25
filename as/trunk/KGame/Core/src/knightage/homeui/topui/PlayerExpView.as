package knightage.homeui.topui
{
	import flash.display.Bitmap;
	
	import jsion.display.Label;
	import jsion.utils.DisposeUtil;
	
	import knightage.StaticRes;
	import knightage.mgrs.PlayerMgr;

	public class PlayerExpView extends InfoView
	{
		private var m_lvLabel:Label;
		
		public function PlayerExpView()
		{
			super(1);
		}
		
		override protected function initialized():void
		{
			super.initialized();
			
			m_icon = new Bitmap(StaticRes.LvIcon);
			addChild(m_icon);
			
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
			
			m_lvLabel.x = m_icon.x + (m_icon.width - m_lvLabel.width) / 2;
			m_lvLabel.y = m_icon.y + 3;
		}
		
		override public function dispose():void
		{
			DisposeUtil.free(m_icon, false);
			m_icon = null;
			
			DisposeUtil.free(m_lvLabel);
			m_lvLabel = null;
			
			super.dispose();
		}
	}
}