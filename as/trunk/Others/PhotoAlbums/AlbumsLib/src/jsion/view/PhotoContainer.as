package jsion.view
{
	import com.StageReference;
	import com.interfaces.IDispose;
	import com.utils.DisposeHelper;
	import com.utils.GraphicsHelper;
	import com.utils.MetricHelper;
	import com.utils.StringHelper;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import jsion.AlbumsMgr;
	import jsion.BitmapDataMgr;
	import jsion.data.PhotoPage;
	
	public class PhotoContainer extends Sprite implements IDispose
	{
		private var _photoPage:PhotoPage;
		private var _container:Sprite;
		
		private var _container1:Sprite;
		private var _container2:Sprite;
		private var _container3:Sprite;
		
		private var _bottomDisplay:DisplayObject;
		private var _middleDisplay:DisplayObject;
		private var _middleDisplay1:DisplayObject;
		private var _middleDisplay2:DisplayObject;
		private var _topDisplay:DisplayObject;
		
		private var _isLeft:Boolean;
		
		public function PhotoContainer(isLeft:Boolean = true)
		{
			_isLeft = isLeft;
		}

		public function get photoPage():PhotoPage
		{
			return _photoPage;
		}

		public function set photoPage(value:PhotoPage):void
		{
			if(_photoPage == value) return;
			_photoPage = value;
			if(_photoPage == null) return;
			
			initContainer();
			initDisplay();
			addChildren();
		}
		
		private function initContainer():void
		{
			x = _photoPage.containerX;
			y = _photoPage.containerY;
			
			if(_photoPage.picWidth != 0 && _photoPage.picHeight != 0)
			{
				scrollRect = new Rectangle(0, 0, _photoPage.picWidth, _photoPage.picHeight);
			}
			else if(AlbumsMgr.Instance.current && AlbumsMgr.Instance.current.pageWidth != 0 && AlbumsMgr.Instance.current.pageHeight != 0)
			{
				scrollRect = new Rectangle(0, 0, AlbumsMgr.Instance.current.pageWidth, AlbumsMgr.Instance.current.pageHeight);
			}
			
			if(_photoPage.isPreface)
			{
				DisposeHelper.dispose(_container1);
				_container1 = new Sprite();
				_container1.buttonMode = true;
				_container1.mouseEnabled = _photoPage.enableClick;
				_container1.scrollRect = new Rectangle(0, 0, _photoPage.prefacePicWidth, _photoPage.prefacePicHeight);
				updateDisplayPos(_container1, 0);
				updateDisplayEvent(_container1);
				addChild(_container1);
				
//				DisposeHelper.dispose(_container2);
				_container2 = new Sprite();
				_container2.buttonMode = true;
				_container2.mouseEnabled = _photoPage.enableClick;
				_container2.scrollRect = new Rectangle(0, 0, _photoPage.prefacePicWidth, _photoPage.prefacePicHeight);
				updateDisplayPos(_container2, 1);
				updateDisplayEvent(_container2);
				addChild(_container2);
				GraphicsHelper.drawRect(100, 100, _container2, 0x0);
				
				DisposeHelper.dispose(_container3);
				_container3 = new Sprite();
				_container3.buttonMode = true;
				_container3.mouseEnabled = _photoPage.enableClick;
				_container3.scrollRect = new Rectangle(0, 0, _photoPage.prefacePicWidth, _photoPage.prefacePicHeight);
				updateDisplayPos(_container3, 2);
				updateDisplayEvent(_container3);
				addChild(_container3);
			}
			else
			{
				DisposeHelper.dispose(_container);
				_container = new Sprite();
				_container.x = _photoPage.picX;
				_container.y = _photoPage.picY;
				_container.buttonMode = true;
				_container.mouseEnabled = _photoPage.enableClick;
				addChild(_container);
				
				_container.addEventListener(MouseEvent.MOUSE_MOVE, __mouseMoveHandler);
				_container.addEventListener(MouseEvent.CLICK, __clickHandler);
				_container.addEventListener(MouseEvent.MOUSE_DOWN, __mouseDownHandler);
				StageReference.addEventListener(MouseEvent.MOUSE_UP, __mouseUpHandler);
			}
		}
		
		private function __mouseUpHandler(e:MouseEvent):void
		{
			if(_container) _container.addEventListener(MouseEvent.MOUSE_MOVE, __mouseMoveHandler);
		}
		
		private function __mouseDownHandler(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			if(_container) _container.removeEventListener(MouseEvent.MOUSE_MOVE, __mouseMoveHandler);
		}
		
		private function __mouseMoveHandler(e:MouseEvent):void
		{
			if(_photoPage && _photoPage.enableScroll && AlbumsMgr.Instance.canFlip)
			{
				if(_photoPage.picWidth < _container.width)
				{
					_container.x = -(_container.mouseX * _container.scaleX) * (_container.width - _photoPage.picWidth) / _container.width;
				}
				
				if(_photoPage.picHeight < _container.height)
				{
					_container.y = -(_container.mouseY * _container.scaleY) * (_container.height - _photoPage.picHeight) / _container.height;
				}
			}
		}
		
		private function __clickHandler(e:MouseEvent):void
		{
			if(AlbumsMgr.Instance.canFlip == false) return;
			
			if(StringHelper.isNullOrEmpty(_photoPage.link) == false)
			{
				navigateToURL(new URLRequest(_photoPage.link), "_blank");
				return;
			}
			
			var container:PhotoDisplay = new PhotoDisplay();
			container.photoPage = _photoPage;
			var display:DisplayObject;
			
			display = createDisplay(_photoPage.slovePath(_photoPage.bottomPic), _photoPage.bottomPicX, _photoPage.bottomPicY, _photoPage.bottomPicRotate);
			if(display) container.addChild(display);
			
			display = createDisplay(_photoPage.slovePath(_photoPage.topPic), _photoPage.topPicX, _photoPage.topPicY, _photoPage.topPicRotate);
			if(display) container.addChild(display);
			
			display = createDisplay(_photoPage.slovePath(_photoPage.middlePic), _photoPage.middlePicX, _photoPage.middlePicY, _photoPage.middlePicRotate);
			if(display) container.addChild(display);
			
			display = createDisplay(_photoPage.slovePath(_photoPage.middlePic), _photoPage.middlePicX1, _photoPage.middlePicY1, _photoPage.middlePicRotate1);
			if(display) container.addChild(display);
			
			display = createDisplay(_photoPage.slovePath(_photoPage.middlePic), _photoPage.middlePicX2, _photoPage.middlePicY2, _photoPage.middlePicRotate2);
			if(display) container.addChild(display);
			
			AlbumsMgr.Instance.showPhoto(container);
			
//			AlbumsMgr.Instance.showAlbumsList();
//			AlbumsMgr.Instance.showAlbumsIndex();
//			AlbumsMgr.Instance.proxy.gotoCoverPage();
//			AlbumsMgr.Instance.proxy.gotoBackcPage();
//			AlbumsMgr.Instance.proxy.gotoPrePage();
//			AlbumsMgr.Instance.proxy.gotoNextPage();
//			AlbumsMgr.Instance.proxy.gotoPage(4);
		}
		
		private function initDisplay():void
		{
			DisposeHelper.dispose(_bottomDisplay);
			_bottomDisplay = createDisplay(_photoPage.slovePath(_photoPage.bottomPic), _photoPage.bottomPicX, _photoPage.bottomPicY, _photoPage.bottomPicRotate);
			updatePrefaceSize(_bottomDisplay, _photoPage.prefacePicWidth, _photoPage.prefacePicHeight);
			
			DisposeHelper.dispose(_topDisplay);
			_topDisplay = createDisplay(_photoPage.slovePath(_photoPage.topPic), _photoPage.topPicX, _photoPage.topPicY, _photoPage.topPicRotate);
			updatePrefaceSize(_topDisplay, _photoPage.prefacePicWidth, _photoPage.prefacePicHeight);
			
			DisposeHelper.dispose(_middleDisplay);
			_middleDisplay = createDisplay(_photoPage.slovePath(_photoPage.middlePic), _photoPage.middlePicX, _photoPage.middlePicY, _photoPage.middlePicRotate);
			updatePrefaceSize(_middleDisplay, _photoPage.prefacePicWidth, _photoPage.prefacePicHeight);
			
			if(_photoPage.isPreface) return;
			
			if(_photoPage.showMiddleExtend1)
			{
				DisposeHelper.dispose(_middleDisplay1);
				_middleDisplay1 = createDisplay(_photoPage.slovePath(_photoPage.middlePic), _photoPage.middlePicX1, _photoPage.middlePicY1, _photoPage.middlePicRotate1);
			}
			
			if(_photoPage.showMiddleExtend2)
			{
				DisposeHelper.dispose(_middleDisplay2);
				_middleDisplay2 = createDisplay(_photoPage.slovePath(_photoPage.middlePic), _photoPage.middlePicX2, _photoPage.middlePicY2, _photoPage.middlePicRotate2);
			}
		}
		
		private function createDisplay(path:String, posX:int, posY:int, rotate:int):DisplayObject
		{
			var bmp:Bitmap;
			var bmd:BitmapData = BitmapDataMgr.Instance.getBitmapData(path);
			
			if(bmd)
			{
				bmp = new Bitmap(bmd, PixelSnapping.AUTO, true);
				bmp.x = posX;
				bmp.y = posY;
				bmp.rotation = MetricHelper.toRadians(rotate);
			}
			
			return bmp;
		}
		
		private function updateDisplayEvent(display:DisplayObject):void
		{
			if(display)
			{
				display.addEventListener(MouseEvent.CLICK, __prefaceClickHandler);
				display.addEventListener(MouseEvent.MOUSE_DOWN, __mouseDownHandler);
			}
		}
		
		private function removeDisplayEvent(display:DisplayObject):void
		{
			if(display)
			{
				display.removeEventListener(MouseEvent.CLICK, __prefaceClickHandler);
				display.removeEventListener(MouseEvent.MOUSE_DOWN, __mouseDownHandler);
			}
		}
		
		private function __prefaceClickHandler(e:MouseEvent):void
		{
			var container:PhotoDisplay = new PhotoDisplay();
			container.photoPage = _photoPage;
			var display:DisplayObject;
			
			switch(e.currentTarget)
			{
				case _container1:
				{
					display = createDisplay(_photoPage.slovePath(_photoPage.topPic), _photoPage.topPicX, _photoPage.topPicY, _photoPage.topPicRotate);
					if(display) container.addChild(display);
					break;
				}
				case _container2:
				{
					display = createDisplay(_photoPage.slovePath(_photoPage.middlePic), _photoPage.middlePicX, _photoPage.middlePicY, _photoPage.middlePicRotate);
					if(display) container.addChild(display);
					break;
				}
				case _container3:
				{
					display = createDisplay(_photoPage.slovePath(_photoPage.bottomPic), _photoPage.bottomPicX, _photoPage.bottomPicY, _photoPage.bottomPicRotate);
					if(display) container.addChild(display);
					break;
				}
			}
			
			AlbumsMgr.Instance.showPhoto(container);
		}
			
		
		private function updateDisplaySize(display:DisplayObject, targetWidth:int, targetHeight:int):void
		{
			if(display == null) return;
			
			var s:Number = targetWidth / targetHeight;
			var swh:Number = display.width / display.height;
			
			var sx:Number = targetWidth / display.width;
			var sy:Number = targetHeight / display.height;
			
			var rltW:Number = display.width * sx;
			var rltH:Number = display.height * sx;
			
			if(rltH >= targetHeight)
			{
				display.scaleX = sx;
				display.scaleY = sx;
			}
			else
			{
				rltW = display.width * sy;
				rltH = display.height * sy;
				
				if(rltW >= targetWidth)
				{
					display.scaleX = sy;
					display.scaleY = sy;
				}
			}
			
			display.x = display.y = 0;
		}
		
		private function updatePrefaceSize(display:DisplayObject, targetWidth:int, targetHeight:int):void
		{
			if(display == null) return;
			if(_photoPage.isPreface) updateDisplaySize(display, targetWidth, targetHeight);
		}
		
		private function updateDisplayPos(display:DisplayObject, index:int):void
		{
			if(_photoPage.isPreface)
			{
				if(_photoPage.direction == "H")
				{
					display.x = _photoPage.firstPicX + index * _photoPage.prefacePicWidth + index * _photoPage.prefacePicSpacing;
					display.y = _photoPage.firstPicY;
				}
				else
				{
					display.x = _photoPage.firstPicX;
					display.y = _photoPage.firstPicY + index * _photoPage.prefacePicHeight + index * _photoPage.prefacePicSpacing;
				}
			}
		}
		
		private function addChildren():void
		{
			if(_photoPage.isPreface)
			{
				if(_bottomDisplay) _container3.addChild(_bottomDisplay);
				if(_middleDisplay) _container2.addChild(_middleDisplay);
				if(_topDisplay) _container1.addChild(_topDisplay);
			}
			else
			{
				if(_bottomDisplay) _container.addChild(_bottomDisplay);
				if(_middleDisplay2) _container.addChild(_middleDisplay2);
				if(_middleDisplay1) _container.addChild(_middleDisplay1);
				if(_middleDisplay) _container.addChild(_middleDisplay);
				if(_topDisplay) _container.addChild(_topDisplay);
				
				if(_photoPage && _photoPage.enableScale && AlbumsMgr.Instance.canFlip && _container)
				{
					updateDisplaySize(_container, _photoPage.picWidth, _photoPage.picHeight);
					_container.x = _photoPage.picX;
					_container.y = _photoPage.picY;
				}
			}
		}
		
		public function dispose():void
		{
			StageReference.removeEventListener(MouseEvent.MOUSE_UP, __mouseUpHandler);
			if(_container)
			{
				_container.removeEventListener(MouseEvent.MOUSE_MOVE, __mouseMoveHandler);
				_container.removeEventListener(MouseEvent.CLICK, __clickHandler);
				_container.removeEventListener(MouseEvent.MOUSE_DOWN, __mouseDownHandler);
			}
			
			removeDisplayEvent(_container1);
			removeDisplayEvent(_container2);
			removeDisplayEvent(_container3);
			
			DisposeHelper.dispose(_container);
			_container = null;
			
			DisposeHelper.dispose(_container1);
			_container1 = null;
			
			DisposeHelper.dispose(_container2);
			_container2 = null;
			
			DisposeHelper.dispose(_container3);
			_container3 = null;
			
			DisposeHelper.dispose(_bottomDisplay, false);
			_bottomDisplay = null;
			
			DisposeHelper.dispose(_middleDisplay, false);
			_middleDisplay = null;
			
			DisposeHelper.dispose(_middleDisplay1, false);
			_middleDisplay1 = null;
			
			DisposeHelper.dispose(_middleDisplay2, false);
			_middleDisplay2 = null;
			
			DisposeHelper.dispose(_topDisplay, false);
			_topDisplay = null;
			
			_photoPage = null;
			
			if(parent) parent.removeChild(this);
		}
	}
}