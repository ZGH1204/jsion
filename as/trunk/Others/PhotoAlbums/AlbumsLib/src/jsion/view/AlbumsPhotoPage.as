package jsion.view
{
	import com.interfaces.IDispose;
	import com.utils.DisposeHelper;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import jsion.BitmapDataMgr;
	import jsion.data.Albums;
	import jsion.data.PhotoPage;
	
	public class AlbumsPhotoPage extends Sprite implements IDispose
	{
		protected var _bg:DisplayObject;
		protected var _photoLayer:PhotoLayer;
		
		protected var _albums:Albums;
		protected var _photoPage:PhotoPage;
		protected var _isLeft:Boolean;
		
		public function AlbumsPhotoPage()
		{
		}
		
		public function get isLeft():Boolean
		{
			return _isLeft;
		}

		public function setData(albums:Albums, photoPage:PhotoPage, isLeft:Boolean):void
		{
			if(_albums == albums && _photoPage == photoPage) return;
			
			_albums = albums;
			_photoPage = photoPage;
			_isLeft = isLeft;
			
			if(_albums == null || _photoPage == null) return;
			
			setPagePos(isLeft);
			setBackground();
			setDataView();
			
			if(_albums.pageWidth <= 0 && _bg) _albums.pageWidth = _bg.width;
			if(_albums.pageHeight <= 0 && _bg) _albums.pageHeight = _bg.height;
			
//			graphics.clear();
//			graphics.beginFill(0x0, 0);
//			graphics.drawRect(0, 0, _albums.leftPageWidth, _albums.leftPageHeight);
//			graphics.endFill();
		}
		
		protected function setPagePos(isLeft:Boolean):void
		{
			if(_albums)
			{
				if(isLeft)
				{
					this.x = _albums.leftPageX;
					this.y = _albums.leftPageY;
				}
				else
				{
					this.x = _albums.rightPageX;
					this.y = _albums.rightPageY;
				}
			}
		}
		
		protected function setBackground():void
		{
			DisposeHelper.dispose(_bg, false);
			_bg = null;
			
			if(_albums)
			{
				var bmd:BitmapData;
				if(_isLeft)
					bmd = BitmapDataMgr.Instance.getBitmapData(_albums.slovePath(_albums.leftPage));
				else
					bmd = BitmapDataMgr.Instance.getBitmapData(_albums.slovePath(_albums.rightPage));
				
				if(bmd) _bg = new Bitmap(bmd);
				if(_bg) addChild(_bg);
			}
		}
		
		protected function setDataView():void
		{
			DisposeHelper.dispose(_photoLayer);
			_photoLayer = new PhotoLayer(_isLeft);
			_photoLayer.photoPage = _photoPage;
			addChild(_photoLayer);
		}
		
		private function uninitDataView():void
		{
			DisposeHelper.dispose(_bg, false);
			_bg = null;
			
			DisposeHelper.dispose(_photoLayer);
			_photoLayer = null;
		}
		
		override public function get width():Number
		{
			if(_isLeft)
			{
				if(_albums)
				{
					if(_albums.pageWidth <= 0 && _bg) _albums.pageWidth = _bg.width;
					return _albums.pageWidth;
				}
			}
			else
			{
				if(_albums)
				{
					if(_albums.pageWidth <= 0 && _bg) _albums.pageWidth = _bg.width;
					return _albums.pageWidth;
//					if(_albums.rightPageWidth <= 0 && _bg) _albums.rightPageWidth = _bg.width;
//					return _albums.rightPageWidth;
				}
			}
			
			return super.width;
		}
		
		override public function set width(value:Number):void
		{
			if(_isLeft)
			{
				if(_albums) _albums.pageWidth = value;
			}
			else
			{
				if(_albums) _albums.pageWidth = value;
			}
		}
		
		override public function get height():Number
		{
			if(_isLeft)
			{
				if(_albums)
				{
					if(_albums.pageHeight <= 0 && _bg) _albums.pageHeight = _bg.height;
					return _albums.pageHeight;
				}
			}
			else
			{
				if(_albums)
				{
					if(_albums.pageHeight <= 0 && _bg) _albums.pageHeight = _bg.height;
					return _albums.pageHeight;
//					if(_albums.rightPageHeight <= 0 && _bg) _albums.rightPageHeight = _bg.height;
//					return _albums.rightPageHeight;
				}
			}
			
			return super.height;
		}
		
		override public function set height(value:Number):void
		{
			if(_isLeft)
			{
				if(_albums) _albums.pageHeight = value;
			}
			else
			{
				if(_albums) _albums.pageHeight = value;
			}
		}
		
		public function dispose():void
		{
			uninitDataView();
			
			_albums = null;
			_photoPage = null;
			
			if(parent) parent.removeChild(this);
		}
	}
}