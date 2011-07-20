package com.manager
{
	import com.data.BattleMusicInfo;
	import com.data.LoadFlag;
	import com.data.LoopType;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	public class MusicManager
	{
		//////////////////////////////////////////////////////////			Common			//////////////////////////////////////////////////////////
		private var stage:Stage;
		private var musicRoot:String;
		private var curPlayingMusicList:Array;
		private var curMusicVolumn:int = 100;
		private var musicFailedTryTime:int = 3;
		private var curMusicFailedTime:int = 0;
		
		public function setup(musicRoot:String, stage:Stage):void
		{
			this.stage = stage;
			this.musicRoot = musicRoot;
			
			nc = new NetConnection();
			nc.connect(null);
			
			ns = new NetStream(nc);
			
			ns.client = this;
		}
		
		
		/////////////////////////////////////////////	战斗背景音乐   /////////////////////////////////////////////
		
		/**
		 * 每个FLV持续播放时间
		 */		
		private var bt_array:Array;
		/**
		 * 如果是战斗音乐则为当前正在播放的音乐，否则为null
		 */		
		private var curBattleMusic:NetStream = null;
		/**
		 * 如果是战斗音乐则为下一个要播放的BattleMusicInfo信息，否则为null
		 */		
		private var nextBattleMusic:BattleMusicInfo = null;
		/**
		 * 所有FLV的BattleMusicInfo对象
		 */		
		private var ns_array:Array = [];
		/**
		 * 每个FLV文件的时间长度，onMetaData事件后可用
		 */		
		private var tc_array:Array = [];
		/**
		 * 如果是战斗音乐则为当前正在播放的音乐，否则为-1
		 */		
		private var curBattleIndex:int = -1;
		/**
		 * 下一个战斗音乐的开始下载的时刻帧(倒计时,以帧为单位)
		 */		
		private var nextMusicDownFrame:int = 0;
		/**
		 * 下一个战斗音乐的开始播放的时刻帧(倒计时,以帧为单位)
		 */		
		private var nextMusicPlayFrame:int = 0;
		/**
		 * 当前战斗节已播放帧数
		 */		
		private var curSectionPlayedFrame:int = 0;
		/**
		 * 当前战斗节所需帧数
		 */		
		private var curSectionFrameCount:int = 0;
		/**
		 * 下一战斗节索引
		 */		
		private var nextBattleIndex:int = -1;
		/**
		 * NetStream的个数
		 */		
		private var nsCount:int = 0;
		
		private var frame:uint = 0;
		/**
		 * 播放下一个FLV的帧偏移
		 */		
		private var offsetFrame:int = 4;
		/**
		 * 战斗音乐是否允许中断
		 */		
		private var battleEnableInterrupt:Boolean = false;
		/**
		 * 指示是否正在播放战斗音乐
		 */		
		private var isBattlePlaying:Boolean = false;
		
		public function playBattleMusic(pMusicList:Array, sectionList:Array):void
		{
			resetBattleData();
			curPlayingMusicList = pMusicList;
			bt_array = sectionList;
			
			for(var i:uint = 0; i < pMusicList.length; i++)
			{
				createBattleNetStream();
			}
			
			down();
		}
		
		public function setInterrupt(value:Boolean):void
		{
			battleEnableInterrupt = value;
		}
		
		private function resetBattleData():void
		{
			ns_array = [];
			tc_array = [];
			curPlayingMusicList = null;
			bt_array = null;
			curBattleMusic = null;
			nextBattleMusic = null;
			curBattleIndex = -1;
			nextMusicDownFrame = 0;
			nextMusicPlayFrame = 0;
			curSectionPlayedFrame = 0;
			curSectionFrameCount = 0;
			nextBattleIndex = -1;
			nsCount = 0;
		}
		
		private function createBattleNetStream():BattleMusicInfo
		{
			var obj:Object = {};
			var _this:MusicManager = this;
			obj.onMetaData = function (info:Object):void{
				_this.battleOnMetaData(info, _this);
			}
			
			var bmi:BattleMusicInfo = new BattleMusicInfo();
			
			bmi.i = nsCount;
			bmi.loadFlag = LoadFlag.UnLoad;
			
			bmi.ns = new NetStream(nc);
			bmi.ns.client = obj;
			bmi.ns.addEventListener(NetStatusEvent.NET_STATUS, __battleNetStreamStatusHandler);
			ns_array.push(bmi);
			
			nsCount++;
			return bmi;
		}
		
		private function removeBattleNetStream():BattleMusicInfo
		{
			var bmi:BattleMusicInfo = ns_array.shift() as BattleMusicInfo;
			return bmi;
		}
		
		private function __battleNetStreamStatusHandler(e:NetStatusEvent):void
		{
			if(e.info.code != "NetStream.Buffer.Flush")
				trace("BattleNetStreamStatus->" + e.info.level + " : " + e.info.code);
			if("NetStream.Play.Start" == e.info.code)
			{
				stage.addEventListener(Event.ENTER_FRAME, __enterFrameHandler);
			}
			
			if("NetStream.Pause.Notify" == e.info.code)
			{
				stage.removeEventListener(Event.ENTER_FRAME, __enterFrameHandler);
			}
			
			if("NetStream.Unpause.Notify" == e.info.code)
			{
				stage.addEventListener(Event.ENTER_FRAME, __enterFrameHandler);
			}
			
			if("NetStream.Play.Stop" == e.info.code)
			{
//				stage.removeEventListener(Event.ENTER_FRAME, __enterFrameHandler);
			}
		}
		
		private function __enterFrameHandler(e:Event):void
		{
			frame++;
			
			if(nextMusicDownFrame > 1)
			{
				--nextMusicDownFrame;
				if(nextMusicDownFrame == 1)
				{
					down();
				}
			}
			
			if(nextMusicPlayFrame > 1)
			{
				--nextMusicPlayFrame;
				if(nextMusicPlayFrame == 1)
				{
//					stage.removeEventListener(Event.ENTER_FRAME, __enterFrameHandler);
					curSectionPlayedFrame += frame;
					curSectionPlayedFrame += offsetFrame;
					trace("curSectionPlayedFrame: " + curSectionPlayedFrame);
					playNextBattleMusic();
					
					trace("totalFrame:" + frame);
					trace("Battle music play over and play next.");
				}
			}
			
			if(interruptDelay > 0)
			{
				--interruptDelay;
				if(interruptDelay == 0)
				{
					if(interruptNetStram)
						interruptNetStram.close();
					interruptNetStram = null;
				}
			}
		}
		
		public function battleOnMetaData(info:Object, _this:MusicManager):void
		{
			tc_array.push(Number(info.duration));
			if(curBattleMusic == null)
				playNextBattleMusicImplement();
			trace("battleOnMetaData->info.duration:" + info.duration);
			trace("nextMusicPlayFrame: " + nextMusicPlayFrame + " nextMusicDownFrame: " + nextMusicDownFrame);
		}
		
		private function playNextBattleMusic():void
		{
			trace("playNextBattleMusicImplement->playNextBattleMusicImplement");
			playNextBattleMusicImplement();
		}
		
		private function playNextBattleMusicImplement():void
		{
			curBattleIndex = nextBattleIndex;
			if(curBattleIndex >= curPlayingMusicList.length)
			{
				isBattlePlaying = false;
				return;
			}
			
			isBattlePlaying = true;
			
			curSectionFrameCount = Math.round(Number(bt_array[curBattleIndex]) * stage.frameRate);
			
			if(curBattleMusic)
			{
				curBattleMusic.removeEventListener(NetStatusEvent.NET_STATUS, __battleNetStreamStatusHandler);
				if(battleEnableInterrupt)
					interruptBattleMusic(curBattleMusic);
			}
			
			curBattleMusic = nextBattleMusic.ns;
			curBattleMusic.soundTransform = new SoundTransform(curMusicVolumn / 100);
			curBattleMusic.resume();
			
			calcNextMusicPlayFrame();
			calcNextMusicDownFrame();
			nextMusicPlayFrame -= offsetFrame;
			if(nextMusicPlayFrame <= 1)
				nextMusicPlayFrame = 2;
			frame = 0;
			trace("=====playNextBattleMusicImplement->nextMusicDownFrame: " + nextMusicDownFrame + "=====")
		}
		
		private function calcNextMusicDownFrame():void
		{
			nextMusicDownFrame = nextMusicPlayFrame - stage.frameRate * 5;
			if(nextMusicDownFrame <= 1) nextMusicDownFrame = 2;
		}
		
		private function calcNextMusicPlayFrame():void
		{
			nextMusicPlayFrame = Math.round(tc_array[nextBattleMusic.i] * stage.frameRate);
			
			if(battleEnableInterrupt)
			{
				var playedFrame:int = nextMusicPlayFrame + curSectionPlayedFrame;
				if(playedFrame >= curSectionFrameCount)
				{
					nextMusicPlayFrame = nextMusicPlayFrame - (playedFrame - curSectionFrameCount);
				}
			}
		}
		private var interruptNetStram:NetStream;
		private var interruptDelay:int;
		private function interruptBattleMusic(musicNS:NetStream):void
		{
			if(interruptNetStram)
				interruptNetStram.close();
			interruptNetStram = musicNS;
			interruptDelay = offsetFrame + 1;
		}
		
		private function down():void
		{
			trace("down");
			
			var hadPlayFrame:int;
			
			if(nextBattleMusic == null)
				hadPlayFrame = 0;
			else
				hadPlayFrame = Math.round(Number(tc_array[nextBattleMusic.i]) * stage.frameRate) + curSectionPlayedFrame;
			
			if(hadPlayFrame >= curSectionFrameCount)
			{
				nextBattleIndex++;
			}
			else
			{
				//第一次播放时会多一个
				createBattleNetStream();
			}
			
			if(nextBattleIndex >= curPlayingMusicList.length)
				return;
			
			nextBattleMusic = removeBattleNetStream();
			nextBattleMusic.ns.play(musicRoot + (curPlayingMusicList[nextBattleIndex] as String) + ".flv");
			nextBattleMusic.ns.pause();
		}
		
		
		/////////////////////////////////////////////	普通背景音乐   /////////////////////////////////////////////
		/////////////////////////////////////////////	普通背景音乐   /////////////////////////////////////////////
		/////////////////////////////////////////////	普通背景音乐   /////////////////////////////////////////////
		/////////////////////////////////////////////	普通背景音乐   /////////////////////////////////////////////
		/////////////////////////////////////////////	普通背景音乐   /////////////////////////////////////////////
		private var curPlayingMusic:String;
		private var loopType:String;
		private var isPlaying:Boolean = false;
		
		private var nc:NetConnection;
		private var ns:NetStream;
		
		public function playMusic(pMusicList:Array, startIndex:uint, loopType:String = LoopType.CIRCULATORY_PLAY):void
		{
			if(LoopType.isLoopType(loopType) == false)
				throw new ArgumentError("The value of 'loopType' is not valid in LoopType");
			
			if(pMusicList == null || pMusicList.length == 0 || startIndex < 0 || startIndex >= pMusicList.length)
				throw new ArgumentError("The value of 'pMusicList' or 'startIndex' is not valid");
			
			resetMusicData();
			
			this.loopType = loopType;
			stopMusic();
			curPlayingMusicList = pMusicList;
			playMusicImplement(curPlayingMusicList[startIndex]);
		}
		
		private function resetMusicData():void
		{
			loopType = "";
			curPlayingMusicList = null;
			curPlayingMusic = null;
		}
		
		public function onMetaData(info:Object):void
		{
			trace("onMetaData->info.duration:" + info.duration);
		}
		
		private function playMusicImplement(music:String):void
		{
			curPlayingMusic = music;
			
			if(curPlayingMusic == null) return;
			
			isPlaying = true;
			
			ns.close();
			
			ns.play(musicRoot + music + ".flv");
			
			ns.soundTransform = new SoundTransform(curMusicVolumn / 100);
			
			ns.addEventListener(NetStatusEvent.NET_STATUS, __nsNetStatusHandler);
		}
		
		public function setVolume(value:int):void
		{
			if(value < 0)
				value = 0;
			if(value > 100)
				value = 100;
			
			curMusicVolumn = value;
			
			if(ns)
				ns.soundTransform = new SoundTransform(curMusicVolumn / 100);
			
			if(curBattleMusic)
				curBattleMusic.soundTransform = new SoundTransform(curMusicVolumn / 100);
		}
		
		public function stopMusic():void
		{
			if(isPlaying)
			{
				isPlaying = false;
				if(ns)
					ns.close();
				ns = null;
			}
			
			if(isBattlePlaying)
			{
				isBattlePlaying = false;
				if(curBattleMusic)
				{
					curBattleMusic.removeEventListener(NetStatusEvent.NET_STATUS, __battleNetStreamStatusHandler);
					curBattleMusic.close();
				}
				curBattleMusic = null;
				resetBattleData();
			}
		}
		
		private function __nsNetStatusHandler(e:NetStatusEvent):void
		{
			if(e.info.code == "NetStream.Play.Failed")
			{
				curMusicFailedTime++;
				if(curMusicFailedTime <= musicFailedTryTime)
				{
					ns.play(musicRoot + curPlayingMusic + ".flv");
				}
				else
				{
					throw new Error("The " + musicRoot + curPlayingMusic + ".flv file play failed.");
				}
			}
			if(e.info.code == "NetStream.Play.StreamNotFound")
			{
				throw new Error("The " + musicRoot + curPlayingMusic + ".flv file is not found.");
			}
			if(e.info.code == "NetStream.Play.Stop")
			{
				isPlaying = true;
				if(loopType == LoopType.SINGLE_PLAY)
				{
					replayMusic();
				}
				else if(loopType == LoopType.CIRCULATORY_PLAY)
				{
					circulatoryPlayNext();
				}
				else if(loopType == LoopType.RANDOM_PLAY)
				{
					randomPlayNext();
				}
//				else if(loopType == LoopType.BATTLE_PLAY)
//				{
//					battlePlayNext();
//				}
				else
				{
					normalPlayNext();
				}
			}
		}
		/**
		 * 单曲循环
		 * 
		 */		
		private function replayMusic():void
		{
			ns.seek(0);
			ns.resume();
		}
		/**
		 * 循环播放
		 * 
		 */		
		private function circulatoryPlayNext():void
		{
			var index:int = curPlayingMusicList.indexOf(curPlayingMusic);
			index++;
			if(index >= curPlayingMusicList.length)
				index = 0;
			
			playMusicImplement(curPlayingMusicList[index]);
		}
		/**
		 * 随机播放
		 * 
		 */		
		private function randomPlayNext():void
		{
			var index:int = Math.floor(Math.random() * curPlayingMusicList.length);
			
			playMusicImplement(curPlayingMusicList[index]);
		}
		/**
		 * 战斗播放
		 * 
		 */		
		private function battlePlayNext():void
		{
			
		}
		/**
		 * 顺序播放
		 * 
		 */		
		private function normalPlayNext():void
		{
			var index:int = curPlayingMusicList.indexOf(curPlayingMusic);
			index++;
			if(index >= curPlayingMusicList.length)
				return;
			
			playMusicImplement(curPlayingMusicList[index]);
		}
		
		private static var instance:MusicManager;
		
		public static function get Instance():MusicManager
		{
			if(instance) return instance;
			
			instance = new MusicManager();
			
			return instance;
		}
	}
}