package knightage.display
{
	import jsion.Insets;
	import jsion.display.Image;
	import jsion.display.LabelButton;
	
	import knightage.StaticRes;
	
	public class RedButton extends LabelButton
	{
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