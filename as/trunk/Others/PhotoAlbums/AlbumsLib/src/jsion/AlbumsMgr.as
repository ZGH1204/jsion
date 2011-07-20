package jsion
{
	import com.StageReference;
	import com.managers.InstanceManager;
	import com.utils.DisposeHelper;
	import com.utils.ObjectHelper;
	import com.utils.StringHelper;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import jsion.controls.Button;
	import jsion.data.Albums;
	import jsion.data.BackcPage;
	import jsion.data.CoverPage;
	import jsion.data.Loading;
	import jsion.data.PhotoPage;
	import jsion.view.AlbumsFlip;
	import jsion.view.AlbumsListView;
	import jsion.view.FlipProxy;
	import jsion.view.PhotoIndexView;
	import jsion.view.PlayerView;

	public class AlbumsMgr
	{
		public static const CLOSE_PADDING_X:int = 0;
		public static const CLOSE_PADDING_Y:int = 0;
		
		private var _albumsList:Vector.<Albums> = new Vector.<Albums>();
		
		private var _current:Albums;
		
		private var _closeBtn:Button;
		
		private var _currentPhoto:Sprite;
		
		public function setup(configXML:XML):void
		{
			if(configXML == null) return;
			var albumsListXL:XMLList = configXML.AlbumsList;
			for each(var albumsListXml:XML in albumsListXL)
			{
				var albumsXL:XMLList = albumsListXml.albums;
				for each(var albumsXml:XML in albumsXL)
				{
					var album:Albums = new Albums();
					Util.parseXml(album, albumsXml, albumsListXml);
					var btnXL:XMLList = albumsXml.btn;
					for each(var btnXml:XML in btnXL)
					{
						Util.parseXml(album, btnXml);
					}
					
					var loadingXL:XMLList = albumsXml.loading;
					for each(var loadingXml:XML in loadingXL)
					{
						var loading:Loading = new Loading();
						ObjectHelper.copyPropertyToTargetBySource(album, loading);
						Util.parseXml(loading, loadingXml);
						album.loading = loading;
						break;
					}
					
					var coverXL:XMLList = albumsXml.cover;
					for each(var coverXml:XML in coverXL)
					{
						var cover:CoverPage = new CoverPage();
						ObjectHelper.copyPropertyToTargetBySource(album, cover);
						Util.parseXml(cover, coverXml);
						album.cover = cover;
						break;
					}
					
					var pageXL:XMLList = albumsXml.page;
					for each(var pageXml:XML in pageXL)
					{
						var page:PhotoPage = new PhotoPage();
						ObjectHelper.copyPropertyToTargetBySource(album, page);
						Util.parseXml(page, pageXml);
						album.photoPageList.push(page);
					}
					
					if(album.photoPageList.length % 2 == 1) album.photoPageList.push(new PhotoPage());
					
					var backcXL:XMLList = albumsXml.backc;
					for each(var backcXml:XML in backcXL)
					{
						var backc:BackcPage = new BackcPage();
						ObjectHelper.copyPropertyToTargetBySource(album, backc);
						Util.parseXml(backc, backcXml);
						album.backc = backc;
						break;
					}
					_albumsList.push(album);
					
					if(album.loading == null) album.loading = new Loading();
					if(album.cover == null) album.cover = new CoverPage();
					if(album.backc == null) album.backc = new BackcPage();
				}
				
			}
			
			if(_albumsList.length == 0) return;
			
			for each(var firstXml:XML in albumsListXL)
			{
				var index:int = int(String(firstXml.@defaultAlbums));
				index--;
				
				if(index >= _albumsList.length || index < 0) current = _albumsList[0];
				else current = _albumsList[index];
				break;
			}
		}
		private var _parent:DisplayObjectContainer;
		public function setParent(parent:DisplayObjectContainer):void
		{
			_parent = parent;
			if(_albumsFlip && _parent) _parent.addChild(_albumsFlip);
		}
		
		public function createAlbumFlip(album:Albums):void
		{
			if(album == null) return;
			
			current = album;
			albumsFlip = new AlbumsFlip();
		}
		
		private var _albumsFlip:AlbumsFlip;

		public function get albumsFlip():AlbumsFlip
		{
			return _albumsFlip;
		}

		public function set albumsFlip(value:AlbumsFlip):void
		{
			DisposeHelper.dispose(_albumsFlip);
			PlayerMgr.Instance.setParent(_parent);
			_albumsFlip = value;
			if(_parent && _albumsFlip) _parent.addChild(_albumsFlip);
			if(_albumsFlip && _albumsFlip.playerLayer) PlayerMgr.Instance.setParent(_albumsFlip.playerLayer);
		}
		
//		private var _musicPlayer:PlayerView;
//
//		public function get musicPlayer():PlayerView
//		{
//			return _musicPlayer;
//		}
//
//		public function set musicPlayer(value:PlayerView):void
//		{
//			DisposeHelper.dispose(_musicPlayer);
//			_musicPlayer = value;
//			if(_parent && _musicPlayer) _parent.addChild(_musicPlayer);
//		}

		
		private var _proxy:FlipProxy;

		public function get proxy():FlipProxy
		{
			return _proxy;
		}

		public function set proxy(value:FlipProxy):void
		{
			_proxy = value;
		}

		
		public function get current():Albums
		{
			return _current;
		}
		
		public function set current(value:Albums):void
		{
			_current = value;
//			if(_current == null) return;
//			
//			createColseBtn();
//			createAlbumsList();
		}
		
		public function createColseBtn():void
		{
			if(_closeBtn) _closeBtn.removeEventListener(MouseEvent.CLICK, __closeHandler);
			DisposeHelper.dispose(_closeBtn);
			_closeBtn = createButton(_current.slovePath(_current.closeBtn), _current.slovePath(_current.closeBtnOver), 0, 0);
			_closeBtn.y = CLOSE_PADDING_Y;
			_closeBtn.addEventListener(MouseEvent.CLICK, __closeHandler);
		}
		
		public function createAlbumsList():void
		{
			
		}
		
		private var _alumsListView:AlbumsListView;
		
		private function __closeHandler(e:MouseEvent):void
		{
			if(_closeBtn.parent) _closeBtn.parent.removeChild(_closeBtn);
			closePhoto();
			closeAlbumsList();
			closeAlbumsIndex();
		}
		
		private var _isShowAlbumsList:Boolean;

		public function get isShowAlbumsList():Boolean
		{
			return _isShowAlbumsList;
		}

		public function showAlbumsList():void
		{
			if(_isShowPhoto) return;
			closeAlbumsIndex();
			_alumsListView = new AlbumsListView();
			_alumsListView.albumsList = _albumsList;
			addCloseButton(_alumsListView);
			refreshPhotoPosAndModel(_alumsListView);
			StageReference.stage.addChild(_alumsListView);
			_isShowAlbumsList = true;
		}
		
		public function closeAlbumsList():void
		{
			if(_closeBtn && _closeBtn.parent) _closeBtn.parent.removeChild(_closeBtn);
			DisposeHelper.dispose(_alumsListView);
			_alumsListView = null;
			_isShowAlbumsList = false;
		}
		private var _isShowPhoto:Boolean;
		public function get isShowPhoto():Boolean
		{
			return _isShowPhoto;
		}
		
		public function showPhoto(photo:Sprite):void
		{
			if(_isShowAlbumsList || _isShowAlbumsIndex || photo == null) return;
			
			closePhoto();
			
			_isShowPhoto = true;
			_currentPhoto = photo;
			
			addCloseButton(_currentPhoto);
			refreshPhotoPosAndModel(_currentPhoto);
			
			addShowPhotoEvent(_currentPhoto);
			
			StageReference.stage.addChild(_currentPhoto);
		}
		
		public function closePhoto():void
		{
			if(_closeBtn && _closeBtn.parent) _closeBtn.parent.removeChild(_closeBtn);
			if(_currentPhoto && _currentPhoto.numChildren > 0)
			{
				DisposeHelper.dispose(_currentPhoto.removeChildAt(0), false);
			}
			
			removeShowPhotoEvent(_currentPhoto);
			DisposeHelper.dispose(_currentPhoto);
			_currentPhoto = null;
			_isShowPhoto = false;
		}
		
		private function refreshPhotoPosAndModel(photo:Sprite):void
		{
			var size:Rectangle = new Rectangle(0, 0, photo.width, photo.height);
			
			photo.graphics.clear();
			photo.graphics.beginFill(0x0, 0.5);
			photo.graphics.drawRect(-StageReference.stage.stageWidth, -StageReference.stage.stageHeight, StageReference.stage.stageWidth * 3, StageReference.stage.stageHeight * 3);
			photo.graphics.endFill();
			
			photo.x = (StageReference.stage.stageWidth - size.width) / 2;
			photo.y = (StageReference.stage.stageHeight - size.height) / 2;
		}
		
		private function addCloseButton(photo:Sprite):void
		{
			if(_closeBtn && _closeBtn.isExists && photo)
			{
				_closeBtn.x = photo.width - _closeBtn.width - CLOSE_PADDING_X;
				_closeBtn.y = CLOSE_PADDING_Y;
				if(photo.hasOwnProperty("setCloseBtn")) photo["setCloseBtn"](_closeBtn);
				photo.addChild(_closeBtn);
			}
		}
		
		private function addShowPhotoEvent(display:Sprite):void
		{
			if(display == null) return;
			display.doubleClickEnabled = true;
			display.addEventListener(MouseEvent.MOUSE_DOWN, __photoMouseDownHandler);
			display.addEventListener(MouseEvent.MOUSE_UP, __photoMouseUpHandler);
			display.addEventListener(MouseEvent.DOUBLE_CLICK, __doubleClickHandler);
			StageReference.stage.addEventListener(Event.ENTER_FRAME, __enterFrameHandler);
		}
		
		private function removeShowPhotoEvent(display:Sprite):void
		{
			StageReference.stage.removeEventListener(Event.ENTER_FRAME, __enterFrameHandler);
			if(display == null) return;
			display.removeEventListener(MouseEvent.MOUSE_DOWN, __photoMouseDownHandler);
			display.removeEventListener(MouseEvent.MOUSE_UP, __photoMouseUpHandler);
			display.removeEventListener(MouseEvent.DOUBLE_CLICK, __doubleClickHandler);
		}
		
		private function __photoMouseDownHandler(e:MouseEvent):void
		{
			var display:Sprite = e.currentTarget as Sprite;
			display.startDrag();
		}
		
		private function __photoMouseUpHandler(e:MouseEvent):void
		{
			if(e.stageX > StageReference.stage.stageWidth || e.stageY > StageReference.stage.stageHeight) return;
			var display:Sprite = e.currentTarget as Sprite;
			display.stopDrag();
		}
		
		private function __doubleClickHandler(e:MouseEvent):void
		{
			closePhoto();
		}
		
		private function __enterFrameHandler(e:Event):void
		{
			if(_currentPhoto == null) return;
			
			var point:Point = _currentPhoto.localToGlobal(new Point(-StageReference.stage.stageWidth, -StageReference.stage.stageHeight));
			if(point.x > 0)
			{
				_currentPhoto.x = StageReference.stage.stageWidth;
			}
			if(point.y > 0)
			{
				_currentPhoto.y = StageReference.stage.stageHeight;
			}
			
			point = _currentPhoto.localToGlobal(new Point(-StageReference.stage.stageWidth, 2 * StageReference.stage.stageHeight));
			if(point.x > 0)
			{
				_currentPhoto.x = StageReference.stage.stageWidth;
			}
			if(point.y < StageReference.stage.stageHeight)
			{
				_currentPhoto.y = -StageReference.stage.stageHeight;
			}
			
			point = _currentPhoto.localToGlobal(new Point(2 * StageReference.stage.stageWidth, 2 * StageReference.stage.stageHeight));
			if(point.x < StageReference.stage.stageWidth)
			{
				_currentPhoto.x = -StageReference.stage.stageWidth;
			}
			if(point.y < StageReference.stage.stageHeight)
			{
				_currentPhoto.y = -StageReference.stage.stageHeight;
			}
			
			point = _currentPhoto.localToGlobal(new Point(2 * StageReference.stage.stageWidth, -StageReference.stage.stageHeight));
			if(point.x < StageReference.stage.stageWidth)
			{
				_currentPhoto.x = -StageReference.stage.stageWidth;
			}
			if(point.y > 0)
			{
				_currentPhoto.y = StageReference.stage.stageHeight;
			}
		}
		
		private var _albumsIndex:PhotoIndexView;
		private var _isShowAlbumsIndex:Boolean;

		public function get isShowAlbumsIndex():Boolean
		{
			return _isShowAlbumsIndex;
		}
		
		public function showAlbumsIndex():void
		{
			if(canFlip == false) return;
			DisposeHelper.dispose(_albumsIndex);
			_albumsIndex = new PhotoIndexView();
			_albumsIndex.albums = _current;
			StageReference.stage.addChild(_albumsIndex);
			_isShowAlbumsIndex = true;
			addCloseButton(_albumsIndex);
		}
		
		public function closeAlbumsIndex():void
		{
			if(_closeBtn && _closeBtn.parent) _closeBtn.parent.removeChild(_closeBtn);
			DisposeHelper.dispose(_albumsIndex);
			_albumsIndex = null;
			_isShowAlbumsIndex = false;
		}
		
		public function get canFlip():Boolean
		{
			if(_isShowAlbumsList || _isShowPhoto || _isShowAlbumsIndex) return false;
			return true;
		}
		
		
		public static function createButtonAndText(page:String, pageOver:String, posX:int, posY:int, txt:String, font:String, size:int, color:uint, bold:Boolean, italic:Boolean):Button
		{
			var btn:Button = createButton(page, pageOver, posX, posY);
			
			var textField:TextField = createTextField(txt, font, size, color, bold, italic, 0, 0);
			
			btn.x = posX;
			btn.y = posY;
			btn.txt = textField;
			
			return btn;
		}
		
		public static function createButton(page:String, pageOver:String, posX:int = 0, posY:int = 0):Button
		{
			var up:DisplayObject, over:DisplayObject, bmd:BitmapData;
			
			bmd = BitmapDataMgr.Instance.getBitmapData(page);
			if(bmd) up = new Bitmap(bmd.clone());
			bmd = BitmapDataMgr.Instance.getBitmapData(pageOver);
			if(bmd) over = new Bitmap(bmd.clone());
			var btn:Button = new Button(up, over);
			btn.x = posX;
			btn.y = posY;
			
			return btn
		}
		
		public static function createTextField(txt:String, font:String, size:int, color:uint, bold:Boolean, italic:Boolean, posX:int, posY:int):TextField
		{
			var textField:TextField = new TextField();
			
			if(StringHelper.isNullOrEmpty(font)) font = "宋体";
			if(size <= 0) size = 13;
			
			var tf:TextFormat = new TextFormat(font, size, color, bold, italic);
			
			textField.type = TextFieldType.DYNAMIC;
			textField.defaultTextFormat = tf;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.multiline = true;
			textField.x = posX;
			textField.y = posY;
			textField.htmlText = txt;
			textField.selectable = false;
			textField.mouseEnabled = false;
			
			return textField;
		}
		
		public static function get Instance():AlbumsMgr
		{
			return InstanceManager.createSingletonInstance(AlbumsMgr) as AlbumsMgr;
		}

	}
}