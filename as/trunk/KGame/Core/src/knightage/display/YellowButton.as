package knightage.display
{
	import flash.filters.GlowFilter;
	import flash.text.StyleSheet;
	import flash.text.TextFormat;
	
	import jsion.Insets;
	import jsion.display.Image;
	import jsion.display.LabelButton;
	
	public class YellowButton extends LabelButton
	{
		private static const LabelColor:uint = 0xFFFFFF;
		private static const UpImageBMD:YellowButtonUpAsset = new YellowButtonUpAsset(0, 0);
		
		public static const DefaultStyle:StyleSheet = new StyleSheet();
		public static const DefaultTextFormat:TextFormat = new TextFormat(null, 15, null, true);
		public static const DefaultFilters:Array = [new GlowFilter(0x412419, 1, 4, 4, 8, 1)];
		
		private var m_txt:String;
		
		public function YellowButton(text:String = "Button")
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
			vOffset = -1;
			styleSheet = DefaultStyle;
			textFormat = DefaultTextFormat;
			labelUpFilters = DefaultFilters;
			labelOverFilters = DefaultFilters;
			labelDownFilters = DefaultFilters;
			commitChanges();
		}
	}
}