package jsion.view
{
	import com.interfaces.IDispose;
	import com.utils.RandomHelper;
	import com.utils.StringHelper;
	
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.ID3Info;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.text.TextField;
	
	import jsion.contants.PlayMusicMode;
	import jsion.data.PlayList;

	public class MusicProxy implements IDispose
	{
		public var playList:PlayList;
		public var titleText:TextField;
		
		private var _isPlayComplete:Boolean;
		private var _isPlayError:Boolean;
		private var _isPlaying:Boolean;

		public function get isPlaying():Boolean
		{
			return _isPlaying;
		}

		public function set isPlaying(value:Boolean):void
		{
			_isPlaying = value;
		}

		private var _isPause:Boolean;

		public function get isPause():Boolean
		{
			return _isPause;
		}

		public function set isPause(value:Boolean):void
		{
			_isPause = value;
		}

		private var _isMute:Boolean;

		public function get isMute():Boolean
		{
			return _isMute;
		}

		public function set isMute(value:Boolean):void
		{
			_isMute = value;
			if(_currentSoundChannel)
			{
				if(_isMute)
					_currentSoundChannel.soundTransform = new SoundTransform(0);
				else
					_currentSoundChannel.soundTransform = new SoundTransform(1);
			}
		}
		
		private var _isStop:Boolean = true;

		public function get isStop():Boolean
		{
			return _isStop;
		}

		public function set isStop(value:Boolean):void
		{
			_isStop = value;
		}


		private var _pausePosition:Number = 0;
		
		private var _currentIndex:int = -1;
		private var _currentSound:Sound;
		private var _currentSoundChannel:SoundChannel;
		
		public function startPlay():void
		{
			if(playList == null || playList.autoPlay == false) return;
			playNext();
		}
		
		public function getNextMusic(curIndex:int = -1):int
		{
			var index:int = -1;
			switch(playList.playMode)
			{
				case PlayMusicMode.LIST_PLAY://列表顺序
				{
					index = curIndex + 1;
					break;
				}
				case PlayMusicMode.LIST_REPEAT://列表循环
				{
					index = curIndex + 1;
					if(index >= playList.items.length) index = 0;
					break;
				}
				case PlayMusicMode.SINGLE_PLAY://单曲
				{
					index = curIndex;
					break;
				}
				case PlayMusicMode.RADOM_PLAY://随机
				{
					index = RandomHelper.randomRange(0, playList.items.length);
					if(index >= playList.items.length) index = playList.items.length - 1;
					break;
				}
				default:
				{
					index = curIndex + 1;
					if(index >= playList.items.length) index = 0;
					break;
				}
			}
			if(index >= playList.items.length || index < 0) index = -1;
//			if(_isPlayComplete == false) index = 0;
			
			return index;
		}
		
		public function getPreMusic(curIndex:int):int
		{
			var index:int = -1;
			switch(playList.playMode)
			{
				case PlayMusicMode.LIST_PLAY://列表顺序
				{
					index = curIndex - 1;
					break;
				}
				case PlayMusicMode.LIST_REPEAT://列表循环
				{
					index = curIndex - 1;
					if(index < 0) index = playList.items.length - 1;
					break;
				}
				case PlayMusicMode.SINGLE_PLAY://单曲
				{
					index = curIndex;
					break;
				}
				case PlayMusicMode.RADOM_PLAY://随机
				{
					index = RandomHelper.randomRange(0, playList.items.length);
					if(index >= playList.items.length) index = playList.items.length - 1;
					break;
				}
			}
			if(index >= playList.items.length || index < 0) index = -1;
			
			return index;
		}
		
		public function playNext():void
		{
			if(playList && playList.playMode == PlayMusicMode.SINGLE_PLAY)
			{
				playList.playMode = PlayMusicMode.LIST_REPEAT;
				play(getNextMusic(_currentIndex));
				playList.playMode = PlayMusicMode.SINGLE_PLAY;
				return;
			}
			play(getNextMusic(_currentIndex));
		}
		
		public function playPre():void
		{
			if(playList && playList.playMode == PlayMusicMode.SINGLE_PLAY)
			{
				playList.playMode = PlayMusicMode.LIST_REPEAT;
				play(getPreMusic(_currentIndex));
				playList.playMode = PlayMusicMode.SINGLE_PLAY;
				return;
			}
			play(getPreMusic(_currentIndex));
		}
		
		public function pause():void
		{
			if(_currentSound && _currentSoundChannel)
			{
				_isPause = true;
				_isPlaying = false;
				_pausePosition = _currentSoundChannel.position;
				disposeSoundChannel();
			}
		}
		
		public function stop():void
		{
			disposeSoundChannel();
		}
		
		public function mute(m:Boolean):void
		{
			_isMute = m;
			if(_currentSoundChannel)
			{
				if(_isMute == true) _currentSoundChannel.soundTransform = new SoundTransform(0);
				else _currentSoundChannel.soundTransform = new SoundTransform(1);
			}
		}
		
		public function play(index:int):void
		{
			if(_isPause)
			{
				_isPause = false;
				_currentSoundChannel = playSound(_currentSound, _pausePosition);
				_pausePosition = 0;
				return;
			}
			
			if(_currentIndex == index && _isPlayComplete)
			{
				_isPlayComplete = false;
				disposeSoundChannel();
				_currentSoundChannel = playSound(_currentSound);
				return;
			}
			
			if(_isPlayError && index == (playList.items.length - 1)) return;
			
			_currentIndex = index;
			
			disposeSound();
			disposeSoundChannel();
			
			if(index < 0 || index >= playList.items.length) return;
			
			var url:String = playList.items[index].slovePath(playList.items[index].url);
			
			if(StringHelper.isNullOrEmpty(url)) return;
			
			_currentSound = createSound(url);
			_currentSoundChannel = playSound(_currentSound);
		}
		
		private function createSound(url:String):Sound
		{
			if(StringHelper.isNullOrEmpty(url)) return null;
			var sound:Sound = new Sound(new URLRequest(url), new SoundLoaderContext(30000, false));
			sound.addEventListener(Event.ID3, __id3Handler);
			sound.addEventListener(IOErrorEvent.IO_ERROR, __errorHandler);
			return sound;
		}
		
		private function playSound(sound:Sound, startPosition:Number = 0):SoundChannel
		{
			if(sound == null) return null;
			var sc:SoundChannel = sound.play(startPosition);
			if(sc)
			{
				_isPlaying = true;
				_isPlayError = false;
				_isStop = false;
				_isPlayComplete = false;
				_isPause = false;
				
				if(_isMute) sc.soundTransform = new SoundTransform(0);
				else sc.soundTransform = new SoundTransform(1);
				
				updateTitle();
				
				sc.addEventListener(Event.SOUND_COMPLETE, __playCompleteHandler);
			}
			else
			{
				_isPlaying = false;
				_isPlayError = true;
				_isStop = true;
				_isPlayComplete = true;
			}
			
			
			return sc;
		}
		
		private function updateTitle(id3:ID3Info = null):void
		{
			if(StringHelper.isNullOrEmpty(playList.items[_currentIndex].songName))
			{
				if(id3 == null) return;
				
				if(StringHelper.isNullOrEmpty(id3.songName))
				{
					if(titleText)
					{
						titleText.x = 0;
						titleText.text = _currentSound.url.split("/")[0];
					}
				}
				else
				{
					if(titleText) titleText.text = id3.songName;
					titleText.x = 0;
				}
			}
			else
			{
				if(titleText)
				{
					titleText.x = 0;
					titleText.text = playList.items[_currentIndex].songName;
				}
			}
			
			if(StringHelper.isNullOrEmpty(playList.items[_currentIndex].songName) && StringHelper.isNullOrEmpty(playList.items[_currentIndex].artist))
			{
				if(id3 == null) return;
				if(StringHelper.isNullOrEmpty(id3.artist) == false)
				{
					if(titleText) titleText.appendText(" - " + id3.artist);
				}
			}
			else
			{
				if(StringHelper.isNullOrEmpty(playList.items[_currentIndex].artist) == false && titleText)
				{
					titleText.appendText(" - " + playList.items[_currentIndex].artist);
				}
			}
		}
		
		private function disposeSound():void
		{
			if(_currentSound)
			{
				_currentSound.removeEventListener(Event.ID3, __id3Handler);
				_currentSound.removeEventListener(IOErrorEvent.IO_ERROR, __errorHandler);
//				_currentSound.close();
				_currentSound = null;
			}
		}
		
		private function disposeSoundChannel():void
		{
			if(_currentSoundChannel)
			{
				_currentSoundChannel.removeEventListener(Event.SOUND_COMPLETE, __playCompleteHandler);
				_currentSoundChannel.stop();
				_currentSoundChannel = null;
				_isPlaying = false;
				_isStop = true;
			}
		}
		
		private function __playCompleteHandler(e:Event):void
		{
			_isPlayComplete = true;
			_isPlayError = false;
			_isPlaying = false;
			play(getNextMusic(_currentIndex));
		}
		
		private function __errorHandler(e:IOErrorEvent):void
		{
			_isPlayError = true;
			play(getNextMusic(_currentIndex));
		}
		
		private function __id3Handler(e:Event):void
		{
			var sound:Sound = e.currentTarget as Sound;
			if(sound && StringHelper.isNullOrEmpty(playList.items[_currentIndex].songName) && StringHelper.isNullOrEmpty(playList.items[_currentIndex].artist))
			{
				updateTitle(sound.id3);
			}
		}
		
		public function get currentIndex():int
		{
			return _currentIndex;
		}
		
		public function set currentIndex(value:int):void
		{
			_currentIndex = value;
		}
		
		public function dispose():void
		{
			disposeSoundChannel();
			disposeSound();
			
			playList = null;
			titleText = null;
		}
	}
}