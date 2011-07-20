package jsion.view
{
	import com.StageReference;
	import com.interfaces.IDispose;
	import com.managers.BitmapDataManager;
	import com.utils.DisposeHelper;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import jsion.AlbumsMgr;
	import jsion.BitmapDataMgr;
	import jsion.PlayerMgr;
	import jsion.controls.Button;
	import jsion.data.PlayList;
	import jsion.data.PlayerSkin;
	
	public class PlayerView extends Sprite implements IDispose
	{
		private var _titleBg:Bitmap;
		private var _titleText:TextField;
		private var _titleContainer:Sprite;
		
		private var _preBtn:Button;
		private var _nextBtn:Button;
		private var _playBtn:Button;
		private var _pauseBtn:Button;
		private var _stopBtn:Button;
		private var _muteBtn:Button;
		private var _unMuteBtn:Button;
		
		private var _proxy:MusicProxy;
		
		private var _playList:PlayList;
		private var _skin:PlayerSkin;
		
		public function PlayerView()
		{
			super();
		}
		
		private function initialize():void
		{
			if(_skin == null) return;
			x = _skin.playerX;
			y = _skin.playerY;
			
			StageReference.stage.addEventListener(Event.ENTER_FRAME, __enterFrameHandler);
		}
		
		private function __enterFrameHandler(e:Event):void
		{
			if(_titleText && _skin && _titleText.textWidth > _skin.titleScrollWidth && _skin.titleScrollWidth > 0 && _skin.titleStep > 0)
			{
				_titleText.x -= _skin.titleStep;
				
				if(Math.abs(_titleText.x) > _titleText.textWidth) _titleText.x = _skin.titleScrollWidth;
			}
		}
		
		private function initContainer():void
		{
			if(_skin == null) return;
			
			DisposeHelper.dispose(_titleContainer);
			_titleContainer = new Sprite();
			_titleContainer.x = _skin.titleX;
			_titleContainer.y = _skin.titleY;
			if(_skin.titleScrollWidth != 0 && _skin.titleScrollHeight != 0)
				_titleContainer.scrollRect = new Rectangle(0, 0, _skin.titleScrollWidth, _skin.titleScrollHeight);
			addChild(_titleContainer);
		}
		
		private function initSkin():void
		{
			if(_skin == null) return;
			
			DisposeHelper.dispose(_titleBg);
			_titleBg = null;
			var bmd:BitmapData = BitmapDataMgr.Instance.getBitmapData(_skin.slovePath(_skin.titleBg));
			if(bmd) _titleBg = new Bitmap(bmd.clone());
			if(_titleBg)
			{
				if(_skin.titleScrollWidth == 0 || _skin.titleScrollHeight == 0)
				{
					_skin.titleScrollWidth = _titleBg.width;
					_skin.titleScrollHeight = _titleBg.height;
					_titleContainer.scrollRect = new Rectangle(0, 0, _titleBg.width, _titleBg.height);
				}
				_titleBg.x = _skin.titleBgX;
				_titleBg.y = _skin.titleBgY;
				_titleContainer.addChild(_titleBg);
			}
			
			DisposeHelper.dispose(_preBtn);
			_preBtn = AlbumsMgr.createButton(_skin.slovePath(_skin.preTrackBtn), _skin.slovePath(_skin.preTrackBtnOver), _skin.preTrackBtnX, _skin.preTrackBtnY);
			if(_preBtn.isExists) addChild(_preBtn);
			
			DisposeHelper.dispose(_nextBtn);
			_nextBtn = AlbumsMgr.createButton(_skin.slovePath(_skin.nextTrackBtn), _skin.slovePath(_skin.nextTrackBtnOver), _skin.nextTrackBtnX, _skin.nextTrackBtnY);
			if(_nextBtn.isExists) addChild(_nextBtn);
			
			DisposeHelper.dispose(_playBtn);
			_playBtn = AlbumsMgr.createButton(_skin.slovePath(_skin.playBtn), _skin.slovePath(_skin.playBtnOver), _skin.playBtnX, _skin.playBtnY);
			if(_playBtn.isExists) addChild(_playBtn);
			
			DisposeHelper.dispose(_pauseBtn);
			_pauseBtn = AlbumsMgr.createButton(_skin.slovePath(_skin.pauseBtn), _skin.slovePath(_skin.pauseBtnOver), _skin.playBtnX, _skin.playBtnY);
			if(_pauseBtn.isExists) addChild(_pauseBtn);
			
			DisposeHelper.dispose(_stopBtn);
			_stopBtn = AlbumsMgr.createButton(_skin.slovePath(_skin.stopBtn), _skin.slovePath(_skin.stopBtnOver), _skin.stopBtnX, _skin.stopBtnY);
			if(_stopBtn.isExists) addChild(_stopBtn);
			
			DisposeHelper.dispose(_muteBtn);
			_muteBtn = AlbumsMgr.createButton(_skin.slovePath(_skin.muteBtn), _skin.slovePath(_skin.muteBtnOver), _skin.muteBtnX, _skin.muteBtnY);
			if(_muteBtn.isExists) addChild(_muteBtn);
			
			DisposeHelper.dispose(_unMuteBtn);
			_unMuteBtn = AlbumsMgr.createButton(_skin.slovePath(_skin.unMuteBtn), _skin.slovePath(_skin.unMuteBtnOver), _skin.muteBtnX, _skin.muteBtnY);
			if(_unMuteBtn.isExists) addChild(_unMuteBtn);
			
			DisposeHelper.dispose(_titleText);
			_titleText = AlbumsMgr.createTextField("", _skin.titleFont, _skin.titleSize, _skin.titleColor, _skin.titleBold, _skin.titleItalic, _skin.titleTextX, _skin.titleTextY);
			if(_titleText) _titleContainer.addChild(_titleText);
			
			if(_proxy && _titleText) _proxy.titleText = _titleText;
		}
		
		private function uninitSkin():void
		{
			DisposeHelper.dispose(_titleContainer);
			_titleContainer = null;
			
			DisposeHelper.dispose(_titleBg);
			_titleBg = null;
			
			DisposeHelper.dispose(_preBtn);
			_preBtn = null;
			
			DisposeHelper.dispose(_nextBtn);
			_nextBtn = null;
			
			DisposeHelper.dispose(_playBtn);
			_playBtn = null;
			
			DisposeHelper.dispose(_pauseBtn);
			_pauseBtn = null;
			
			DisposeHelper.dispose(_stopBtn);
			_stopBtn = null;
			
			DisposeHelper.dispose(_muteBtn);
			_muteBtn = null;
			
			DisposeHelper.dispose(_unMuteBtn);
			_unMuteBtn = null;
			
			DisposeHelper.dispose(_titleText);
			_titleText = null;
			
			_skin = null;
		}
		
		private function initBtnEvent():void
		{
			if(_preBtn && _preBtn.isExists) _preBtn.addEventListener(MouseEvent.CLICK, __btnClickHandler);
			if(_nextBtn && _nextBtn.isExists) _nextBtn.addEventListener(MouseEvent.CLICK, __btnClickHandler);
			if(_playBtn && _playBtn.isExists) _playBtn.addEventListener(MouseEvent.CLICK, __btnClickHandler);
			if(_pauseBtn && _pauseBtn.isExists) _pauseBtn.addEventListener(MouseEvent.CLICK, __btnClickHandler);
			if(_stopBtn && _stopBtn.isExists) _stopBtn.addEventListener(MouseEvent.CLICK, __btnClickHandler);
			if(_muteBtn && _muteBtn.isExists) _muteBtn.addEventListener(MouseEvent.CLICK, __btnClickHandler);
			if(_unMuteBtn && _unMuteBtn.isExists) _unMuteBtn.addEventListener(MouseEvent.CLICK, __btnClickHandler);
		}
		
		private function removeBtnEvent():void
		{
			if(_preBtn && _preBtn.isExists) _preBtn.removeEventListener(MouseEvent.CLICK, __btnClickHandler);
			if(_nextBtn && _nextBtn.isExists) _nextBtn.removeEventListener(MouseEvent.CLICK, __btnClickHandler);
			if(_playBtn && _playBtn.isExists) _playBtn.removeEventListener(MouseEvent.CLICK, __btnClickHandler);
			if(_pauseBtn && _pauseBtn.isExists) _pauseBtn.removeEventListener(MouseEvent.CLICK, __btnClickHandler);
			if(_stopBtn && _stopBtn.isExists) _stopBtn.removeEventListener(MouseEvent.CLICK, __btnClickHandler);
			if(_muteBtn && _muteBtn.isExists) _muteBtn.removeEventListener(MouseEvent.CLICK, __btnClickHandler);
			if(_unMuteBtn && _unMuteBtn.isExists) _unMuteBtn.removeEventListener(MouseEvent.CLICK, __btnClickHandler);
		}
		
		private function __btnClickHandler(e:MouseEvent):void
		{
			switch(e.currentTarget)
			{
				case _preBtn:
				{
					if(_proxy) _proxy.playPre();
					break;
				}
				case _nextBtn:
				{
					if(_proxy) _proxy.playNext();
					break;
				}
				case _playBtn:
				{
					if(_proxy)
					{
						if(_proxy.isPlaying == false)
							_proxy.play(_proxy.currentIndex);
						else if(_pauseBtn.isExists == false && _proxy.isPause == false)
							_proxy.pause();
					}
					updateBtn();
					break;
				}
				case _pauseBtn:
				{
					if(_proxy && _proxy.isPlaying == true) _proxy.pause();
					updateBtn();
					break;
				}
				case _stopBtn:
				{
					if(_proxy) _proxy.stop();
					updateBtn();
					break;
				}
				case _muteBtn:
				{
					if(_proxy) _proxy.mute(false);
					updateBtn();
					break;
				}
				case _unMuteBtn:
				{
					if(_proxy) _proxy.mute(true);
					updateBtn();
					break;
				}
			}
		}
		
		private function updateBtn():void
		{
			if(_proxy == null) return;
			if(_proxy.isPlaying)
			{
				if(_pauseBtn.isExists) _playBtn.visible = false;
				_pauseBtn.visible = true;
			}
			else if(_proxy.isPause)
			{
				_playBtn.visible = true;
				_pauseBtn.visible = false;
			}
			
			if(_proxy.isMute)
			{
				_muteBtn.visible = true;
				_unMuteBtn.visible = false;
			}
			else
			{
				_muteBtn.visible = false;
				_unMuteBtn.visible = true;
			}
		}
		
		public function get skin():PlayerSkin
		{
			return _skin;
		}
		
		public function set skin(value:PlayerSkin):void
		{
			if(value == null) return;
			_skin = value;
			
			initialize();
			initContainer();
			initSkin();
			initBtnEvent();
		}
		
		public function get playList():PlayList
		{
			return _playList;
		}

		public function set playList(value:PlayList):void
		{
			if(value == null) return;
			
			_playList = value;
			
			DisposeHelper.dispose(_proxy);
			_proxy = new MusicProxy();
			_proxy.playList = _playList;
			if(_titleText) _proxy.titleText = _titleText;
			_proxy.startPlay();
			updateBtn();
		}

		public function dispose():void
		{
			StageReference.stage.removeEventListener(Event.ENTER_FRAME, __enterFrameHandler);
			removeBtnEvent();
			uninitSkin();
			
			DisposeHelper.dispose(_proxy);
			_proxy = null;
			
			_playList = null;
			
			if(parent) parent.removeChild(this);
		}
	}
}