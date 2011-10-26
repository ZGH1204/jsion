package jsion.rpg.engine
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import jsion.core.loaders.ImageLoader;
	import jsion.core.loaders.XmlLoader;
	import jsion.rpg.engine.datas.MapConfig;
	import jsion.rpg.engine.emitters.BaseEmitter;
	import jsion.rpg.engine.games.BaseGame;
	import jsion.rpg.engine.games.BaseMap;
	import jsion.rpg.engine.games.RPGGame;
	import jsion.utils.DisposeUtil;
	import jsion.utils.PathUtil;
	import jsion.utils.XmlUtil;
	
	public class RPGEngine extends Sprite
	{
		public static var MapsList:HashMap = new HashMap();
		
		protected var m_w:int;
		
		protected var m_h:int;
		
		protected var m_autoPlay:Boolean;
		
		protected var m_mapConfig:MapConfig;
		
		protected var m_game:BaseGame;
		
		protected var m_emitter:BaseEmitter;
		
		
		protected var m_starting:Boolean;
		
		
		protected var m_mapBmp:Bitmap;
		
		protected var m_ready:Boolean;
		
		
		public function RPGEngine(w:int, h:int, mapID:String, autoPlay:Boolean = true)
		{
			super();
			
			m_w = w;
			m_h = h;
			
			m_autoPlay = autoPlay;
			
			m_starting = false;
			
			if(MapsList.containsKey(mapID) == false)
			{
				throw new Error("RPGEngine.MapsList地图不存在,请查检地图ID是否正确或者为当前地图ID向RPGEngine.MapsList中添加地图配置文件所在路径.");
				return;
			}
			
			var configPath:String = PathUtil.combinPath(BaseMap.MapsRoot, MapsList.get(mapID));
			
			new XmlLoader(configPath).loadAsync(configLoadCallback);
			
			m_mapBmp = new Bitmap();
			addChild(m_mapBmp);
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
			
			var mapAssetRoot:String = PathUtil.combinPath(BaseMap.MapsRoot, m_mapConfig.MapAssetRoot, "/")
			
			new ImageLoader(m_mapConfig.SmallMapFile, {root: mapAssetRoot}).loadAsync(loadSmallMapCallback);
		}
		
		protected function loadSmallMapCallback(loader:ImageLoader):void
		{
			if(loader.isComplete == false)
			{
				throw new Error("缩略地图加载失败");
				DisposeUtil.free(loader);
				return;
			}
			
			var bmd:BitmapData = Bitmap(loader.content).bitmapData.clone();
			
			m_game = new RPGGame(m_w, m_h, m_mapConfig, bmd);
			
			m_emitter = new BaseEmitter(m_game);
			
			m_mapBmp.bitmapData = m_game.buffer;
			
			DisposeUtil.free(loader);
			
			initialize();
			
			if(m_autoPlay) play();
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		protected function initialize():void
		{
			m_ready = true;
		}
		
		public static function getMapsRoot():String
		{
			return BaseMap.MapsRoot;
		}
		
		public static function setMapsRoot(path:String):void
		{
			BaseMap.MapsRoot = path;
		}
		
		public function play():Sprite
		{
			if(m_starting) return this;
			
			if(m_ready == false)
			{
				throw new Error("未完成准备");
				return this;
			}
			
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
			onEnterFrameHandler();
		}
		
		protected function onEnterFrameHandler():void
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
		
		public function get game():BaseGame
		{
			return m_game;
		}
	}
}