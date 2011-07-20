package com.manager
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import com.data.SoundModel;

	public class SoundManager
	{
		//////////////////////////////////////////////////////////			音效功能			//////////////////////////////////////////////////////////
		
		private var coefficient:Number = 0.25;
		private var synchronous:int;
		private var stage:Stage;
		private var dic:Dictionary;
		private var curPlayingSound:Array = [];
		private var curSoundVolumn:int = 100;
		private var playSoundDelay:int = 0;
		private var lastPlayTime:int = 0;
		
		public function setSynchronous(value:int):void
		{
			synchronous = value;
		}
		
		public function setSoundVolumn(value:int):void
		{
			curSoundVolumn = value;
			if(curSoundVolumn < 0)
				curSoundVolumn = 0;
			if(curSoundVolumn > 100)
				curSoundVolumn = 100;
		}
		
		public function setConcurrentDelay(value:int):void
		{
			playSoundDelay = value;
		}
		
		public function setCoefficient(value:Number):void
		{
			coefficient = value
		}
		
		public function setup(stage:Stage, synchronous:int = 8):void
		{
			this.stage = stage;
			this.synchronous = synchronous;
			
			dic = new Dictionary();
			dic["Sound0002"] = Sound0002;
			dic["Sound0003"] = Sound0003;
			dic["Sound0004"] = Sound0004;
			dic["Sound0005"] = Sound0005;
			dic["Sound0006"] = Sound0006;
			dic["Sound0007"] = Sound0007;
			dic["Sound0008"] = Sound0008;
			dic["Sound0009"] = Sound0009;
			dic["Sound000A"] = Sound000A;
			dic["Sound000B"] = Sound000B;
			dic["Sound000C"] = Sound000C;
			dic["Sound000D"] = Sound000D;
			dic["Sound000E"] = Sound000E;
			dic["Sound000F"] = Sound000F;
			dic["Sound0010"] = Sound0010;
			dic["Sound0011"] = Sound0011;
			dic["Sound0012"] = Sound0012;
			dic["Sound0013"] = Sound0013;
			dic["Sound0014"] = Sound0014;
			dic["Sound0015"] = Sound0015;
			dic["Sound0016"] = Sound0016;
			dic["Sound0017"] = Sound0017;
			dic["Sound0018"] = Sound0018;
			dic["Sound0019"] = Sound0019;
			dic["Sound001A"] = Sound001A;
			dic["Sound001B"] = Sound001B;
			dic["Sound001C"] = Sound001C;
			dic["Sound001D"] = Sound001D;
			dic["Sound001E"] = Sound001E;
			dic["Sound001F"] = Sound001F;
			dic["Sound0020"] = Sound0020;
			dic["Sound0021"] = Sound0021;
			dic["Sound0022"] = Sound0022;
			dic["Sound0023"] = Sound0023;
			dic["Sound0024"] = Sound0024;
			dic["Sound0025"] = Sound0025;
			dic["Sound0026"] = Sound0026;
			dic["Sound0027"] = Sound0027;
			dic["Sound0028"] = Sound0028;
			dic["Sound0029"] = Sound0029;
			dic["Sound002A"] = Sound002A;
			dic["Sound002B"] = Sound002B;
			dic["Sound002C"] = Sound002C;
			dic["Sound002D"] = Sound002D;
			dic["Sound002E"] = Sound002E;
			dic["Sound002F"] = Sound002F;
			dic["Sound0030"] = Sound0030;
			dic["Sound0031"] = Sound0031;
			dic["Sound0032"] = Sound0032;
			dic["Sound0033"] = Sound0033;
			dic["Sound0034"] = Sound0034;
			dic["Sound0035"] = Sound0035;
			dic["Sound0036"] = Sound0036;
			dic["Sound0037"] = Sound0037;
			dic["Sound0038"] = Sound0038;
			dic["Sound0039"] = Sound0039;
			dic["Sound003A"] = Sound003A;
			dic["Sound003B"] = Sound003B;
			dic["Sound003C"] = Sound003C;
			dic["Sound003D"] = Sound003D;
		}
		
		public function get SoundVolumn():int
		{
			return curSoundVolumn;
		}
		
		public function set SoundVolumn(volumn:int):void
		{
			this.curSoundVolumn = volumn;
		}
		
		public function playSound(id:String, globalPoint:Point = null, manager:Boolean = false, multiSound:Boolean = true, loops:int = 0):void
		{
			if(dic[id] == null) return;
			
			if(multiSound || !isPlayingSound(id))
			{
				var volumn:int;
				if(globalPoint)
				{
					var centerPoint:Point = new Point(stage.stageWidth / 2, stage.stageHeight / 2);
					var distance:Number = Point.distance(globalPoint, centerPoint);
					var tmp:int = Math.ceil(curSoundVolumn - distance * coefficient);
					if(tmp <= 0) return;
					volumn = tmp;
				}
				else
				{
					volumn = curSoundVolumn;
				}
				
				playSoundImplement(id, volumn, manager, loops);
			}
		}
		/**
		 * 停止音效
		 * @param sc 声音通道
		 * 
		 */		
		public function stopSound(sc:SoundChannel):void
		{
			if(sc == null) return;
			
			sc.removeEventListener(Event.SOUND_COMPLETE, __soundCompleteHandler);
			sc.stop();
			
			for(var i:uint = 0; i < curPlayingSound.length; i++)
			{
				var sm:SoundModel = curPlayingSound[i] as SoundModel;
				if(sm.soundChannel == sc)
				{
					disposeSoundModel(sm);
					i--;
				}
			}
		}
		/**
		 * 通过ID停止所有
		 * @param id
		 * 
		 */		
		public function stopSoundById(id:String):void
		{
			for(var i:uint = 0; i < curPlayingSound.length; i++)
			{
				var sm:SoundModel = curPlayingSound[i] as SoundModel;
				if(sm.id == id)
				{
					disposeSoundModel(sm);
					i--;
				}
			}
		}
		/**
		 * 获取所有正在播放的音效数量
		 * @return 
		 * 
		 */		
		public function getPlayingSoundCount():uint
		{
			return curPlayingSound.length;
		}
		/**
		 * 通过ID获取正在播放的音效数量
		 * @param id
		 * @return 
		 * 
		 */		
		public function getPlayingSoundCountById(id:String):uint
		{
			var count:uint = 0;
			for each(var sm:SoundModel in curPlayingSound)
			{
				if(sm.id == id)
					count++;
			}
			
			return count;
		}
		/**
		 * 通过ID获取正在播放的音效数据模型SoundModel列表
		 * @param id
		 * @return 
		 * 
		 */		
		public function getPlayingSoundListById(id:String):Array
		{
			var list:Array = [];
			for each(var sm:SoundModel in curPlayingSound)
			{
				if(sm.id == id)
					list.push(sm);
			}
			
			return list;
		}
		/**
		 * 是否正在播放指定ID的音效
		 * @param id
		 * @return 
		 * 
		 */		
		public function isPlayingSound(id:String):Boolean
		{
			for each(var sm:SoundModel in curPlayingSound)
			{
				if(sm.id == id)
					return true;
			}
			return false;
		}
		
		private var curPlayingCount:int = 0;
		
		private function playSoundImplement(id:String, sndVolumn:int, manager:Boolean, loops:int):void
		{
			if(dic[id] == null || sndVolumn <= 0) return;
			
			if(manager && curPlayingCount > synchronous)
			{
				return;
			}
			
			var curTime:int = getTimer();
			var span:int = curTime - lastPlayTime;
			if(span < playSoundDelay)
			{
				setTimeout(playSoundImplement, playSoundDelay - span, id, sndVolumn, manager, loops);
				return;
			}
			
			curPlayingCount++;
			
			var snd:Sound = new dic[id]();
			var sm:SoundModel = new SoundModel();
			
			var sc:SoundChannel = snd.play(0, loops, new SoundTransform(sndVolumn / 100));
			
			sc.addEventListener(Event.SOUND_COMPLETE, __soundCompleteHandler);
			
			sm.id = id;
			sm.soundChannel = sc;
			
			curPlayingSound.push(sm);
			
			lastPlayTime = curTime;
		}
		
		private function __soundCompleteHandler(e:Event):void
		{
			stopSound(e.currentTarget as SoundChannel);
		}
		
		private function disposeSoundModel(sm:SoundModel):void
		{
			curPlayingSound.splice(curPlayingSound.indexOf(sm), 1);
			sm.soundChannel.removeEventListener(Event.SOUND_COMPLETE, __soundCompleteHandler);
			sm.soundChannel.stop();
			curPlayingCount--;
			sm.id = null;
			sm.soundChannel = null;
			sm = null;
		}
		
		private static var instance:SoundManager;
		
		public static function get Instance():SoundManager
		{
			if(instance) return instance;
			
			instance = new SoundManager();
			
			return instance;
		}
	}
}