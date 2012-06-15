package jsion.sounds
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;
	
	import jsion.utils.DictionaryUtil;
	import jsion.utils.StringUtil;

	/**
	 * 声音、音效管理类
	 * @author Jsion
	 * 
	 */	
	public class SoundMgr
	{
		private static var list:Dictionary = new Dictionary();
		private static var groups:Dictionary = new Dictionary();
		
		private static var volumn:int = 80, mute:Boolean = false;
		
		private static var numPlaying:int = 0, sndTransform:SoundTransform = new SoundTransform(volumn / 100);
		
		/**
		 * 所有组正在播放声音的个数总和
		 * @return 个数总和
		 * 
		 */		
		public static function get playingCount():int
		{
			return numPlaying;
		}
		
		/**
		 * 设置声音配置
		 * @param volumn 音量
		 * @param mute 是否启用多声道播放
		 * 
		 */		
		public static function setConfig(volumn:int, mute:Boolean):void
		{
			if(volumn > 100) volumn = 100;
			else if(volumn < 0) volumn = 0;
			SoundMgr.volumn = volumn;
			SoundMgr.mute = mute;
			
			sndTransform.leftToRight = 0;
			sndTransform.rightToLeft = 0;
			
			sndTransform.volume = SoundMgr.volumn / 100;
			if(SoundMgr.mute)
			{
				sndTransform.leftToLeft = 0;
				sndTransform.rightToRight = 0;
			}
			else
			{
				sndTransform.leftToLeft = 1;
				sndTransform.rightToRight = 1;
			}
			
			updateAllSndTransform();
		}
		
		/**
		 * 注册声音数据
		 * @param id 声音ID
		 * @param sound 要注册的声音资源
		 * 
		 */		
		public static function registeSound(id:String, sound:Sound):void
		{
			if(list[id])
			{
				throw new Error("指定ID的声音已存在，请更换ID。");
				return;
			}
			
			list[id] = sound;
		}
		
		/**
		 * 移除声音数据
		 * @param id 声音ID
		 * @return 要移除的声音数据
		 * 
		 */		
		public static function removeSound(id:String):Class
		{
			var sound:Class = list[id] as Class;
			
			delete list[id];
			
			return sound;
		}
		
		/**
		 * 在组中播放指定声音
		 * @param id 要播放的声音ID
		 * @param group 要播放声音的组
		 * 
		 */		
		public static function play(id:String, multi:Boolean = true, group:String = "default", loops:int = 0):void
		{
			if(list[id] == null || mute || volumn == 0) return;
			
			if(multi || isPlaying(id, group) == false)
			{
				numPlaying++;
				var snd:Sound = list[id] as Sound;
				var sm:SoundMode = new SoundMode();
				sm.id = id;
				sm.group = group;
				sm.sc = snd.play(0, loops, sndTransform);
				sm.sc.addEventListener(Event.SOUND_COMPLETE, onSoundCompleteHandler);
				
				if(groups[group] == null) groups[group] = [];
				
				groups[group].push(sm);
			}
		}
		
		/**
		 * 停止组内指定声音ID的所有声音停止播放
		 * @param id 声音ID
		 * @param group 播放组
		 * 
		 */		
		public static function stop(id:String, group:String = "default"):void
		{
			if(StringUtil.isNullOrEmpty(id) || StringUtil.isNullOrEmpty(group)) return;
			var list:Array = groups[group];
			if(list == null) return;
			
			for (var i:int = 0; i < list.length; i++)
			{
				var sm:SoundMode = list[i] as SoundMode;
				if(sm.id == id)
				{
					destorySoundMode(sm);
					i--;
				}
			}
		}
		
		/**
		 * 停止指定组内的所有声音
		 * @param group 播放组
		 * 
		 */		
		public static function stopByGroup(group:String = "default"):void
		{
			if(StringUtil.isNullOrEmpty(group)) return;
			
			var list:Array = groups[group];
			
			while(list && list.length > 0)
			{
				var sm:SoundMode = list.shift() as SoundMode;
				destorySoundMode(sm);
			}
		}
		
		/**
		 * 停止所有组的所有声音
		 * 
		 */		
		public static function stopAll():void
		{
			var list:Array = DictionaryUtil.getKeys(groups);
			
			for each(var group:String in list)
			{
				stopByGroup(group);
			}
		}
		
		/**
		 * 指示声音是否在组内播放
		 * @param id 声音ID
		 * @param group 播放组
		 * @return 是否正在播放
		 * 
		 */		
		public static function isPlaying(id:String, group:String = "default"):Boolean
		{
			var list:Array = groups[group];
			for each(var sm:SoundMode in list)
			{
				if(sm.id == id) return true;
			}
			return false;
		}
		
		private static function updateAllSndTransform():void
		{
			var gList:Array = DictionaryUtil.getKeys(groups);
			
			for each(var group:String in gList)
			{
				var list:Array = groups[group];
				for each(var sm:SoundMode in list)
				{
					sm.sc.soundTransform = sndTransform;
				}
			}
		}
		
		private static function onSoundCompleteHandler(e:Event):void
		{
			var sc:SoundChannel = e.currentTarget as SoundChannel;
			var sm:SoundMode = findPlayingGroup(sc);
			destorySoundMode(sm);
		}
		
		private static function destorySoundMode(sm:SoundMode):void
		{
			if(sm == null) return;
			
			var list:Array = groups[sm.group];
			var index:int = list.indexOf(sm);
			
			sm.sc.removeEventListener(Event.SOUND_COMPLETE, onSoundCompleteHandler);
			sm.sc.stop();
			
			if(index != -1)
			{
				numPlaying--;
				list.splice(index, 1);
			}
		}
		
		private static function findPlayingGroup(sc:SoundChannel):SoundMode
		{
			var list:Array = DictionaryUtil.getKeys(groups);
			
			for each(var group:String in list)
			{
				var pList:Array = groups[group];
				for each(var sm:SoundMode in pList)
				{
					if(sm.sc == sc) return sm;
				}
			}
			
			return null;
		}
	}
}

/**
 * 声音、音效播放模型
 * @author Jsion
 * 
 */
class SoundMode
{
	import flash.media.SoundChannel;
	
	/**
	 * 声音、音效ID
	 */	
	public var id:String;
	/**
	 * 声音、音效播放组
	 */	
	public var group:String;
	/**
	 * 播放声音、音效的声道
	 */	
	public var sc:SoundChannel;
	/**
	 * 暂停位置
	 */	
	public var pausePosition:Number = 0;
}