package jsion.rpg.map
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import jsion.Constant;
	import jsion.HashMap;
	import jsion.IDispose;
	import jsion.core.loaders.ImageLoader;
	import jsion.rpg.RPGGlobal;
	import jsion.rpg.ResourcePool;
	import jsion.rpg.StaticMethod;
	import jsion.utils.DisposeUtil;
	import jsion.utils.PathUtil;
	import jsion.utils.StringUtil;

	public class TileAdapter implements IDispose
	{
		protected var m_mapid:String
		
		protected var m_map:WorldMap;
		
		protected var m_loadings:HashMap;
		
		protected var m_pool:ResourcePool;
		
		protected var m_smallMapRect:Rectangle;
		
		
		protected var m_cameraWidth:int;
		protected var m_cameraHeight:int;
		protected var m_smallMapScale:Number;
		protected var m_matrix:Matrix;
		protected var m_tempPoint:Point;
		protected var m_tempBmd:BitmapData;
		protected var m_tileAssetRoot:String;
		protected var m_loaderConfig:Object;
		
		public function TileAdapter(map:WorldMap)
		{
			m_map = map;
			
			m_loadings = new HashMap();
			
			m_pool = new ResourcePool();
			
			m_smallMapRect = new Rectangle();
			
			m_matrix = new Matrix();
			
			m_tempPoint = new Point();
			
			m_loaderConfig = new Object();
		}
		
		public function setMapID(mapid:String):void
		{
			m_mapid = mapid;
			m_tileAssetRoot = PathUtil.combinPath(RPGGlobal.MAPS_ROOT, m_mapid, RPGGlobal.TILE_ASSET_DIR);
			m_loaderConfig.root = m_tileAssetRoot;
		}
		
		public function setCameraSize(w:int, h:int):void
		{
			m_cameraWidth = w;
			m_cameraHeight = h;
		}
		
		public function calcOthers():void
		{
			if(m_map.smallMap == null) return;
			
			m_smallMapScale = m_map.smallMap.width / m_map.mapWidth;
			
			m_smallMapRect.width = m_cameraWidth * m_smallMapScale;
			m_smallMapRect.height = m_cameraHeight * m_smallMapScale;
			
			m_matrix.a = m_matrix.d = m_cameraWidth / m_smallMapRect.width;
			
			if(m_tempBmd) m_tempBmd.dispose();
			
			m_tempBmd = new BitmapData(m_smallMapRect.width, m_smallMapRect.height);
		}
		
		public function fill(buffer:BitmapData):void
		{
			drawSmallMap(buffer);
			copyTiles(buffer);
		}
		
		private function drawSmallMap(buffer:BitmapData):void
		{
			if(m_map.smallMap)
			{
				m_smallMapRect.x = m_map.startX * m_smallMapScale;
				m_smallMapRect.y = m_map.startY * m_smallMapScale;
				
				m_tempBmd.fillRect(m_tempBmd.rect, 0);
				m_tempBmd.copyPixels(m_map.smallMap, m_smallMapRect, Constant.ZeroPoint);
				
				buffer.draw(m_tempBmd, m_matrix);
			}
		}
		
		private function copyTiles(buffer:BitmapData):void
		{
			var tileStartX:int = m_map.startTileX * m_map.tileWidth;
			var tileStartY:int = m_map.startTileY * m_map.tileHeight;
			
			var maxX:int = Math.min(m_map.cameraTileCountX + tileStartX, m_map.maxTileX);
			var maxY:int = Math.min(m_map.cameraTileCountY + tileStartY, m_map.maxTileY);
			
			
			
			for(var y:int = m_map.startTileY; y < maxY; y++)
			{
				for(var x:int = m_map.startTileX; x < maxX; x++)
				{
					if(x < 0 || y < 0) continue;
					
					var key:String = y + "_" + x;
					
					if(m_pool.hasRes(key))
					{
						var bmd:BitmapData = m_pool.getRes(key) as BitmapData;
						
						drawTile(buffer, bmd, x, y);
					}
					else
					{
						if(m_loadings.containsKey(key)) continue;
						
						var loader:ImageLoader = new ImageLoader(key + m_map.tileExt, m_loaderConfig);
						
						loader.tag = key;
						
						m_loadings.put(key, loader);
						
						loader.loadAsync(tileLoadCallback);
					}
				}
			}
		}
		
		private function tileLoadCallback(loader:ImageLoader):void
		{
			m_loadings.remove(loader.tag);
			
			if(loader.isComplete == false)
			{
				StaticMethod.t(StringUtil.format("加载{0}出错", loader.uri));
				
				DisposeUtil.free(loader);
				
				return;
			}
			
			var key:String = loader.tag as String;
			
			var pos:Array = key.split("_");
			var x:int = int(pos[1]);
			var y:int = int(pos[0]);
			
			var bmd:BitmapData = Bitmap(loader.content).bitmapData;
			
			m_pool.addRes(key, bmd);
			
			DisposeUtil.free(loader);
			
			drawTile(m_map.buffer, bmd, x, y);
			
			m_map.addTileLoadComplete(x, y, bmd);
		}
		
		public function drawTile(buffer:BitmapData, tileBmd:BitmapData, tileX:int, tileY:int):void
		{
			m_tempPoint.x = tileX * m_map.tileWidth - m_map.startX;
			m_tempPoint.y = tileY * m_map.tileHeight - m_map.startY;
			
			buffer.copyPixels(tileBmd, tileBmd.rect, m_tempPoint);
		}
		
		public function dispose():void
		{
			DisposeUtil.free(m_loadings);
			m_loadings = null;
			
			DisposeUtil.free(m_pool);
			m_pool = null;
			
			DisposeUtil.free(m_tempBmd);
			m_tempBmd = null;
			
			m_smallMapRect = null;
			
			m_matrix = null;
			
			m_tempPoint = null;
			
			m_loaderConfig = null;
			
			m_map = null;
		}
	}
}