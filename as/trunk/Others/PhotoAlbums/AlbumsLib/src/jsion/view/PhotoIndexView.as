package jsion.view
{
	import com.interfaces.IDispose;
	import com.loader.DisplayLoader;
	import com.utils.DisposeHelper;
	import com.utils.StringHelper;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Rectangle;
	
	import jsion.AlbumsMgr;
	import jsion.BitmapDataMgr;
	import jsion.controls.Button;
	import jsion.data.Albums;
	
	public class PhotoIndexView extends Sprite implements IDispose
	{
		private var _albums:Albums;
		
		private var _bg:DisplayObject;
		private var _leftContainer:Sprite;
		private var _rightContainer:Sprite;
		private var _pageNumberContainer:Sprite;
		
		private var _photoList:Array = [];
		private var _photoDataList:Array = [];
		private var _pageNumberList:Array = [];
		
		private var _pageFirstIndex:int = 0;
		private var _pageLastIndex:int = 0;
		
		private var _currentPage:int = 1;
		private var _currentPageBtn:Button;
		
		private var _lightingFilter:ColorMatrixFilter;

		public function get currentPageBtn():Button
		{
			return _currentPageBtn;
		}

		public function set currentPageBtn(value:Button):void
		{
			if(_currentPageBtn) _currentPageBtn.selected = false;
			_currentPageBtn = value;
			if(_currentPageBtn) _currentPageBtn.selected = true;
		}

		
		public function PhotoIndexView()
		{
			super();
		}
		
		public function setCloseBtn(btn:Button):void
		{
			if(btn == null || _albums == null) return;
			btn.x -= AlbumsMgr.Instance.current.indexCloseBtnPX;
			btn.y += AlbumsMgr.Instance.current.indexCloseBtnPY;
			addChild(btn);
		}
		
		public function get albums():Albums
		{
			return _albums;
		}

		public function set albums(value:Albums):void
		{
			if(value == null) return;
			
			_albums = value;
			
			x = _albums.photoListX;
			y = _albums.photoListY;
			
			var matrix:Array = new Array();
			matrix = matrix.concat([1, 0, 0, 0, 25]);// red
			matrix = matrix.concat([0, 1, 0, 0, 25]);// green
			matrix = matrix.concat([0, 0, 1, 0, 25]);// blue
			matrix = matrix.concat([0, 0, 0, 1, 0]);// alpha
			_lightingFilter = new ColorMatrixFilter(matrix);
			
			initBackground();
			initContainer();
			initDataView();
			initPageNumber();
			refreshPageNumberPos();
		}
		
		private function initBackground():void
		{
			DisposeHelper.dispose(_bg, false);
			_bg = null;
			
			var bmd:BitmapData = BitmapDataMgr.Instance.getBitmapData(_albums.slovePath(_albums.photoListBg));
			if(bmd) _bg = new Bitmap(bmd, PixelSnapping.AUTO, true);
			if(_bg) addChild(_bg);
			
			if(_albums.photoListWidth > 0 && _bg) _bg.width = _albums.photoListWidth;
			if(_albums.photoListHeight > 0 && _bg) _bg.height = _albums.photoListHeight;
		}
		
		private function initContainer():void
		{
			DisposeHelper.dispose(_leftContainer);
			_leftContainer = new Sprite();
			_leftContainer.x = _albums.photoLeftListX;
			_leftContainer.y = _albums.photoLeftListY;
			addChild(_leftContainer);
			
			DisposeHelper.dispose(_rightContainer);
			_rightContainer = new Sprite();
			_rightContainer.x = _albums.photoRightListX;
			_rightContainer.y = _albums.photoRightListY;
			addChild(_rightContainer);
			
			DisposeHelper.dispose(_pageNumberContainer);
			_pageNumberContainer = new Sprite();
			_pageNumberContainer.x = _albums.photoPageNumberX;
			_pageNumberContainer.y = _albums.photoPageNumberY;
			addChild(_pageNumberContainer);
		}
		
		private function initDataView():void
		{
			setPage(_currentPage);
		}
		
		private function initPageNumber():void
		{
			clearPageNumberList();
			var pic:String = _albums.slovePath(_albums.photoPageNumberBg);
			var picOver:String = _albums.slovePath(_albums.photoPageNumberBgOver);
			var pageSize:int = _albums.photoCols * _albums.photoRows;
			if(_albums.doublePhotoList) pageSize *= 2;
			
			var pageCount:int = _albums.photoPageList.length / pageSize + (((_albums.photoPageList.length % pageSize) == 0) ? 0 : 1);
			
			for (var i:int = 0; i < pageCount; i++)
			{
				var btn:Button = AlbumsMgr.createButtonAndText(pic, picOver, 0, 0, (i + 1).toString(), _albums.photoPageNumberFont, _albums.photoPageNumberSize, _albums.photoPageNumberColor, _albums.photoPageNumberBold, _albums.photoPageNumberItalic);
				_pageNumberList.push(btn);
				_pageNumberContainer.addChild(btn);
				
				btn.addEventListener(MouseEvent.CLICK, __pageNumberClickHandler);
			}
			
			currentPageBtn = _pageNumberList[0];
		}
		
		private function refreshPageNumberPos():void
		{
			if(_pageNumberList == null || _pageNumberList.length == 0) return;
			var spacing:int = _albums.thumbnailSpacing;
			_pageNumberList[0].x = _pageNumberList[0].y = 0;
			for(var i:int = 1; i < _pageNumberList.length; i++)
			{
				_pageNumberList[i].x = _pageNumberList[i - 1].x + _pageNumberList[i - 1].width + spacing;
				_pageNumberList[i].y = 0;
			}
		}
		
		private function __pageNumberClickHandler(e:MouseEvent):void
		{
			if(_currentPage == int((e.currentTarget as Button).txt.text)) return;
			
			_currentPage = int((e.currentTarget as Button).txt.text);
			setPage(_currentPage);
		}
		
		
		private function setPage(page:int):void
		{
			var cols:int = _albums.photoCols;
			var rows:int = _albums.photoRows;
			var pageSize:int = cols * rows;
			if(_albums.doublePhotoList) pageSize *= 2;
			_pageFirstIndex = pageSize * (page - 1);
			currentPageBtn = _pageNumberList[page - 1];
			showPageByPageFirst(_pageFirstIndex, _leftContainer, true);
			if(_albums.doublePhotoList) showPageByPageFirst(_pageLastIndex + 1, _rightContainer, false);
		}
		
		private function clearPageNumberList():void
		{
			while(_pageNumberList && _pageNumberList.length > 0)
			{
				var display:DisplayObject = _pageNumberList.shift();
				display.removeEventListener(MouseEvent.CLICK, __pageNumberClickHandler);
				DisposeHelper.dispose(display);
			}
		}
		
		private function showPageByPageFirst(pageFirst:int, container:Sprite, setPageFirstIndex:Boolean):void
		{
			if(pageFirst < 0 || pageFirst >= _albums.photoPageList.length) return;
			
			if(setPageFirstIndex) clearListView();
			
			var cols:int = _albums.photoCols;
			var rows:int = _albums.photoRows;
			var index:int = pageFirst;
			var refreshList:Array = [];
			
			for (var row:int = 0; row < rows; row++)
			{
				for (var col:int = 0; col < cols; col++)
				{
					if(_albums.photoPageList.length <= index) return;
					
//					if(_albums.photoPageList[index].isPreface)
//					{
//						index++;
//						col--;
//						_photoList.push(loader);
//						_photoDataList.push(_albums.photoPageList[index]);
//						continue;
//					}
					
					if(col == 0 && row == 0 && setPageFirstIndex) _pageFirstIndex = index;
					
					var loader:DisplayLoader = new DisplayLoader(_albums.photoPageList[index].slovePath(_albums.photoPageList[index].thumbnail), null , true);
					loader.x = _albums.photoPageList[index].thumbnailX;
					loader.y = _albums.photoPageList[index].thumbnailY;
					_photoList.push(loader);
					refreshList.push(loader);
					_photoDataList.push(_albums.photoPageList[index]);
					
					var sprite:Sprite = new Sprite();
					sprite.buttonMode = true;
					sprite.scrollRect = new Rectangle(0, 0, _albums.thumbnailWidth, _albums.thumbnailHeight);
					sprite.addChild(loader);
					container.addChild(sprite);
					
					if(StringHelper.isNullOrEmpty(_albums.photoPageList[index].thumbnail) == false)
					{
						loader.loadAsync();
						loader.addEventListener(MouseEvent.CLICK, __photoClickHandler);
						loader.addEventListener(MouseEvent.MOUSE_OVER, __photoOverHandler);
						loader.addEventListener(MouseEvent.MOUSE_OUT, __photoOutHandler);
					}
					
					index++;
					
					if(_albums.photoPageList.length <= index)
					{
						_pageLastIndex = index - 1;
						break;
					}
				}
				
				if(_albums.photoPageList.length <= index || row == (rows - 1))
				{
					_pageLastIndex = index - 1;
					break;
				}
			}
			refreshDataViewPos(refreshList);
		}
		
		private function clearListView():void
		{
			while(_photoList && _photoList.length > 0)
			{
				var display:DisplayLoader = _photoList.shift();
				_photoDataList.shift();
				if(display == null) continue;
				display.removeEventListener(MouseEvent.CLICK, __photoClickHandler);
				display.removeEventListener(MouseEvent.MOUSE_OVER, __photoOverHandler);
				display.removeEventListener(MouseEvent.MOUSE_OUT, __photoOutHandler);
				DisposeHelper.dispose(display.parent);
				DisposeHelper.dispose(display);
			}
		}
		
		private function refreshDataViewPos(list:Array):void
		{
			if(list == null || list.length == 0) return;
			var cols:int = _albums.photoCols;
			var rows:int = _albums.photoRows;
			var iw:int = _albums.thumbnailWidth;
			var ih:int = _albums.thumbnailHeight;
			var spacing:int = _albums.thumbnailSpacing;
			var index:int = 0;
			var xPos:int = 0;
			var yPos:int = 0;
			for (var row:int = 0; row < rows; row++)
			{
				xPos = 0;
				for (var col:int = 0; col < cols; col++)
				{
					list[index].parent.x = xPos;
					list[index].parent.y = yPos;
					
					xPos += iw + spacing;
					index++;
					
					if(list.length <= index) break;
				}
				yPos += ih + spacing;
				if(list.length <= index) break;
			}
		}
		
		private function __photoClickHandler(e:MouseEvent):void
		{
			if(AlbumsMgr.Instance.proxy) AlbumsMgr.Instance.proxy.gotoPage(_photoList.indexOf(e.currentTarget) + _pageFirstIndex + 1);
			AlbumsMgr.Instance.closeAlbumsIndex();
		}
		
		private function __photoOverHandler(e:MouseEvent):void
		{
			DisplayObject(e.currentTarget).filters = [_lightingFilter];
		}
		
		private function __photoOutHandler(e:MouseEvent):void
		{
			DisplayObject(e.currentTarget).filters = null;
		}
		
		override public function get width():Number
		{
			if(_bg) return _bg.width;
			return _albums.photoListWidth;
		}
		
		override public function set width(value:Number):void
		{
			if(_bg) _bg.width = value;
		}
		
		override public function get height():Number
		{
			if(_bg) return _bg.height;
			return _albums.photoListHeight;
		}
		
		override public function set height(value:Number):void
		{
			if(_bg) _bg.height = value;
		}

		public function dispose():void
		{
			DisposeHelper.dispose(_bg, false);
			_bg = null;
			
			DisposeHelper.dispose(_leftContainer);
			_leftContainer = null;
			
			DisposeHelper.dispose(_rightContainer);
			_rightContainer = null;
			
			DisposeHelper.dispose(_pageNumberContainer);
			_pageNumberContainer = null;
			
			clearListView();
			_photoList = null;
			_photoDataList = null;
			
			clearPageNumberList();
			_pageNumberList = null;
			
			_currentPageBtn = null;
			_lightingFilter = null;
			_albums = null;
		}
	}
}