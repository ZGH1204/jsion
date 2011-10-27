package jsion.rpg.engine.renders
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import jsion.rpg.engine.games.GameObject;

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
		
		protected function drawClear(source:BitmapData, rect:Rectangle, object:GameObject = null):void
		{
			dirtyRect.x = rect.x - object.game.worldMap.originX;
			dirtyRect.y = rect.y - object.game.worldMap.originY;
			dirtyRect.width = rect.width;
			dirtyRect.height = rect.height;
			
			buffer.copyPixels(source, dirtyRect, lastPoint);
		}
		
		protected function draw(source:BitmapData, rect:Rectangle, object:GameObject = null):void
		{
			if(source == null) return;
			
			try
			{
				buffer.copyPixels(source, rect, renderPoint, null, null, true);
			}
			catch(err:Error)
			{
				trace('渲染错误：', err.name, err.message);
			}
		}
	}
}