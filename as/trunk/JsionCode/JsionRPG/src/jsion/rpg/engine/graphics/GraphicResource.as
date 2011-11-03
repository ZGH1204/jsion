package jsion.rpg.engine.graphics
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	
	import jsion.core.loaders.ILoader;
	import jsion.core.loaders.ImageLoader;
	import jsion.rpg.engine.games.BaseGame;
	import jsion.utils.DisposeUtil;
	import jsion.utils.PathUtil;

	public class GraphicResource extends GraphicInfo
	{
		public var bitmapData:BitmapData;
		
		public var bitmapDataMirror:BitmapData;
		
		//public var bitmapDataDefault:BitmapData;
		
		protected var needMirror:Boolean;
		
		protected var loader:ILoader;
		
		protected var game:BaseGame;
		
		public function GraphicResource(game:BaseGame, mirror:Boolean = false)
		{
			this.game = game;
			needMirror = mirror;
		}
		
		public function loadBitmapData():void
		{
			if(bitmapData || loader) return;
			
			loader = new ImageLoader(PathUtil.combinPath(game.worldMap.mapAssetRoot, path));
			
			loader.loadAsync(loadCallback);
		}
		
		private function loadCallback(l:ILoader):void
		{
			if(l.isComplete)
			{
				bitmapData = Bitmap(l.content).bitmapData;
				
				if(frameWidth <= 0 || frameHeight <= 0)
				{
					frameWidth = bitmapData.width;
					frameHeight = bitmapData.height;
					frameTotal = 1;
					fps = 1;
				}
				
				if(needMirror)
				{
					bitmapDataMirror = new BitmapData(bitmapData.width, bitmapData.height, true, 0);
					
					var matrix:Matrix = new Matrix(-1);
					
					bitmapDataMirror.draw(bitmapData, matrix);
				}
			}
			else
			{
				trace("图形资源加载失败", l.uri);
			}
			
			DisposeUtil.free(loader);
			loader = null;
		}
	}
}