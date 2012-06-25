package knightage.homeui.bottomui
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import jsion.IDispose;
	import jsion.display.Label;
	import jsion.utils.DisposeUtil;
	
	import knightage.StaticRes;
	import knightage.homeui.LevelView;
	
	public class RelationListItemView extends Sprite implements IDispose
	{
		private var m_background:DisplayObject;
		
		private var m_levelView:LevelView;
		
		public function RelationListItemView()
		{
			super();
			
			initialized();
		}
		
		private function initialized():void
		{
			// TODO Auto Generated method stub
			m_background = new Bitmap(StaticRes.RelationItemBackgroundBMD);
			addChild(m_background);
			
			m_levelView = new LevelView(12, LevelView.BOTTOM);
			addChild(m_levelView);
			
			
			m_background.x = 0;
			m_background.y = 0;
			
			m_levelView.x = m_background.x;
			m_levelView.y = m_background.y;
		}
		
		public function dispose():void
		{
			DisposeUtil.free(m_background, false);
			m_background = null;
			
			DisposeUtil.free(m_levelView);
			m_levelView = null;
		}
	}
}