package knightage.gameui.heros
{
	import flash.display.Bitmap;
	
	import jsion.display.IconToggleButton;
	
	import knightage.StaticRes;
	
	public class HeroListItemView extends IconToggleButton
	{
		public function HeroListItemView()
		{
			super();
		}
		
		override protected function configUI():void
		{
			beginChanges();
			
			freeBMD = false;
			var bmp:Bitmap = new Bitmap(StaticRes.HeroListItemBGBMD);
			upImage = bmp;
			selectedUpImage = bmp;
			selectedUpFilters = StaticRes.ButtonDefaultSelectedUpFilters;
			selectedOverFilters = StaticRes.ButtonDefaultSelectedOverFilters;
			
			commitChanges();
		}
	}
}