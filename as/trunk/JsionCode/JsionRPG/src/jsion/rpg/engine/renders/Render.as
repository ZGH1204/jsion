package jsion.rpg.engine.renders
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import jsion.rpg.engine.gameobjects.GameObject;
	import jsion.rpg.engine.games.BaseGame;

	public class Render
	{
		public var buffer:BitmapData;
		
		protected var lastPoint:Point = new Point();
		
		protected var renderPoint:Point = new Point();
		
		protected var dirtyRect:Rectangle = new Rectangle();
		
		public function Render()
		{
		}
		
		public function render(object:GameObject):void
		{
		}
		
		public function renderClear(object:GameObject):void
		{
		}
		
		protected function drawClear(source:BitmapData, objRenderRect:Rectangle, game:BaseGame):void
		{
			dirtyRect.x = lastPoint.x;
			dirtyRect.y = lastPoint.y;
			dirtyRect.width = objRenderRect.width;
			dirtyRect.height = objRenderRect.height;
			
			buffer.copyPixels(game.worldMap.buffer, dirtyRect, lastPoint);
		}
		
		protected function draw(source:BitmapData, sourceRect:Rectangle, game:BaseGame):void
		{
			if(source == null) return;
			
			try
			{
				buffer.copyPixels(source, sourceRect, renderPoint, null, null, true);
			}
			catch(err:Error)
			{
				trace('渲染错误：', err.name, err.message);
			}
		}
	}
}