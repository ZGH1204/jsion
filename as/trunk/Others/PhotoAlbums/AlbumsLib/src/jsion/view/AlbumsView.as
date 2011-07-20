package jsion.view
{
	import com.StageReference;
	import com.interfaces.IDispose;
	import com.utils.DisposeHelper;
	import com.utils.StringHelper;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	
	import jsion.AlbumsMgr;
	import jsion.BitmapDataMgr;
	import jsion.contants.LayerType;
	import jsion.controls.Button;
	import jsion.data.Albums;

	public class AlbumsView extends Sprite implements IDispose
	{
		private var _albums:Albums;
		private var _background:Background;
		
		private var _nameTextField:TextField;
		private var _authorTextField:TextField;
		private var _descriptionTextField:TextField;
		
		private var _prePageBtn:Button;
		private var _nextPageBtn:Button;
		private var _selectBtn:Button;
		
		private var _coverBtn:Button;
		private var _backcBtn:Button;
		private var _directoryBtn:Button;
		
		private var _printBtn:Button;
		private var _commentsBtn:Button;
		
		private var _flipView:FlipView;
		
		public function AlbumsView()
		{
		}
		
		public function get albums():Albums
		{
			return _albums;
		}

		public function set albums(value:Albums):void
		{
			if(_albums == value) return;
			
			clearView();
			
			_albums = value;
			
			if(_albums == null) return;
			
			this.x = _albums.x;
			this.y = _albums.y;
			
			initBackground();
			
			initText();
			
			initButton();
			
			initBtnEvent();
			
			initFlip();
		}
		
		private function initBackground():void
		{
			DisposeHelper.dispose(_background);
			_background = new Background(StageReference.stage.stageWidth, StageReference.stage.stageHeight);
			var bmd:BitmapData = BitmapDataMgr.Instance.getBitmapData(_albums.slovePath(_albums.background));
			if(bmd) _background.display = new Bitmap(bmd);
			_background.layerOut = LayerType.DEFAULT;
			_background.refresh();
			addChild(_background);
		}
		
		private function initText():void
		{
			DisposeHelper.dispose(_nameTextField);
			_nameTextField = AlbumsMgr.createTextField(_albums.name, _albums.nameFont, _albums.nameSize, _albums.nameColor, _albums.nameBold, _albums.nameItalic, _albums.nameX, _albums.nameY);
			addChild(_nameTextField);
			
			DisposeHelper.dispose(_authorTextField);
			_authorTextField = AlbumsMgr.createTextField(_albums.author, _albums.authorFont, _albums.authorSize, _albums.authorColor, _albums.authorBold, _albums.authorItalic, _albums.authorX, _albums.authorY);
			addChild(_authorTextField);
			
			DisposeHelper.dispose(_descriptionTextField);
			_descriptionTextField = AlbumsMgr.createTextField(_albums.description, _albums.dscptFont, _albums.dscptSize, _albums.dscptColor, _albums.dscptBold, _albums.dscptItalic, _albums.dscptX, _albums.dscptY);
			addChild(_descriptionTextField);
		}
		
		private function initButton():void
		{
			DisposeHelper.dispose(_prePageBtn);
			_prePageBtn = AlbumsMgr.createButton(_albums.slovePath(_albums.prePageBtn), _albums.slovePath(_albums.prePageBtnOver), _albums.prePageBtnX, _albums.prePageBtnY);
			if(_prePageBtn.isExists) addChild(_prePageBtn);
			
			DisposeHelper.dispose(_nextPageBtn);
			_nextPageBtn = AlbumsMgr.createButton(_albums.slovePath(_albums.nextPageBtn), _albums.slovePath(_albums.nextPageBtnOver), _albums.nextPageBtnX, _albums.nextPageBtnY);
			if(_nextPageBtn.isExists) addChild(_nextPageBtn);
			
			DisposeHelper.dispose(_selectBtn);
			_selectBtn = AlbumsMgr.createButton(_albums.slovePath(_albums.selectAlbumsBtn), _albums.slovePath(_albums.selectAlbumsBtnOver), _albums.selectAlbumsBtnX, _albums.selectAlbumsBtnY);
			if(_selectBtn.isExists) addChild(_selectBtn);
			
			DisposeHelper.dispose(_printBtn);
			_printBtn = AlbumsMgr.createButtonAndText(_albums.slovePath(_albums.printPage), _albums.slovePath(_albums.printPageOver), _albums.printPageX, _albums.printPageY, _albums.printName, _albums.printFont, _albums.printSize, _albums.printColor, _albums.printBold, _albums.printItalic);
			if(_printBtn.isExists) addChild(_printBtn);
			
			DisposeHelper.dispose(_commentsBtn);
			_commentsBtn = AlbumsMgr.createButtonAndText(_albums.slovePath(_albums.commentsPage), _albums.slovePath(_albums.commentsPageOver), _albums.commentsPageX, _albums.commentsPageY, _albums.commentsName, _albums.commentsFont, _albums.commentsSize, _albums.commentsColor, _albums.commentsBold, _albums.commentsItalic);
			if(_commentsBtn.isExists) addChild(_commentsBtn);
			
			DisposeHelper.dispose(_coverBtn);
			_coverBtn = AlbumsMgr.createButtonAndText(_albums.slovePath(_albums.coverBtn), _albums.slovePath(_albums.coverBtnOver), _albums.coverBtnX, _albums.coverBtnY, _albums.coverBtnText, _albums.coverBtnFont, _albums.coverBtnSize, _albums.coverBtnColor, _albums.coverBtnBold, _albums.coverBtnItalic);
			if(_coverBtn.isExists) addChild(_coverBtn);
			
			DisposeHelper.dispose(_backcBtn);
			_backcBtn = AlbumsMgr.createButtonAndText(_albums.slovePath(_albums.backcBtn), _albums.slovePath(_albums.backcBtnOver), _albums.backcBtnX, _albums.backcBtnY, _albums.backcBtnText, _albums.backcBtnFont, _albums.backcBtnSize, _albums.backcBtnColor, _albums.backcBtnBold, _albums.backcBtnItalic);
			if(_backcBtn.isExists) addChild(_backcBtn);
			
			DisposeHelper.dispose(_directoryBtn);
			_directoryBtn = AlbumsMgr.createButtonAndText(_albums.slovePath(_albums.directoryBtn), _albums.slovePath(_albums.directoryBtnOver), _albums.directoryBtnX, _albums.directoryBtnY, _albums.directoryText, _albums.directoryFont, _albums.directorySize, _albums.directoryColor, _albums.directoryBold, _albums.directoryItalic);
			if(_directoryBtn.isExists) addChild(_directoryBtn);
		}
		
		private function initBtnEvent():void
		{
			_coverBtn.addEventListener(MouseEvent.CLICK, __coverClickHandler);
			_backcBtn.addEventListener(MouseEvent.CLICK, __backcClickHandler);
			_directoryBtn.addEventListener(MouseEvent.CLICK, __directoryClickHandler);
			_prePageBtn.addEventListener(MouseEvent.CLICK, __preClickHandler);
			_nextPageBtn.addEventListener(MouseEvent.CLICK, __nextClickHandler);
			_selectBtn.addEventListener(MouseEvent.CLICK, __selectClickHandler);
			_printBtn.addEventListener(MouseEvent.CLICK, __printClickHandler);
			_commentsBtn.addEventListener(MouseEvent.CLICK, __commentClickHandler);
		}
		
		private function removeBtnEvent():void
		{
			if(_coverBtn) _coverBtn.addEventListener(MouseEvent.CLICK, __coverClickHandler);
			if(_backcBtn) _backcBtn.addEventListener(MouseEvent.CLICK, __backcClickHandler);
			if(_directoryBtn) _directoryBtn.addEventListener(MouseEvent.CLICK, __directoryClickHandler);
			if(_prePageBtn) _prePageBtn.removeEventListener(MouseEvent.CLICK, __preClickHandler);
			if(_nextPageBtn) _nextPageBtn.removeEventListener(MouseEvent.CLICK, __nextClickHandler);
			if(_selectBtn) _selectBtn.removeEventListener(MouseEvent.CLICK, __selectClickHandler);
			if(_printBtn) _printBtn.removeEventListener(MouseEvent.CLICK, __printClickHandler);
			if(_commentsBtn) _commentsBtn.removeEventListener(MouseEvent.CLICK, __commentClickHandler);
		}
		
		private function __coverClickHandler(e:MouseEvent):void
		{
			if(AlbumsMgr.Instance.proxy) AlbumsMgr.Instance.proxy.gotoCoverPage();
		}
		
		private function __backcClickHandler(e:MouseEvent):void
		{
			if(AlbumsMgr.Instance.proxy) AlbumsMgr.Instance.proxy.gotoBackcPage();
		}
		
		private function __directoryClickHandler(e:MouseEvent):void
		{
			AlbumsMgr.Instance.showAlbumsIndex();
		}
		
		private function initFlip():void
		{
			DisposeHelper.dispose(_flipView);
			_flipView = new FlipView();
			_flipView.albums = _albums;
			addChild(_flipView);
		}
		
		private function __preClickHandler(e:MouseEvent):void
		{
			if(AlbumsMgr.Instance.proxy) AlbumsMgr.Instance.proxy.gotoPrePage();
		}
		
		private function __nextClickHandler(e:MouseEvent):void
		{
			if(AlbumsMgr.Instance.proxy) AlbumsMgr.Instance.proxy.gotoNextPage();
		}
		
		private function __selectClickHandler(e:MouseEvent):void
		{
			AlbumsMgr.Instance.showAlbumsList();
		}
		
		private function __printClickHandler(e:MouseEvent):void
		{
			if(StringHelper.isNullOrEmpty(_albums.printUrl)) return;
			navigateToURL(new URLRequest(_albums.printUrl), "_blank");
		}
		
		private function __commentClickHandler(e:MouseEvent):void
		{
			if(StringHelper.isNullOrEmpty(_albums.commentsUrl)) return;
			navigateToURL(new URLRequest(_albums.commentsUrl), "_blank");
		}
		
		public function clearView():void
		{
			if(_albums == null) return;
		}

		public function dispose():void
		{
			removeBtnEvent();
			
			DisposeHelper.dispose(_background);
			_background = null;
			
			DisposeHelper.dispose(_nameTextField);
			_nameTextField = null;
			
			DisposeHelper.dispose(_authorTextField);
			_authorTextField = null;
			
			DisposeHelper.dispose(_descriptionTextField);
			_descriptionTextField = null;
			
			DisposeHelper.dispose(_coverBtn);
			_prePageBtn = null;
			
			DisposeHelper.dispose(_backcBtn);
			_backcBtn = null;
			
			DisposeHelper.dispose(_directoryBtn);
			_directoryBtn = null;
			
			DisposeHelper.dispose(_prePageBtn);
			_prePageBtn = null;
			
			DisposeHelper.dispose(_nextPageBtn);
			_nextPageBtn = null;
			
			DisposeHelper.dispose(_selectBtn);
			_selectBtn = null;
			
			DisposeHelper.dispose(_printBtn);
			_printBtn = null;
			
			DisposeHelper.dispose(_commentsBtn);
			_commentsBtn = null;
			
			DisposeHelper.dispose(_flipView);
			_flipView = null;
			
			_albums = null;
			
			if(parent) parent.removeChild(this);
		}
	}
}