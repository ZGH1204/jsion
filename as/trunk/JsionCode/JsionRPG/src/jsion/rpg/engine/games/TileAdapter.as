package jsion.rpg.engine.games
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import jsion.core.loaders.ImageLoader;
	import jsion.rpg.engine.ResourcePool;
	import jsion.utils.DisposeUtil;
	import jsion.utils.StringUtil;

	public class TileAdapter implements IDispose
	{
		protected var m_map:WorldMap;
		
		protected var m_pool:ResourcePool;
		
		protected var m_destPoint:Point;
		
		protected var m_tempRect:Rectangle;
		
		protected var m_loadings:HashMap;
		
		public function TileAdapter(map:WorldMap)
		{
			m_map = map;
			
			m_destPoint = new Point();
			
			m_tempRect = new Rectangle();
			
			m_loadings = new HashMap();
			
			m_pool = new ResourcePool();
		}
		
		public function fill(buffer:BitmapData):void
		{
			var startx:int = m_map.originX;
			var starty:int = m_map.originY;
			
			if(m_map.smallMap != null)
			{
				var scale:Number = m_map.smallMap.width / m_map.mapWidth;
				
				var temp:BitmapData = new BitmapData(m_map.buffer.width * scale, m_map.buffer.height * scale, true, 0);
				
				m_tempRect.x = startx * scale;
				m_tempRect.y = starty * scale;
				m_tempRect.width = temp.width;
				m_tempRect.height = temp.height;
				
				temp.copyPixels(m_map.smallMap, m_tempRect, Constant.ZeroPoint);
				
				scale = buffer.width / temp.width;
				
				buffer.draw(temp, new Matrix(scale, 0, 0, scale));
				temp.dispose();
			}
			
			var tilex:int = m_map.nowTileX;
			var tiley:int = m_map.nowTileY;
			
			var xCount:int = m_map.areaTileX;
			var yCount:int = m_map.areaTileY;
			
			if(startx > (tilex * m_map.tileWidth))
			{
				xCount++;
			}
			
			if(starty > (tiley * m_map.tileHeight))
			{
				yCount++;
			}
			
			var maxTileX:int = Math.min(tilex + xCount, m_map.maxTileX);
			var maxTileY:int = Math.min(tiley + yCount, m_map.maxTileY);
			
			for(var y:int = tiley; y < maxTileY; y++)
			{
				for(var x:int = tilex; x < maxTileX; x++)
				{
					if(x < 0 || y < 0) continue;
					
					var key:String = y + "_" + x;
					
					if(m_pool.containsKey(key))
					{
						var bmd:BitmapData = m_pool.get(key) as BitmapData;
						
						drawTile(buffer, bmd, x, y, startx, starty);
					}
					else
					{
						if(m_loadings.containsKey(key)) continue;
						
						var loader:ImageLoader = new ImageLoader(key + m_map.tileExtension, {root: m_map.tileAssetRoot});
						
						loader.tag = key;
						
						m_loadings.put(key, loader);
						
						loader.loadAsync(tileLoadCallback);
					}
				}
			}
		}
		
		public function drawTile(buffer:BitmapData, tileBmd:BitmapData, x:int, y:int, startx:int, starty:int):void
		{
			m_destPoint.x = x * m_map.tileWidth;
			m_destPoint.x = m_destPoint.x - startx;
			
			m_destPoint.y = y * m_map.tileHeight;
			m_destPoint.y = m_destPoint.y - starty;
			
			buffer.copyPixels(tileBmd, tileBmd.rect, m_destPoint);
		}
		
		private function tileLoadCallback(loader:ImageLoader):void
		{
			m_loadings.remove(loader.tag);
			
			if(loader.isComplete == false)
			{
				trace(StringUtil.format("加载{0}出错", loader.uri));
				
				DisposeUtil.free(loader);
				
				return;
			}
			
			var key:String = loader.tag as String;
			
			var pos:Array = key.split("_");
			var x:int = int(pos[1]);
			var y:int = int(pos[0]);
			
			var bmd:BitmapData = Bitmap(loader.content).bitmapData.clone();
			
			m_pool.put(key, bmd);
			
			DisposeUtil.free(loader);
			
			drawTile(m_map.buffer, bmd, x, y, m_map.originX, m_map.originY);
			
			if(m_map.tileCallback != null) m_map.tileCallback(x, y, bmd);
		}
		
		public function dispose():void
		{
			
		}
	}
}