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
	import flash.text.TextField;
	
	import jsion.AlbumsMgr;
	import jsion.BitmapDataMgr;
	import jsion.GlobalMgr;
	import jsion.controls.Button;
	import jsion.data.Albums;
	
	public class AlbumsListView extends Sprite implements IDispose
	{
		private var _albumsList:Vector.<Albums>;
		private var _currentAlbums:Albums;
		
		private var _bg:DisplayObject;
		private var _title:TextField;
		private var _container:Sprite;
		private var _pageNumberContainer:Sprite;
		
		private var _coverList:Array = [];
		private var _coverDataList:Array = [];
		private var _pageNumberList:Array = [];
		private var _currentPage:int = 1;
		private var _currentPageBtn:Button;
		
		private var _pageFirstIndex:int = 0;
		private var _pageLastIndex:int = 0;
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

		
		public function AlbumsListView()
		{
			super();
		}
		
		public function setCloseBtn(btn:Button):void
		{
			if(btn == null || _albumsList == null || _albumsList.length == 0 || _currentAlbums == null) return;
			btn.x -= _currentAlbums.closeBtnPaddingX;
			btn.y += _currentAlbums.closeBtnPaddingY;
			addChild(btn);
		}
		
		public function get albumsList():Vector.<Albums>
		{
			return _albumsList;
		}

		public function set albumsList(value:Vector.<Albums>):void
		{
			_albumsList = value;
			
			if(_albumsList == null || _albumsList.length == 0) return;
			
			_currentAlbums = AlbumsMgr.Instance.current;
			if(_currentAlbums == null) _currentAlbums = _albumsList[0];
			
			var matrix:Array = new Array();
			matrix = matrix.concat([1, 0, 0, 0, 25]);// red
			matrix = matrix.concat([0, 1, 0, 0, 25]);// green
			matrix = matrix.concat([0, 0, 1, 0, 25]);// blue
			matrix = matrix.concat([0, 0, 0, 1, 0]);// alpha
			_lightingFilter = new ColorMatrixFilter(matrix);
			
			initBackground();
			initTitle();
			initContainer();
			initDataView();
			initPageNumber();
			refreshPageNumberPos();
		}
		
		private function initBackground():void
		{
			DisposeHelper.dispose(_bg, false);
			_bg = null;
			var bmd:BitmapData = BitmapDataMgr.Instance.getBitmapData(_currentAlbums.slovePath(_currentAlbums.albumListBg));
			if(bmd) _bg = new Bitmap(bmd, PixelSnapping.AUTO, true);
			if(_bg) addChild(_bg);
			
			if(_currentAlbums.listContainerWidth > 0 && _bg) _bg.width = _currentAlbums.listContainerWidth;
			if(_currentAlbums.listContainerHeight > 0 && _bg) _bg.height = _currentAlbums.listContainerHeight;
		}
		
		private function initTitle():void
		{
			DisposeHelper.dispose(_title);
			_title = AlbumsMgr.createTextField(_currentAlbums.listTitle, _currentAlbums.listTitleFont, _currentAlbums.listTitleSize, _currentAlbums.listTitleColor, _currentAlbums.listTitleBold, _currentAlbums.listTitleItalic, _currentAlbums.listTitleX, _currentAlbums.listTitleY);
			addChild(_title);
		}
		
		private function initContainer():void
		{
			DisposeHelper.dispose(_container);
			_container = new Sprite();
			_container.x = _currentAlbums.listContainerX;
			_container.y = _currentAlbums.listContainerY;
			addChild(_container);
			
			DisposeHelper.dispose(_pageNumberContainer);
			_pageNumberContainer = new Sprite();
			_pageNumberContainer.x = _currentAlbums.pageNumberX;
			_pageNumberContainer.y = _currentAlbums.pageNumberY;
			addChild(_pageNumberContainer);
		}
		
		private function initDataView():void
		{
			showPageByPageFirst(_pageFirstIndex);
		}
		
		private function initPageNumber():void
		{
			clearPageNumberList();
			var pic:String = _currentAlbums.slovePath(_currentAlbums.pageNumberBtn);
			var picOver:String = _currentAlbums.slovePath(_currentAlbums.pageNumberBtnOver);
			var pageSize:int = _currentAlbums.cols * _currentAlbums.rows;
			
			var pageCount:int = _albumsList.length / pageSize + (((_albumsList.length % pageSize) == 0) ? 0 : 1);
			
			for (var i:int = 0; i < pageCount; i++)
			{
				var btn:Button = AlbumsMgr.createButtonAndText(pic, picOver, 0, 0, (i + 1).toString(), _currentAlbums.pageNumberFont, _currentAlbums.pageNumberSize, _currentAlbums.pageNumberColor, _currentAlbums.pageNumberBold, _currentAlbums.pageNumberItalic);
				_pageNumberList.push(btn);
				_pageNumberContainer.addChild(btn);
				
				btn.addEventListener(MouseEvent.CLICK, __pageNumberClickHandler);
			}
			
			currentPageBtn = _pageNumberList[0];
		}
		
		private function showPageByPageFirst(pageFirst:int):void
		{
			if(pageFirst < 0 || pageFirst >= _albumsList.length) return;
			
			clearListView();
			
			var cols:int = _currentAlbums.cols;
			var rows:int = _currentAlbums.rows;
			var index:int = pageFirst;
			
			for (var row:int = 0; row < rows; row++)
			{
				for (var col:int = 0; col < cols; col++)
				{
					if(_albumsList.length <= index) return;
					
					if(col == 0 && row == 0) _pageFirstIndex = index;
					
					var loader:DisplayLoader = new DisplayLoader(_albumsList[index].slovePath(_albumsList[index].albumListCoverPic), null , true);
					loader.x = _albumsList[index].albumListCoverPicX;
					loader.y = _albumsList[index].albumListCoverPicY;
					var sprite:Sprite = new Sprite();
					sprite.buttonMode = true;
					sprite.scrollRect = new Rectangle(0, 0, _albumsList[index].itemWidth, _albumsList[index].itemHeight);
					sprite.addChild(loader);
					_container.addChild(sprite);
					_coverList.push(loader);
					_coverDataList.push(_albumsList[index]);
					if(StringHelper.isNullOrEmpty(_albumsList[index].albumListCoverPic) == false)
					{
						loader.loadAsync();
						loader.addEventListener(MouseEvent.CLICK, __albumClickHandler);
						loader.addEventListener(MouseEvent.MOUSE_OVER, __photoOverHandler);
						loader.addEventListener(MouseEvent.MOUSE_OUT, __photoOutHandler);
					}
					index++;
					
					if(_albumsList.length <= index)
					{
						_pageLastIndex = index - 1;
						break;
					}
				}
				
				if(_albumsList.length <= index || row == (rows - 1))
				{
					_pageLastIndex = index - 1;
					break;
				}
			}
			refreshDataViewPos();
		}
		
		private function __albumClickHandler(e:MouseEvent):void
		{
			var index:int = _coverList.indexOf(e.currentTarget);
			var albums:Albums = _coverDataList[index];
			AlbumsMgr.Instance.closeAlbumsList();
			if(_currentAlbums == albums) return;
			GlobalMgr.Instance.createAlbumFlipAndPlayer(albums);
		}
		
		private function __photoOverHandler(e:MouseEvent):void
		{
			DisplayObject(e.currentTarget).filters = [_lightingFilter];
		}
		
		private function __photoOutHandler(e:MouseEvent):void
		{
			DisplayObject(e.currentTarget).filters = null;
		}
		
		private function clearListView():void
		{
			while(_coverList && _coverList.length > 0)
			{
				var display:DisplayLoader = _coverList.shift();
				_coverDataList.shift();
				display.removeEventListener(MouseEvent.CLICK, __albumClickHandler);
				display.removeEventListener(MouseEvent.MOUSE_OVER, __photoOverHandler);
				display.removeEventListener(MouseEvent.MOUSE_OUT, __photoOutHandler);
				DisposeHelper.dispose(display.parent);
				DisposeHelper.dispose(display);
			}
		}
		
		private function __pageNumberClickHandler(e:MouseEvent):void
		{
			if(_currentPage == int((e.currentTarget as Button).txt.text)) return;
			
			_currentPage = int((e.currentTarget as Button).txt.text);
			var cols:int = _currentAlbums.cols;
			var rows:int = _currentAlbums.rows;
			var pageSize:int = cols * rows;
			_pageFirstIndex = pageSize * (_currentPage - 1);
			currentPageBtn = _pageNumberList[_currentPage - 1];
			showPageByPageFirst(_pageFirstIndex);
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
		
		private function refreshDataViewPos():void
		{
			if(_coverList == null || _coverList.length == 0) return;
			var cols:int = _currentAlbums.cols;
			var rows:int = _currentAlbums.rows;
			var iw:int = _currentAlbums.itemWidth;
			var ih:int = _currentAlbums.itemHeight;
			var spacing:int = _currentAlbums.itemSpacing;
			var index:int = 0;
			var xPos:int = 0;
			var yPos:int = 0;
			for (var row:int = 0; row < rows; row++)
			{
				xPos = 0;
				for (var col:int = 0; col < cols; col++)
				{
					_coverList[index].parent.x = xPos;
					_coverList[index].parent.y = yPos;
					
					xPos += iw + spacing;
					index++;
					
					if(_coverList.length <= index) break;
				}
				yPos += ih + spacing;
				if(_coverList.length <= index) break;
			}
		}
		
		
		private function refreshPageNumberPos():void
		{
			if(_pageNumberList == null || _pageNumberList.length == 0) return;
			var spacing:int = _currentAlbums.pageNumberSpacing;
			_pageNumberList[0].x = _pageNumberList[0].y = 0;
			for(var i:int = 1; i < _pageNumberList.length; i++)
			{
				_pageNumberList[i].x = _pageNumberList[i - 1].x + _pageNumberList[i - 1].width + spacing;
				_pageNumberList[i].y = 0;
			}
		}
		
		override public function get width():Number
		{
			if(_bg) return _bg.width;
			return _currentAlbums.listContainerWidth;
		}
		
		override public function set width(value:Number):void
		{
			if(_bg) _bg.width = value;
		}
		
		override public function get height():Number
		{
			if(_bg) return _bg.height;
			return _currentAlbums.listContainerHeight;
		}
		
		override public function set height(value:Number):void
		{
			if(_bg) _bg.height = value;
		}

		public function dispose():void
		{
			clearListView();
			clearPageNumberList();
			
			DisposeHelper.dispose(_bg, false);
			_bg = null;
			
			DisposeHelper.dispose(_title);
			_title = null;
			
			DisposeHelper.dispose(_container);
			_container = null;
			
			DisposeHelper.dispose(_pageNumberContainer);
			_pageNumberContainer = null;
			
			_coverList = null;
			_coverDataList = null;
			
			_currentPageBtn = null;
			_albumsList = null;
			_lightingFilter = null;
			
			if(parent) parent.removeChild(this);
		}
	}
}