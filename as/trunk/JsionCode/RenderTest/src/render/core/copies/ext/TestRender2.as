package render.core.copies.ext
{
	import flash.display.BitmapData;
	
	import render.core.copies.GameObject;
	import render.core.copies.Render;
	
	public class TestRender2 extends Render
	{
		public function TestRender2()
		{
			super();
		}
		
		override public function renderMe(bitmapData:BitmapData, buffer:BitmapData, object:GameObject):void
		{
			//if(object.bmp.bitmapData == object.bmdList[object.curIndex]) return;
			
			object.bmp.bitmapData = object.bmdList[object.curIndex] as BitmapData;
		}
	}
}