package knightage.display
{
	import jsion.Insets;
	import jsion.display.Image;
	import jsion.display.LabelButton;
	
	import knightage.StaticRes;
	
	public class KhakiButton extends LabelButton
	{
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
			labelColor = StaticRes.WhiteColor;
			styleSheet = StaticRes.ButtonDefaultStyle;
			textFormat = StaticRes.ButtonDefaultTextFormat;
			labelUpFilters = StaticRes.ButtonDefaultFilters;
			labelOverFilters = StaticRes.ButtonDefaultFilters;
			labelDownFilters = StaticRes.ButtonDefaultFilters;
			commitChanges();
		}
	}
}