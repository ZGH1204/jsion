package jsion.rpg.engine
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import jsion.core.loaders.ImageLoader;
	import jsion.rpg.RPGGlobal;
	import jsion.rpg.engine.datas.MapInfo;
	import jsion.rpg.engine.datas.RPGInfo;
	import jsion.utils.DisposeUtil;
	import jsion.utils.StringUtil;
	
	public class RPGEngine extends RPGSprite
	{
		protected var m_bitmap:Bitmap;
		
		protected var m_camera:Rectangle;
		
		protected var m_waitingLayer:Sprite;
		
		
		protected var m_game:RPGGame;
		
		protected var m_rpgInfo:RPGInfo;
		
		protected var m_loader:ImageLoader;
		
		public function RPGEngine(w:int, h:int)
		{
			super();
			
			m_camera = new Rectangle(0, 0, w, h);
			
			intialize();
		}
		
		private function intialize():void
		{
			m_game = new RPGGame(m_camera.width, m_camera.height);
			
			m_bitmap = new Bitmap(m_game.bitmapData);
			
			m_waitingLayer = new Sprite();
			
			
			
			
			addChild(m_bitmap);
			addChild(m_waitingLayer);
			
		}
		
		public function get game():RPGGame
		{
			return m_game;
		}
		
		public function setMapID(id:int):void
		{
			m_rpgInfo = new RPGInfo();
			var mapInfo:MapInfo = new MapInfo();
			mapInfo.mapID = id;
			mapInfo.mapName = "测试地图";
			mapInfo.mapWidth = 2700;
			mapInfo.mapHeight = 1800;
			mapInfo.tileWidth = 100;
			mapInfo.tileHeight = 100;
			mapInfo.mapType = MapInfo.TileMap;
			mapInfo.smallWidth = 200;
			mapInfo.tileExt = ".jpg";
			m_rpgInfo.mapInfo = mapInfo;
			
			showLoading();
			
			var root:String = StringUtil.format(RPGGlobal.MapRoot, mapInfo.mapID);
			
			DisposeUtil.free(m_loader);
			m_loader = new ImageLoader("small.jpg", { root: root });
			m_loader.loadAsync(smallMapLoadCallback);
		}
		
		private function smallMapLoadCallback(loader:ImageLoader):void
		{
			if(loader.isComplete)
			{
				m_rpgInfo.smallOrLoopBmd = Bitmap(loader.content).bitmapData.clone();
				
				m_game.setMap(m_rpgInfo);
			}
			
			hideLoading();
		}
		
		public function showLoading():void
		{
			trace("正在加载地图数据...");
		}
		
		public function hideLoading():void
		{
			trace("地图数据加载完成...");
		}
		
		public function start():void
		{
			addEventListener(Event.ENTER_FRAME, __enterFrameHandler);
		}
		
		public function stop():void
		{
			removeEventListener(Event.ENTER_FRAME, __enterFrameHandler);
		}
		
		private function __enterFrameHandler(e:Event):void
		{
			m_game.render();
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
	}
}