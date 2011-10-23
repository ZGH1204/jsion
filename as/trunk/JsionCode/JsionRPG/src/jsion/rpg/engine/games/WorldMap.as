package jsion.rpg.engine.games
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	
	import jsion.core.loaders.ImageLoader;
	import jsion.rpg.engine.RPGEngine;
	import jsion.rpg.engine.datas.MapConfig;
	import jsion.utils.DisposeUtil;
	import jsion.utils.PathUtil;

	public class WorldMap extends EventDispatcher implements IDispose
	{
		public var mapid:String;
		
		public var mapWidth:int;
		
		public var mapHeight:int;
		
		public var tileWidth:int;
		
		public var tileHeight:int;
		
		protected var m_mapRoot:String;
		
		protected var m_mapAssetRoot:String;
		
		protected var m_tileAssetRoot:String;
		
		protected var m_mapConfig:MapConfig;
		
		protected var m_cameraWidth:int;
		
		protected var m_cameraHeight:int;
		
		protected var m_smallMap:BitmapData;
		
		protected var m_tileAdapter:TileAdapter;
		
		protected var m_buffer:BitmapData;
		
		
		
		
		public var needRepaintMap:Boolean;
		
		
		protected var m_smallMapLoader:ImageLoader;
		
		protected var m_smallMapCallback:Function;
		
		protected var m_tileCallback:Function;
		
		
		
		
		public function WorldMap(mapConfig:MapConfig, cameraWidth:int, cameraHeight:int)
		{
			m_mapConfig = mapConfig;
			
			m_cameraWidth = cameraWidth;
			m_cameraHeight = cameraHeight;
			
			initialize();
			
			loadSmallMap();
		}
		
		protected function initialize():void
		{
			mapid = m_mapConfig.MapID;
			mapWidth = m_mapConfig.MapWidth;
			mapHeight = m_mapConfig.MapHeight;
			tileWidth = m_mapConfig.TileWidth;
			tileHeight = m_mapConfig.TileHeight;
			
			m_mapRoot = PathUtil.combinPath(RPGEngine.MapAssetRoot, mapid, "/");
			m_mapAssetRoot = PathUtil.combinPath(RPGEngine.MapAssetRoot, m_mapConfig.MapAssetRoot, "/");
			m_tileAssetRoot = PathUtil.combinPath(RPGEngine.MapAssetRoot, m_mapConfig.TileAssetRoot, "/");
			
			m_tileAdapter = new TileAdapter(this);
			m_buffer = new BitmapData(m_cameraWidth, m_cameraHeight, true, 0);
		}
		
		protected function loadSmallMap():void
		{
			m_smallMapLoader = new ImageLoader(m_mapConfig.SmallMapFile, {root: m_mapAssetRoot});
			m_smallMapLoader.loadAsync(smallMapLoadCallback);
		}
		
		private function smallMapLoadCallback(loader:ImageLoader):void
		{
			if(loader.isComplete == false)
			{
				throw new Error("缩略图加载失败");
				
				DisposeUtil.free(m_smallMapLoader);
				m_smallMapLoader = null;
				
				return;
			}
			
			var bmp:Bitmap = loader.content as Bitmap;
			
			m_smallMap = bmp.bitmapData.clone();
			
			DisposeUtil.free(m_smallMapLoader);
			m_smallMapLoader = null;
			
			refreshBuffer();
			
			needRepaintMap = true;
			
			if(m_smallMapCallback != null) m_smallMapCallback();
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function render(buffer:BitmapData):void
		{
			refreshBuffer();
			
			needRepaintMap = false;
			
			buffer.copyPixels(m_buffer, m_buffer.rect, Constant.ZeroPoint);
		}
		
		protected function refreshBuffer():void
		{
			m_tileAdapter.fill(m_buffer);
		}
		
		public function get mapRoot():String
		{
			return m_mapRoot;
		}
		
		public function get mapAssetRoot():String
		{
			return m_mapAssetRoot;
		}
		
		public function get tileAssetRoot():String
		{
			return m_tileAssetRoot;
		}
		
		public function get buffer():BitmapData
		{
			return m_buffer;
		}
		
		public function get smallMap():BitmapData
		{
			return m_smallMap;
		}
		
		public function get smallMapCallback():Function
		{
			return m_smallMapCallback;
		}
		
		public function set smallMapCallback(value:Function):void
		{
			m_smallMapCallback = value;
		}
		
		/**
		 * 调用方式：tileCallback(tileX, tileY, bmd)，其中，tileX和tileY为Tile编号(非坐标)。
		 */		
		public function get tileCallback():Function
		{
			return m_tileCallback;
		}
		
		public function set tileCallback(value:Function):void
		{
			m_tileCallback = tileCallback;
		}
		
		public function dispose():void
		{
			DisposeUtil.free(m_tileAdapter);
			m_tileAdapter = null;
			
			DisposeUtil.free(m_smallMap);
			m_smallMap = null;
			
			DisposeUtil.free(m_buffer);
			m_buffer = null;
		}
	}
}