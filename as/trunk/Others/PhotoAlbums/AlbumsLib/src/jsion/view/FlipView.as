package jsion.view
{
	import com.interfaces.IDispose;
	import com.utils.DisposeHelper;
	import com.utils.GraphicsHelper;
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import jsion.AlbumsMgr;
	import jsion.data.Albums;
	
	public class FlipView extends Sprite implements IDispose
	{
		public static const HOT_WIDTH:int = 30;
		public static const HOT_HEIGHT:int = 30;
		
		private var _albums:Albums;
		
		private var _pageContainer:Sprite;
		private var _leftPageView:AlbumsPhotoPage;
		private var _rightPageView:AlbumsPhotoPage;
		
		private var _filpContainer:Sprite;
		private var _shadowContainer:Sprite;
		private var _helperContainer:Sprite;
		private var _shape:Shape;
		
		private var _proxy:FlipProxy;
		
		public function FlipView()
		{
			super();
		}
		
		public function get albums():Albums
		{
			return _albums;
		}

		public function set albums(value:Albums):void
		{
			if(_albums == value) return;
			_albums = value;
			if(_albums == null) return;
			
			initPage();
		}
		
		private function initPage():void
		{
			_proxy = new FlipProxy();
			_proxy.curAlbums = _albums;
			AlbumsMgr.Instance.proxy = _proxy;
			
			_pageContainer = new Sprite();
			addChild(_pageContainer);
			
			_helperContainer = new Sprite();
			addChild(_helperContainer);
			_proxy.helperContainer = _helperContainer;
			
			_shadowContainer = new Sprite();
			addChild(_shadowContainer);
			_proxy.shadowContainer = _shadowContainer;
			
			_filpContainer = new Sprite();
			addChild(_filpContainer);
			
			_proxy.leftPage = _proxy.getShowInitFirst();
			_leftPageView = _proxy.createPage(_proxy.leftPage, true);
//			_leftPage = _proxy.createCover();
			_pageContainer.addChild(_leftPageView);
			
			_proxy.rightPage = _proxy.getShowInitSecond();
			_rightPageView = _proxy.createPage(_proxy.rightPage, false);
//			_rightPage = _proxy.createBackc();
			_pageContainer.addChild(_rightPageView);
			
			_shape = new Shape();
			_shape.graphics.clear();
			_filpContainer.addChild(_shape);
			
			_proxy.shape = _shape;
			
			_proxy.mouseUpCallback = mouseUpCallback;
			_proxy.mouseDownCallback = mouseDownCallback;
			_proxy.flipComplete = flipComplete;
			
			_proxy.start();
		}
		
		private function createHot(xPos:int, yPos:int):Sprite
		{
			var hot:Sprite = new Sprite();
			GraphicsHelper.drawRect(HOT_WIDTH, HOT_HEIGHT, hot, 0x0, 0);
			hot.x = xPos;
			hot.y = yPos;
			_filpContainer.addChild(hot);
			return hot;
		}
		
		private function mouseUpCallback():void
		{
			if(_pageContainer) _pageContainer.mouseEnabled = _pageContainer.mouseChildren = true;
		}
		
		private function mouseDownCallback():void
		{
			if(_pageContainer) _pageContainer.mouseEnabled = _pageContainer.mouseChildren = false;
		}
		
		private function flipComplete():void
		{
			setPage(_proxy.flipView);
			setPage(_proxy.flipSecondView);
			
			_proxy.flipView = null;
			_proxy.flipSecondView = null;
		}
		
		public function setPage(page:AlbumsPhotoPage):void
		{
			if(page == null) return;
			var old:AlbumsPhotoPage;
			if(page.isLeft)
			{
				old = _leftPageView;
				_leftPageView = page;
				_pageContainer.addChild(_leftPageView);
			}
			else
			{
				old = _rightPageView;
				_rightPageView = page;
				_pageContainer.addChild(_rightPageView);
			}
			
			DisposeHelper.dispose(old);
			old = null;
		}

		public function dispose():void
		{
			DisposeHelper.dispose(_pageContainer);
			_pageContainer = null;
			
			DisposeHelper.dispose(_leftPageView);
			_leftPageView = null;
			
			DisposeHelper.dispose(_rightPageView);
			_rightPageView = null;
			
			DisposeHelper.dispose(_filpContainer);
			_filpContainer = null;
			
			DisposeHelper.dispose(_shadowContainer);
			_shadowContainer = null;
			
			DisposeHelper.dispose(_helperContainer);
			_helperContainer = null;
			
			DisposeHelper.dispose(_shape);
			_shape = null;
			
			DisposeHelper.dispose(_proxy);
			_proxy = null;
			
			_albums = null;
			
			if(parent) parent.removeChild(this);
		}
	}
}