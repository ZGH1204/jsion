package jsion.view
{
	import com.interfaces.IDispose;
	import com.utils.DepthHelper;
	import com.utils.DisposeHelper;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	import jsion.AlbumsMgr;
	import jsion.BitmapDataMgr;
	import jsion.data.Albums;

	public class AlbumsFlip extends Sprite implements IDispose
	{
		private var _stageBackground:Background;
		
		private var _albumsView:AlbumsView;
		
		private var _playerLayer:Sprite;
		
		private var _albums:Albums;
		
		public function AlbumsFlip()
		{
			initPlayerLayer();
		}
		
		public function get playerLayer():Sprite
		{
			return _playerLayer;
		}

		public function get albums():Albums
		{
			return _albums;
		}

		public function set albums(value:Albums):void
		{
			if(_albums == value) return;
			
			clearAlbums();
			
			_albums = value;
			
			if(_albums == null) return;
			
			this.x = _albums.stageBgX;
			this.y = _albums.stageBgY;
			
			
			initStageBackground();
			initAlbumsView();
			AlbumsMgr.Instance.createColseBtn();
			AlbumsMgr.Instance.createAlbumsList();
			if(_playerLayer) DepthHelper.bringToTop(_playerLayer);
		}
		
		private function initStageBackground():void
		{
			if(_albums == null) return;
			
			DisposeHelper.dispose(_stageBackground);
			_stageBackground = new Background(_albums.albumsWidth, _albums.albumsHeight);
			var bmd:BitmapData = BitmapDataMgr.Instance.getBitmapData(_albums.slovePath(_albums.stageBackground));
			if(bmd) _stageBackground.display = new Bitmap(bmd);
			_stageBackground.layerOut = _albums.layerOut;
			_stageBackground.refresh();
			addChild(_stageBackground);
		}
		
		private function initAlbumsView():void
		{
			DisposeHelper.dispose(_albumsView);
			_albumsView = new AlbumsView();
			_albumsView.albums = _albums;
			addChild(_albumsView);
		}
		
		private function initPlayerLayer():void
		{
			DisposeHelper.dispose(_playerLayer);
			_playerLayer = new Sprite();
			addChild(_playerLayer);
		}
		
		public function clearAlbums():void
		{
			if(_albums == null) return;
		}
		
		public function dispose():void
		{
			DisposeHelper.dispose(_stageBackground);
			_stageBackground = null;
			
			DisposeHelper.dispose(_albumsView);
			_albumsView = null;
			
			_albums = null;
			
			BitmapDataMgr.Instance.clear();
			
			if(parent) parent.removeChild(this);
		}
	}
}