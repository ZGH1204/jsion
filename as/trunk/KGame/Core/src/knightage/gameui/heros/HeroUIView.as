package knightage.gameui.heros
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	
	import jsion.utils.InstanceUtil;
	
	import knightage.display.Frame;
	
	public class HeroUIView extends Frame
	{
		private var m_titleIcon:DisplayObject;
		
		private var m_heroInfoView:HeroInfoView;
		
		public function HeroUIView()
		{
			super("", false);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			
			m_titleIcon = new Bitmap(new HeroTitleIconAsset(0, 0));
			
			
			beginChanges();
			
			width = 700;
			height = 550;
			
			contentOffsetX = 30;
			contentOffsetY = 30;
			
			titleView = m_titleIcon;
			titleVOffset = -8;
			
			commitChanges();
			
			
			
			m_heroInfoView = new HeroInfoView();
			
			addToContent(m_heroInfoView);
		}
		
		override public function dispose():void
		{
			InstanceUtil.removeSingletion(HeroUIView);
			
			super.dispose();
		}
	}
}