package jcomponent.org.coms.images
{
	import flash.display.BitmapData;
	
	import jcomponent.org.basic.DefaultConfigKeys;
	
	public class ScaleImageTile extends AbstractImage
	{
		public function ScaleImageTile(bmd:BitmapData, scaleInset:Insets=null, id:String=null)
		{
			super(bmd, scaleInset, id);
		}
		
		override public function getUIDefaultBasicClass():Class
		{
			return ScaleImageTileUI;
		}
		
		override protected function getUIDefaultClassID():String
		{
			return DefaultConfigKeys.SCALE_IMAGE_TILE_UI;
		}
	}
}