package jsion.rpg.engine.renders
{
	import flash.geom.Point;
	
	import jsion.rpg.engine.gameobjects.GameObject;

	public class RenderStatic extends Render
	{
		public function RenderStatic()
		{
			super();
		}
		
		override public function renderClear(object:GameObject):void
		{
			lastPoint.x = object.lastRenderPoint.x;
			lastPoint.y = object.lastRenderPoint.y;
			
			drawClear(object.graphicResource.bitmapData, object.renderRect, object.game);
		}
		
		override public function render(object:GameObject):void
		{
			var tmp:Point = object.renderPoint;
			
			renderPoint.x = tmp.x;
			renderPoint.y = tmp.y;
			
			updateRenderPoint(object);
			
			draw(object.graphicResource.bitmapData, object.renderRect, object.game);
			
			object.lastRenderPoint.x = renderPoint.x;
			object.lastRenderPoint.y = renderPoint.y;
		}
	}
}