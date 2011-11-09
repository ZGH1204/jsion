package jsion.rpg
{
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	
	import jsion.core.events.JLoaderEvent;
	import jsion.core.events.JLoaderProgressEvent;
	import jsion.core.loaders.JLoaders;
	import jsion.core.quadtree.QTree;
	import jsion.rpg.interfaces.IPrepareMap;
	import jsion.rpg.map.WorldMap;
	import jsion.rpg.objects.GameObject;
	import jsion.rpg.renders.RenderInfo;
	import jsion.utils.ArrayUtil;
	import jsion.utils.DictionaryUtil;
	import jsion.utils.DisposeUtil;
	import jsion.utils.PathUtil;
	import jsion.utils.XmlUtil;

	public class RPGGame
	{
		protected var m_objects:Array;
		
		protected var m_prepareMap:IPrepareMap;
		
		protected var m_cameraWidth:int;
		
		protected var m_cameraHeight:int;
		
		protected var m_buffer:BitmapData;
		
		protected var m_worldMap:WorldMap;
		
		protected var m_qTree:QTree;
		
		protected var m_loader:JLoaders;
		
		protected var m_currentMapID:String;
		
		protected var m_currentMapConfigFile:String;
		
		protected var m_currentSmallMapFile:String;
		
		protected var m_hitDatas:Array;
		
		protected var m_renderInfos:HashMap;
		
		public function RPGGame(cameraWidth:int, cameraHeight:int)
		{
			m_cameraWidth = cameraWidth;
			m_cameraHeight = cameraHeight;
			
			m_objects = [];
			
			m_buffer = new BitmapData(m_cameraWidth, m_cameraHeight, true, 0xFF000000);
			
			m_worldMap = new WorldMap();
			m_worldMap.setCameraSize(m_cameraWidth, m_cameraHeight);
		}
		
		public function get cameraWidth():int
		{
			return m_cameraWidth;
		}
		
		public function get cameraHeight():int
		{
			return m_cameraHeight;
		}
		
		public function get buffer():BitmapData
		{
			return m_buffer;
		}
		
		public function get worldMap():WorldMap
		{
			return m_worldMap;
		}
		
		public function render():void
		{
			m_worldMap.render(m_buffer);
			
			var gameObject:GameObject;
			
			var list:Array = m_objects;
			
			for each(gameObject in list)
			{
				gameObject.clearMe();
			}
			
			for each(gameObject in list)
			{
				gameObject.renderMe();
			}
		}
		
		
		
		public function setPrepareMapProxy(proxy:IPrepareMap):void
		{
			DisposeUtil.free(m_prepareMap);
			
			m_prepareMap = proxy;
			
			if(m_prepareMap) m_prepareMap.setGame(this);
		}
		
		public function setQTree(qt:QTree):void
		{
			m_qTree = qt;
		}
		
		
		
		public function changeMap(mapid:String):void
		{
			if(m_currentMapID == mapid) return;
			
			m_currentMapID = mapid;
			
			m_currentMapConfigFile = PathUtil.combinPath(m_currentMapID, RPGGlobal.MAP_CONFIG_FILE);
			
			m_currentSmallMapFile = PathUtil.combinPath(m_currentMapID, RPGGlobal.SMALL_MAP_FILE);
			
			refreshMap();
		}
		
		
		public function cancelChangeMap():void
		{
			if(m_loader)
			{
				m_loader.removeEventListener(JLoaderProgressEvent.PROGRESS, __mapLoadProgressHandler);
				m_loader.removeEventListener(JLoaderEvent.Error, __mapLoadErrorHandler);
			}
			
			DisposeUtil.free(m_loader);
			
			m_loader = null;
		}
		
		private function __mapLoadProgressHandler(e:JLoaderProgressEvent):void
		{
			if(m_prepareMap) m_prepareMap.progress(e.bytesLoaded, e.bytesTotal);
		}
		
		private function __mapLoadErrorHandler(e:JLoaderEvent):void
		{
			if(m_prepareMap) m_prepareMap.loadError(e.data as String);
		}
		
		private function refreshMap():void
		{
			cancelChangeMap();
			
			if(RPGGlobal.MAP_CONFIG_LIST.containsKey(m_currentMapID))
			{
				var xml:XML = RPGGlobal.MAP_CONFIG_LIST.get(m_currentMapID) as XML;
				
				var bmd:BitmapData = RPGGlobal.SMALL_MAP_LIST.get(m_currentMapID) as BitmapData;
				
				parseMapConfig(xml, bmd);
			}
			else
			{
				m_loader = new JLoaders("WorldMapLoader", 8, {root: RPGGlobal.MAPS_ROOT});
				
				m_loader.addEventListener(JLoaderProgressEvent.PROGRESS, __mapLoadProgressHandler);
				m_loader.addEventListener(JLoaderEvent.Error, __mapLoadErrorHandler);
				
				m_loader.add(m_currentMapConfigFile);
				m_loader.add(m_currentSmallMapFile);
				
				m_loader.start(mapLoadCallback);
				
				if(m_prepareMap) m_prepareMap.startLoading();
			}
		}
		
		private function mapLoadCallback(loaders:JLoaders):void
		{
			var xml:XML = loaders.getXml(m_currentMapConfigFile);
			
			var bmd:BitmapData = loaders.getBitmapData(m_currentSmallMapFile);
			
			if(xml && bmd)
			{
				RPGGlobal.MAP_CONFIG_LIST.put(m_currentMapID, xml);
				RPGGlobal.SMALL_MAP_LIST.put(m_currentMapID, bmd);
				
				parseMapConfig(xml, bmd);
			}
			else
			{
				StaticMethod.t("地图加载失败, MapID:", m_currentMapID);
			}
			
			if(m_prepareMap) m_prepareMap.loadComplete();
		}
		
		private function parseMapConfig(config:XML, bmd:BitmapData):void
		{
			var mWidth:int = int(config.@width);
			var mHeight:int = int(config.@height);
			var tileWidth:int = int(config.@tileWidth);
			var tileHeight:int = int(config.@tileHeight);
			var tileExt:String = String(config.@tileExt);
			var hitTileWidth:int = int(config.@hitTileWidth);
			var hitTileHeight:int = int(config.@hitTileHeight);
			var hitData:String = config.hitData.text();
			
			m_hitDatas = [];
			var list:Array = hitData.split("|");
			m_hitDatas.length = list.length;
			
			for(var i:int = 0; i < list.length; i++)
			{
				var str:String = list[i];
				m_hitDatas[i] = str.split(",");
			}
			
			m_renderInfos.removeAll();
			
			var renderInfosXL:XMLList = config.renders..render;
			
			var xml:XML;
			
			for each(xml in renderInfosXL)
			{
				var info:RenderInfo = new RenderInfo();
				XmlUtil.decodeWithProperty(info, xml);
				m_renderInfos.put(info.filename, info);
			}
			
			m_worldMap.setMapID(m_currentMapID);
			m_worldMap.setSmallMap(bmd);
			m_worldMap.setMapSize(mWidth, mHeight);
			m_worldMap.setTileSize(tileWidth, tileHeight);
			m_worldMap.calcCameraTileSize();
			m_worldMap.calcCenterPointRect();
			m_worldMap.reviseCenterPoint();
			m_worldMap.build();
			m_worldMap.repaintBuffer();
			
			var buildingsXL:XMLList = config.buildings..building;
			
			var mapid:String;
			var name:String;
			var filename:String;
			var posX:int;
			var posY:int;
			
			for each(xml in buildingsXL)
			{
				filename = String(xml.@filename);
				posX = int(xml.@x);
				posY = int(xml.@y);
			}
			
			var npcsXL:XMLList = config.npcs..npc;
			
			for each(xml in npcsXL)
			{
				name = String(xml.@name);
				filename = String(xml.@filename);
				posX = int(xml.@x);
				posY = int(xml.@y);
			}
			
			var jumpsXL:XMLList = config.jumps..jump;
			
			for each(xml in npcsXL)
			{
				mapid = String(xml.@mapid);
				filename = String(xml.@filename);
				posX = int(xml.@x);
				posY = int(xml.@y);
			}
		}
	}
}