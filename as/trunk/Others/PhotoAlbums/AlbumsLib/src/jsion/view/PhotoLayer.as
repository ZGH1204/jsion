package jsion.view
{
	import com.interfaces.IDispose;
	import com.utils.DisposeHelper;
	import com.utils.StringHelper;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import jsion.AlbumsMgr;
	import jsion.BitmapDataMgr;
	import jsion.data.PhotoPage;
	
	public class PhotoLayer extends Sprite implements IDispose
	{
		protected var _photoPage:PhotoPage;
		
		protected var _prefacePic:DisplayObject;
		protected var _photoContainer:PhotoContainer;
		protected var _textContainer:Sprite;
		
		protected var _textField:TextField;
		
		protected var _isLeft:Boolean;
		
		public function PhotoLayer(isLeft:Boolean = true)
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
			
			initPrefacePic();
			
			initContainer();
			
			initTextView();
		}
		
		private function initPrefacePic():void
		{
			if(_photoPage.isPreface)
			{
				DisposeHelper.dispose(_prefacePic);
				_prefacePic = null;
				var bmd:BitmapData = BitmapDataMgr.Instance.getBitmapData(_photoPage.slovePath(_photoPage.prefacePic));
				if(bmd) _prefacePic = new Bitmap(bmd.clone());
				if(_prefacePic)
				{
					_prefacePic.x = _photoPage.prefacePicX;
					_prefacePic.y = _photoPage.prefacePicY;
					addChild(_prefacePic);
				}
			}
		}
		
		private function initContainer():void
		{
			DisposeHelper.dispose(_photoContainer);
			_photoContainer = new PhotoContainer(_isLeft);
			_photoContainer.photoPage = _photoPage;
			addChild(_photoContainer);
			
			DisposeHelper.dispose(_textContainer);
			_textContainer = new Sprite();
			addChild(_textContainer);
		}
		
		protected function initTextView():void
		{
			DisposeHelper.dispose(_textField);
			_textField = AlbumsMgr.createTextField(_photoPage.text, _photoPage.font, _photoPage.size, _photoPage.color, _photoPage.bold, _photoPage.italic, _photoPage.textX, _photoPage.textY);
			addChild(_textField);
		}

		public function dispose():void
		{
			DisposeHelper.dispose(_prefacePic);
			_prefacePic = null;
			
			DisposeHelper.dispose(_photoContainer);
			_photoContainer = null;
			
			DisposeHelper.dispose(_textContainer);
			_textContainer = null;
			
			DisposeHelper.dispose(_textField);
			_textField = null;
			
			_photoPage = null;
			
			if(parent) parent.removeChild(this);
		}
	}
}