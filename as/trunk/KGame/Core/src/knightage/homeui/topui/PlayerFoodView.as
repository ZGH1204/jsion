package knightage.homeui.topui
{
	import flash.display.Bitmap;
	
	import jsion.display.Label;
	import jsion.utils.DisposeUtil;
	
	import knightage.StaticRes;
	import knightage.mgrs.PlayerMgr;

	public class PlayerFoodView extends InfoView
	{
		private var m_numLabel:Label;
		
		public function PlayerFoodView()
		{
			super(2);
		}
		
		override protected function initialized():void
		{
			super.initialized();
			
			
			m_icon = new Bitmap(StaticRes.FoodsIcon);
			addChild(m_icon);
			
			m_numLabel = new Label();
			m_numLabel.beginChanges();
			m_numLabel.text = PlayerMgr.self.foods.toString();
			m_numLabel.filters = StaticRes.TopUINumFilters;
			m_numLabel.textColor = StaticRes.TopUINumColor;
			m_numLabel.textFormat = StaticRes.TopUINumTextFormat;
			m_numLabel.commitChanges();
			addChild(m_numLabel);
			
			m_background.x = m_icon.width - 14;
			m_background.y = 7;
			
			m_numLabel.x = width - m_numLabel.width - 10;
			m_numLabel.y = m_background.y + (m_background.height - m_numLabel.height) / 2 - 2;
		}
		
		override public function dispose():void
		{
			DisposeUtil.free(m_icon, false);
			m_icon = null;
			
			DisposeUtil.free(m_numLabel);
			m_numLabel = null;
			
			super.dispose();
		}
	}
}