package knightage.display
{
	import jsion.Insets;
	import jsion.display.Image;
	import jsion.display.LabelButton;
	
	public class RedButton extends LabelButton
	{
		private static const LabelColor:uint = 0xFFFFFF;
		private static const UpImageBMD:RedButtonUpAsset = new RedButtonUpAsset(0, 0);
		
		private var m_txt:String;
		
		public function RedButton(text:String = "Button")
		{
			m_txt = text;
			super();
		}
		
		override protected function configUI():void
		{
			var img:Image = new Image();
			
			img.beginChanges();
			img.freeSource = false;
			img.source = UpImageBMD;
			img.scale9Insets = new Insets(15, 20, 15, 20);
			img.commitChanges();
			
			beginChanges();
			upImage = img;
			label = m_txt;
			labelColor = LabelColor;
			styleSheet = YellowButton.DefaultStyle;
			textFormat = YellowButton.DefaultTextFormat;
			commitChanges();
		}
	}
}