package knightage.homeui.topui
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	
	import jsion.utils.DisposeUtil;
	
	import knightage.StaticRes;

	public class PlayerCoinView extends InfoView
	{
		public function PlayerCoinView()
		{
			super(1);
		}
		
		override protected function initialized():void
		{
			super.initialized();
			
			m_icon = new Bitmap(StaticRes.CoinIcon);
			addChild(m_icon);
			
			m_icon.x = 6;
			m_icon.y = 4;
		}
		
		override public function dispose():void
		{
			DisposeUtil.free(m_icon, false);
			m_icon = null;
			
			super.dispose();
		}
	}
}