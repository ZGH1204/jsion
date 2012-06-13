package jsion.rpg.renders
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import jsion.rpg.objects.GameObject;

	public class Render2D
	{
		public var buffer:BitmapData;
		
		protected var lastPoint:Point;
		
		protected var renderPoint:Point;
		
		protected var tempRect:Rectangle;
		
		public function Render2D()
		{
			lastPoint = new Point();
			renderPoint = new Point();
			tempRect = new Rectangle();
		}
		
		public function clearMe(gameObject:GameObject):void
		{
		}
		
		public function renderMe(gameObject:GameObject):void
		{
		}
	}
}