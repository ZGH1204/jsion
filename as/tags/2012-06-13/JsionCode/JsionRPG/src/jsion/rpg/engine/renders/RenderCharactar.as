package jsion.rpg.engine.renders
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import jsion.rpg.engine.gameobjects.GameObject;

	public class RenderCharactar extends Render
	{
		public function RenderCharactar()
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
			
			var rect:Rectangle = object.renderRect;
			
			updateRenderRectByDir(object.direction, rect);
			
			if(checkUseMirror(object.direction))
			{
				draw(object.graphicResource.bitmapDataMirror, rect, object.game);
			}
			else
			{
				draw(object.graphicResource.bitmapData, rect, object.game);
			}
			
			object.lastRenderPoint.x = renderPoint.x;
			object.lastRenderPoint.y = renderPoint.y;
		}
		
		protected function updateRenderRectByDir(dir:int, rect:Rectangle):void
		{
			
		}
		
		protected function checkUseMirror(dir:int):Boolean
		{
			return false;
		}
	}
}