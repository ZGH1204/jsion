package jsion.view
{
	import com.utils.DisposeHelper;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import jsion.BitmapDataMgr;

	public class AlbumsCoverPage extends AlbumsPhotoPage
	{
		public function AlbumsCoverPage()
		{
		}
		
		override protected function setPagePos(isLeft:Boolean):void
		{
			if(_albums)
			{
				this.x = _albums.coverPageX;
				this.y = _albums.coverPageY;
			}
		}
		
		override protected function setBackground():void
		{
			DisposeHelper.dispose(_bg, false);
			_bg = null;
			
			if(_albums)
			{
				var bmd:BitmapData = BitmapDataMgr.Instance.getBitmapData(_albums.slovePath(_albums.coverPage));
				
				if(bmd) _bg = new Bitmap(bmd);
				if(_bg) addChild(_bg);
			}
		}
		
		override protected function setDataView():void
		{
			DisposeHelper.dispose(_photoLayer);
			_photoLayer = new CoverLayer();
			_photoLayer.photoPage = _photoPage;
			addChild(_photoLayer);
		}
	}
}