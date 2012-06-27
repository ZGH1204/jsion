package knightage.display
{
	import jsion.Insets;
	import jsion.display.Image;
	import jsion.display.LabelButton;
	
	public class KhakiButton extends LabelButton
	{
		public static const LabelColor:uint = 0xFFFFFF;
		public static const UpImageBMD:KhakiButtonUpAsset = new KhakiButtonUpAsset(0, 0);
		public static const ScaleInsets:Insets = new Insets(20, 30, 20, 30);
		
		private var m_txt:String;
		
		public function KhakiButton(text:String = "Button")
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
			img.scale9Insets = ScaleInsets;
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