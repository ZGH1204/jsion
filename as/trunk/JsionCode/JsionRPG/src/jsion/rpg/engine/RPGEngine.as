package jsion.rpg.engine
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import jsion.core.loaders.XmlLoader;
	import jsion.rpg.engine.datas.MapConfig;
	import jsion.rpg.engine.emitters.BaseEmitter;
	import jsion.rpg.engine.games.RPGGame;
	import jsion.rpg.engine.games.WorldMap;
	import jsion.utils.DisposeUtil;
	import jsion.utils.XmlUtil;
	
	public class RPGEngine extends Sprite
	{
		protected var m_w:int;
		
		protected var m_h:int;
		
		
		protected var m_mapConfig:MapConfig;
		
		protected var m_game:RPGGame;
		
		protected var m_emitter:BaseEmitter;
		
		
		protected var m_starting:Boolean;
		
		
		protected var m_mapBmp:Bitmap;
		
		
		public function RPGEngine(w:int, h:int, configPath:String)
		{
			super();
			m_w = w;
			m_h = h;
			
			m_starting = false;
			
			new XmlLoader(configPath).loadAsync(configLoadCallback);
		}
		
		private function configLoadCallback(loader:XmlLoader):void
		{
			if(loader.isComplete == false)
			{
				throw new Error("配置文件加载失败");
				DisposeUtil.free(loader);
				return;
			}
			
			m_mapConfig = new MapConfig();
			
			var xml:XML = loader.content as XML;
			
			XmlUtil.decodeWithProperty(m_mapConfig, xml);
			
			DisposeUtil.free(loader);
			
			m_game = new RPGGame(m_w, m_h, m_mapConfig);
			
			m_emitter = new BaseEmitter(m_game);
			
			m_mapBmp = new Bitmap(m_game.buffer);
			addChild(m_mapBmp);
		}
		
		public static function getMapsRoot():String
		{
			return WorldMap.MapsRoot;
		}
		
		public static function setMapsRoot(path:String):void
		{
			WorldMap.MapsRoot = path;
		}
		
		public function play():Sprite
		{
			if(m_starting) return this;
			
			m_starting = true;
			
			addEventListener(Event.ENTER_FRAME, __enterFrameHandler);
			
			return this;
		}
		
		public function stop():Sprite
		{
			if(m_starting == false) return this;
			
			m_starting = false;
			
			removeEventListener(Event.ENTER_FRAME, __enterFrameHandler);
			
			return this;
		}
		
		private function __enterFrameHandler(e:Event):void
		{
			if(m_emitter) m_emitter.emitte();
		}
		
		public function setCameraWH(w:int, h:int):void
		{
			if(w <= 0 || h <= 0) return;
			
			if(m_w == w && m_h == h) return;
			
			m_w = w;
			
			m_h = h;
			
			if(m_game)
			{
				m_game.setCameraWH(w, h);
				
				m_mapBmp.bitmapData = m_game.buffer;
			}
		}
		
		public function get gameWidth():int
		{
			return m_w;
		}
		
		public function get gameHeight():int
		{
			return m_h;
		}
		
		public function get game():RPGGame
		{
			return m_game;
		}
	}
}