package knightage.homeui.topui.items
{
	import flash.display.Bitmap;
	
	import jsion.display.Label;
	import jsion.utils.DisposeUtil;
	
	import knightage.StaticRes;
	import knightage.events.PlayerEvent;
	import knightage.mgrs.PlayerMgr;

	public class PlayerSoliderView extends InfoView
	{
		private var m_numLabel:Label;
		
		public function PlayerSoliderView()
		{
			super(2);
		}
		
		override protected function initialized():void
		{
			super.initialized();
			
			m_icon = new Bitmap(StaticRes.SolidersIcon);
			addChild(m_icon);
			
			m_numLabel = new Label();
			m_numLabel.beginChanges();
			m_numLabel.text = PlayerMgr.self.soliders.toString();
			m_numLabel.filters = StaticRes.TextFilters4;
			m_numLabel.textColor = StaticRes.WhiteColor;
			m_numLabel.textFormat = StaticRes.TextFormat15;
			m_numLabel.commitChanges();
			addChild(m_numLabel);
			
			m_background.x = m_icon.width - 19;
			m_background.y = 7;
			
			refreshNumLabelPos();
			
			PlayerMgr.addEventListener(PlayerEvent.SOLIDER_CHANGED, __soliderChangedHandler);
		}
		
		private function __soliderChangedHandler(e:PlayerEvent):void
		{
			// TODO Auto Generated method stub
			
			m_numLabel.text = PlayerMgr.self.soliders.toString();
			
			refreshNumLabelPos();
		}
		
		private function refreshNumLabelPos():void
		{
			m_numLabel.x = width - m_numLabel.width - 10;
			m_numLabel.y = m_background.y + (m_background.height - m_numLabel.height) / 2 - 2;
		}
		
		override public function dispose():void
		{
			PlayerMgr.removeEventListener(PlayerEvent.SOLIDER_CHANGED, __soliderChangedHandler);
			
			DisposeUtil.free(m_icon, false);
			m_icon = null;
			
			DisposeUtil.free(m_numLabel);
			m_numLabel = null;
			
			super.dispose();
		}
	}
}