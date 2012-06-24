package jsion.sounds
{
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import jsion.utils.StringUtil;

	/**
	 * Flv流媒体背景音乐播放管理器
	 * @author Jsion
	 * 
	 */	
	public class MusicMgr
	{
		/**
		 * 是否循环播放列表里的音乐文件
		 */		
		public static var musicLoop:Boolean = true;
		
		/**
		 * 是否允许播放音乐
		 */		
		public static var allowMusic:Boolean = true;
		
		/**
		 * 播放音量
		 */		
		public static var volume:int = 100;
		
		private static var m_musicFileList:Array;
		
		private static var m_netConnection:NetConnection;
		
		private static var m_netStream:NetStream;
		
		private static var m_currentIndex:int;
		
		private static var m_playing:Boolean;
		
		public function MusicMgr()
		{
		}
		
		/**
		 * 配置必需是根节点的直接子节点，并且仅第一个有效，格式如下：
		 * <p>&lt;music files="1.flv,2.flv,3.flv" /&gt;</p>
		 * @param config
		 * 
		 */		
		public static function setup(config:XML):void
		{
			if(m_musicFileList) return;
			
			var musicXml:XML = config.music[0];
			
			if(musicXml && StringUtil.isNotNullOrEmpty(String(musicXml.@files)))
			{
				m_musicFileList = String(musicXml.@files).split(",");
			}
			
			m_netConnection = new NetConnection();
			m_netConnection.connect(null);
			
			m_netStream = new NetStream(m_netConnection);
			m_netStream.bufferTime = 1;
			
			var customClient:Object = {};
			
			customClient["onMetaData"] = MusicMgr["onMetaData"];
			
			m_netStream.client = customClient;
			
			m_netStream.addEventListener(NetStatusEvent.NET_STATUS, __netStatus);
			
			m_currentIndex = -1;
		}
		
		private static function __netStatus(e:NetStatusEvent):void
		{
			// TODO Auto-generated method stub
			if(e.info.code == "NetStream.Play.Stop")
			{
				m_playing = false;
				
				if(musicLoop)
				{
					playMusicImp(m_musicFileList);
				}
			}
		}
		
		public static function onMetaData(info:Object):void { }
		
		private static function playMusicImp(list:Array):void
		{
			m_currentIndex++;
			
			if(m_currentIndex >= list.length)
			{
				m_currentIndex = 0;
			}
			
			m_playing = true;
			m_netStream.play(list[m_currentIndex]);
			m_netStream.soundTransform = new SoundTransform(volume / 100);
		}
		
		public static function playMusic():void
		{
			if(m_musicFileList == null || allowMusic == false || m_playing) return;
			
			playMusicImp(m_musicFileList);
		}
		
		public static function stopMusic():void
		{
			if(m_playing)
			{
				m_netStream.removeEventListener(NetStatusEvent.NET_STATUS, __netStatus);
				m_netStream.close();
				m_playing = false;
			}
		}
		
		public static function pauseMusic():void
		{
			if(m_playing)
			{
				m_netStream.pause();
				m_playing = false;
			}
			else if(m_currentIndex >= 0)
			{
				m_netStream.resume();
				m_playing = true;
			}
		}
	}
}