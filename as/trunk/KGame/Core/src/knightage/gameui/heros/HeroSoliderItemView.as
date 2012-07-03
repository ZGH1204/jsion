package knightage.gameui.heros
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import jsion.IDispose;
	import jsion.utils.DisposeUtil;
	
	import knightage.StaticRes;
	import knightage.display.BlueButton;
	
	public class HeroSoliderItemView extends Sprite implements IDispose
	{
		private var m_background:DisplayObject;
		
		private var m_transferButton:BlueButton;
		
		public function HeroSoliderItemView()
		{
			super();
			
			initialized();
		}
		
		private function initialized():void
		{
			// TODO Auto Generated method stub
			m_background = new Bitmap(StaticRes.HeroSoliderBackgroundBMD);
			addChild(m_background);
			
			m_transferButton = new BlueButton();
			m_transferButton.beginChanges();
			m_transferButton.width = 74;
			m_transferButton.height = 36;
			m_transferButton.label = "转 职";
			m_transferButton.textFormat = StaticRes.HaiBaoEmbedTextFormat15;
			m_transferButton.labelUpFilters = StaticRes.TextFilters4;
			m_transferButton.labelOverFilters = StaticRes.TextFilters4;
			m_transferButton.labelDownFilters = StaticRes.TextFilters4;
			m_transferButton.commitChanges();
			addChild(m_transferButton);
			
			
			m_background.x = 0;
			m_background.y = 0;
			
			m_transferButton.x = m_background.x + (m_background.width - m_transferButton.width) / 2;
			m_transferButton.y = m_background.y + m_background.height;
		}
		
		public function dispose():void
		{
			DisposeUtil.free(m_background, false);
			m_background = null;
		}
	}
}