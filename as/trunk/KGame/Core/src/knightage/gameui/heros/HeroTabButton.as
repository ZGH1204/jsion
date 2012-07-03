package knightage.gameui.heros
{
	import flash.display.DisplayObject;
	
	import jsion.display.ToggleButton;
	
	public class HeroTabButton extends ToggleButton
	{
		private var m_type:int;
		private var m_asset:DisplayObject;
		private var m_selectedAsset:DisplayObject;
		
		public function HeroTabButton(asset:DisplayObject, selectedAsset:DisplayObject)
		{
			m_asset = asset;
			
			m_selectedAsset = selectedAsset;
			
			super();
		}
		
		override protected function configUI():void
		{
			beginChanges();
			
			freeBMD = true;
			upImage = m_asset;
			selectedUpImage = m_selectedAsset;
			overFilters = [];
			selectedOverFilters = [];
			
			commitChanges();
		}
	}
}