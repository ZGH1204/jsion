package jsion.rpg.engine.renders
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import jsion.rpg.engine.GameObject;

	public class Render
	{
		public var buffer:BitmapData;
		
		protected var oldPoint:Point = new Point();
		
		protected var newPoint:Point = new Point();
		
		protected var dirtyRect:Rectangle = new Rectangle();
		
		public function Render()
		{
		}
		
		public function clear():void
		{
			
		}
		
		public function render(object:GameObject):void
		{
			
		}
		
		protected function drawClear(source:BitmapData, rect:Rectangle, object:GameObject = null):void
		{
			buffer.lock();
			
			dirtyRect
		}
		
		protected function draw(source:BitmapData, rect:Rectangle, object:GameObject = null):void
		{
			if(source == null) return;
			
			try
			{
				buffer.copyPixels(source, rect, newPoint, null, null, true);
			}
			catch(err:Error)
			{
				trace('渲染错误：', err.name, err.message);
			}
			finally
			{
				buffer.unlock();
			}
		}
	}
}