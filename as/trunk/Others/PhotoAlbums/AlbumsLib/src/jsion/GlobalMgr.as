package jsion
{
	import com.StageReference;
	import com.interfaces.ILoader;
	import com.loader.DisplayLoader;
	import com.loader.LoaderCollection;
	import com.managers.CacheManager;
	import com.managers.InstanceManager;
	import com.utils.DisposeHelper;
	import com.utils.GraphicsHelper;
	import com.utils.StringHelper;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	import jsion.data.Albums;
	import jsion.data.Loading;
	import jsion.data.PhotoPage;
	import jsion.data.PlayerSkin;
	import jsion.view.AlbumsFlip;
	import jsion.view.AlbumsLoading;
	import jsion.view.PlayerView;

	public class GlobalMgr
	{
		private var _loading:AlbumsLoading;
		private var _loaderList:LoaderCollection;
		private var _loadingLoaderList:LoaderCollection;
		private var _bg:DisplayObjectContainer;
		
		public function GlobalMgr()
		{
		}
		
		public function setup(display:DisplayObjectContainer, albumsXml:XML, playerXml:XML, bg:DisplayObjectContainer):void
		{
			AlbumsMgr.Instance.setParent(display);
			AlbumsMgr.Instance.setup(albumsXml);
			PlayerMgr.Instance.setParent(display);
			PlayerMgr.Instance.setup(playerXml);
			
			_bg = bg;
			
			StageReference.addEventListener(Event.RESIZE, __stageResizeHandler);
		}
		
		private function __stageResizeHandler(e:Event):void
		{
			GraphicsHelper.drawRect(StageReference.stage.stageWidth, StageReference.stage.stageHeight, _bg, 0x0, 1);
			
			if(AlbumsMgr.Instance.albumsFlip)
			{
				AlbumsMgr.Instance.albumsFlip.x = (StageReference.stage.stageWidth - AlbumsMgr.Instance.current.albumsWidth) / 2;
				AlbumsMgr.Instance.albumsFlip.y = (StageReference.stage.stageHeight - AlbumsMgr.Instance.current.albumsHeight) / 2;
			}
		}
		
		public function createAlbumFlipAndPlayer(album:Albums):void
		{
			if(album == null) return;
			
			AlbumsMgr.Instance.createAlbumFlip(album);
			
			if(album.enableMusic)
			{
				PlayerMgr.Instance.setCurrentSkin(AlbumsMgr.Instance.current.playSkinIndex - 1);
				PlayerMgr.Instance.setCurrentPlayList(AlbumsMgr.Instance.current.musicListIndex - 1);
				
				PlayerMgr.Instance.musicPlayer = new PlayerView();
			}
			else
			{
				PlayerMgr.Instance.musicPlayer = null;
			}
			
			loadLoadingAsset(album.loading, loadingAssetCallback);
		}
		
		private function loadingAssetCallback():void
		{
			startLoad(AlbumsMgr.Instance.current, PlayerMgr.Instance.currentSkin);
		}
		
		public function loadLoadingAsset(loading:Loading, callback:Function):void
		{
			if(loading == null) return;
			
			var list:Array = [];
			
			if(loading.showBack) createLoader(list, loading.slovePath(loading.backPic));
			if(loading.showAnimation) createLoader(list, loading.slovePath(loading.animationPic));
			if(loading.showProgress) createLoader(list, loading.slovePath(loading.progressBar));
			if(loading.showProgress) createLoader(list, loading.slovePath(loading.progressBarBg));
			
			if(list.length > 0)
			{
				DisposeHelper.dispose(_loadingLoaderList);
				_loadingLoaderList = new LoaderCollection();
				
				var scale:int = int(100 / list.length);
				for each(var loader:ILoader in list)
				{
					_loadingLoaderList.addLoader(loader, scale);
				}
				_loadingLoaderList.startLoad(callback);
			}
			else
			{
				if(callback != null) callback();
			}
		}
			
		
		public function startLoad(album:Albums, playerSkin:PlayerSkin):void
		{
			if(album == null) return;
			
			if(_loading == null) _loading = new AlbumsLoading();
			_loading.loading = album.loading;
			StageReference.stage.addChild(_loading);
			
			var list:Array = [];
			
			createLoader(list, album.slovePath(album.photoError));
			createLoader(list, album.slovePath(album.stageBackground));
			createLoader(list, album.slovePath(album.background));
			createLoader(list, album.slovePath(album.coverPage));
			createLoader(list, album.slovePath(album.backcPage));
			createLoader(list, album.slovePath(album.leftPage));
			createLoader(list, album.slovePath(album.rightPage));
			createLoader(list, album.slovePath(album.prePageBtn));
			createLoader(list, album.slovePath(album.prePageBtnOver));
			createLoader(list, album.slovePath(album.nextPageBtn));
			createLoader(list, album.slovePath(album.nextPageBtnOver));
			createLoader(list, album.slovePath(album.selectAlbumsBtn));
			createLoader(list, album.slovePath(album.selectAlbumsBtnOver));
			createLoader(list, album.slovePath(album.printPage));
			createLoader(list, album.slovePath(album.printPageOver));
			createLoader(list, album.slovePath(album.commentsPage));
			createLoader(list, album.slovePath(album.commentsPageOver));
			createLoader(list, album.slovePath(album.albumListBg));
			createLoader(list, album.slovePath(album.pageNumberBtn));
			createLoader(list, album.slovePath(album.pageNumberBtnOver));
			createLoader(list, album.slovePath(album.closeBtn));
			createLoader(list, album.slovePath(album.closeBtnOver));
			createLoader(list, album.slovePath(album.photoListBg));
			createLoader(list, album.slovePath(album.coverBtn));
			createLoader(list, album.slovePath(album.coverBtnOver));
			createLoader(list, album.slovePath(album.backcBtn));
			createLoader(list, album.slovePath(album.backcBtnOver));
			createLoader(list, album.slovePath(album.directoryBtn));
			createLoader(list, album.slovePath(album.directoryBtnOver));
			
			if(playerSkin)
			{
				createLoader(list, playerSkin.slovePath(playerSkin.muteBtn));
				createLoader(list, playerSkin.slovePath(playerSkin.muteBtnOver));
				createLoader(list, playerSkin.slovePath(playerSkin.unMuteBtn));
				createLoader(list, playerSkin.slovePath(playerSkin.unMuteBtnOver));
				createLoader(list, playerSkin.slovePath(playerSkin.nextTrackBtn));
				createLoader(list, playerSkin.slovePath(playerSkin.nextTrackBtnOver));
				createLoader(list, playerSkin.slovePath(playerSkin.pauseBtn));
				createLoader(list, playerSkin.slovePath(playerSkin.pauseBtnOver));
				createLoader(list, playerSkin.slovePath(playerSkin.playBtn));
				createLoader(list, playerSkin.slovePath(playerSkin.playBtnOver));
				createLoader(list, playerSkin.slovePath(playerSkin.preTrackBtn));
				createLoader(list, playerSkin.slovePath(playerSkin.preTrackBtnOver));
				createLoader(list, playerSkin.slovePath(playerSkin.stopBtn));
				createLoader(list, playerSkin.slovePath(playerSkin.stopBtnOver));
				createLoader(list, playerSkin.slovePath(playerSkin.titleBg));
			}
			
			if(album.cover)
			{
				createLoader(list, album.cover.slovePath(album.cover.topPic));
				createLoader(list, album.cover.slovePath(album.cover.middlePic));
				createLoader(list, album.cover.slovePath(album.cover.bottomPic));
			}
			
			if(album.backc)
			{
				createLoader(list, album.backc.slovePath(album.backc.topPic));
				createLoader(list, album.backc.slovePath(album.backc.middlePic));
				createLoader(list, album.backc.slovePath(album.backc.bottomPic));
			}
			
			var index:int = 0, preLoadCount:int = int.MAX_VALUE;
			for each(var page:PhotoPage in album.photoPageList)
			{
				createLoader(list, page.slovePath(page.topPic));
				createLoader(list, page.slovePath(page.bottomPic));
				
				if(index < preLoadCount)
				{
					createLoader(list, page.slovePath(page.middlePic));
				}
				
				if(page.isPreface)
				{
					createLoader(list, page.slovePath(page.prefacePic));
				}
				
				index++;
			}
			
			if(list.length > 0)
			{
				DisposeHelper.dispose(_loaderList);
				_loaderList = new LoaderCollection();
				
				var scale:int = int(100 / list.length);
				for each(var loader:ILoader in list)
				{
					_loaderList.addLoader(loader, scale);
				}
				_loaderList.startLoad(listLoadCallback);
				StageReference.addEventListener(Event.ENTER_FRAME, __enterFrameHandler);
			}
			else
			{
				listLoadCallback();
			}
		}
		
		private function listLoadCallback():void
		{
			while(_loaderList && _loaderList.errorList && _loaderList.errorList.length > 0)
			{
				var loader:DisplayLoader = _loaderList.errorList.shift();
				if(loader) BitmapDataMgr.Instance.putBitmapData(loader.path, BitmapDataMgr.Instance.getBitmapData(AlbumsMgr.Instance.current.slovePath(AlbumsMgr.Instance.current.photoError)));
			}
			
			AlbumsMgr.Instance.albumsFlip.albums = AlbumsMgr.Instance.current;
			
			if(PlayerMgr.Instance.musicPlayer)
			{
				PlayerMgr.Instance.musicPlayer.skin = PlayerMgr.Instance.currentSkin;
				PlayerMgr.Instance.musicPlayer.playList = PlayerMgr.Instance.currentList;
				
				if(AlbumsMgr.Instance.current.enableSetPlayerPos)
				{
					PlayerMgr.Instance.musicPlayer.x = AlbumsMgr.Instance.current.playerX;
					PlayerMgr.Instance.musicPlayer.y = AlbumsMgr.Instance.current.playerY;
				}
			}
			
			DisposeHelper.dispose(_loaderList);
			_loaderList = null;
			
			DisposeHelper.dispose(_loading);
			_loading = null;
			
			CacheManager.getInstance().clearMemoryCache(false);
			StageReference.removeEventListener(Event.ENTER_FRAME, __enterFrameHandler);
			
			__stageResizeHandler(null);
		}
		
		private function __enterFrameHandler(e:Event):void
		{
			if(_loading && _loaderList)
			{
				_loading.percent = _loaderList.percent;
			}
		}
		
		private function createLoader(list:Array, path:String):void
		{
			if(StringHelper.isNullOrEmpty(path) || BitmapDataMgr.Instance.hasBitmapData(path)) return;
			var loader:DisplayLoader = new DisplayLoader(path, null, true);
			loader.loadAsync(displayLoadCallback);
			list.push(loader);
		}
		
		private function displayLoadCallback(loader:DisplayLoader):void
		{
			if(loader.isSuccess)
			{
				BitmapDataMgr.Instance.putBitmapData(loader.path, Bitmap(loader.content).bitmapData.clone());
			}
		}
		
		public static function get Instance():GlobalMgr
		{
			return InstanceManager.createSingletonInstance(GlobalMgr) as GlobalMgr;
		}
	}
}