package jsion.view
{
	import com.utils.DisposeHelper;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import jsion.BitmapDataMgr;

	public class AlbumsBackcPage extends AlbumsPhotoPage
	{
		public function AlbumsBackcPage()
		{
		}
		
		override protected function setPagePos(isLeft:Boolean):void
		{
			if(_albums)
			{
				this.x = _albums.backcPageX;
				this.y = _albums.backcPageY;
			}
		}
		
		override protected function setBackground():void
		{
			DisposeHelper.dispose(_bg, false);
			_bg = null;
			
			if(_albums)
			{
				var bmd:BitmapData = BitmapDataMgr.Instance.getBitmapData(_albums.slovePath(_albums.backcPage));
				
				if(bmd) _bg = new Bitmap(bmd);
				if(_bg) addChild(_bg);
			}
		}
		
		override protected function setDataView():void
		{
			DisposeHelper.dispose(_photoLayer);
			_photoLayer = new BackcLayer();
			_photoLayer.photoPage = _photoPage;
			addChild(_photoLayer);
		}
	}
}