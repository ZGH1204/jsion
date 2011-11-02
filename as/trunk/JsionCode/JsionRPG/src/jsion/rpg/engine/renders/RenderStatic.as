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
		
		override public function render(object:GameObject):void
		{
			var tmp:Point = object.screenPos;
			
			renderPoint.x = tmp.x;
			renderPoint.y = tmp.y;
			
			draw(object.graphicResource.bitmapData, object.renderRect, object.game);
		}
	}
}