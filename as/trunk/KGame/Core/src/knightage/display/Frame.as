package knightage.display
{
	import flash.display.Bitmap;
	
	import jsion.Insets;
	import jsion.display.Image;
	import jsion.display.TitleWindow;
	
	public class Frame extends TitleWindow
	{
		private static const TitleBackgroundBMD:FrameTitleBGAsset = new FrameTitleBGAsset(0, 0);
		private static const FrameBackgroundBMD:FrameBackgroundAsset = new FrameBackgroundAsset(0, 0);
		private static const FrameCloseUpBMD:FrameCloseUpAsset = new FrameCloseUpAsset(0, 0);
		
		private var m_t:String;
		
		public function Frame(title:String = "窗口标题", modal:Boolean = true)
		{
			m_t = title;
			
			super(modal);
		}
		
		override protected function configUI():void
		{
			freeBMD = false;
			
			var img:Image = new Image();
			img.beginChanges();
			img.freeSource = false;
			img.source = FrameBackgroundBMD;
			img.scale9Insets = new Insets(100, 100, 90, 90);
			img.commitChanges();
			
			beginChanges();
			
			titleText = m_t;
			titleVOffset = -2;
			
			background = img;
			titleBackground = new Bitmap(TitleBackgroundBMD);
			titleBarVOffset = -20;
			closeUpImage = new Bitmap(FrameCloseUpBMD);
			closeHOffset = -3;
			closeVOffset = -2;
			
			width = 550;
			height = 400;
			
			contentOffsetX = 50;
			contentOffsetY = 35;
			
			commitChanges();
		}
		
		public function setContentSize(w:int, h:int):void
		{
			w = w + contentOffsetX * 2;
			h = h + contentOffsetY * 2;
			
			width = w + w % 2;
			height = h + h % 2;
		}
	}
}