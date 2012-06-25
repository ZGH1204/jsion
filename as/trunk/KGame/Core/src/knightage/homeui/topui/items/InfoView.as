package knightage.homeui.topui.items
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import jsion.IDispose;
	import jsion.utils.DisposeUtil;
	
	public class InfoView extends Sprite implements IDispose
	{
		public static const ProgressBG:int = 1;
		
		public static const InfoBG:int = 2;
		
		private static const TopUIBackground1:InfoBackground1 = new InfoBackground1(0, 0);
		private static const TopUIBackground2:InfoBackground2 = new InfoBackground2(0, 0);
		
		protected var m_backgroundType:int;
		
		protected var m_icon:DisplayObject;
		
		protected var m_background:DisplayObject;
		
		public function InfoView(backgroundType:int = 1)
		{
			m_backgroundType = backgroundType;
			
			initialized();
		}
		
		protected function initialized():void
		{
			if(m_backgroundType == ProgressBG)
			{
				m_background = new Bitmap(TopUIBackground1);
			}
			else
			{
				m_background = new Bitmap(TopUIBackground2);
			}
			
			addChild(m_background);
		}
		
		public function dispose():void
		{
			DisposeUtil.free(m_background, false);
			m_background = null;
		}
	}
}