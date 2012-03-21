package render.core.copies.ext
{
	import flash.display.BitmapData;
	
	import render.core.copies.GameObject;
	import render.core.copies.Render;
	
	public class TestRender extends Render
	{
		
		public function TestRender()
		{
			super();
		}
		
		override public function clearMe(bitmapData:BitmapData, buffer:BitmapData, object:GameObject):void
		{
			bitmapData.copyPixels(buffer, object.renderRect, object.oldPos);
		}
		
		override public function renderMe(bitmapData:BitmapData, buffer:BitmapData, object:GameObject):void
		{
			bitmapData.copyPixels(object.bmdList[object.curIndex], object.renderRect, object.pos, null, null, true);
			
			object.oldPos.x = object.pos.x;
			object.oldPos.y = object.pos.y;
		}
	}
}