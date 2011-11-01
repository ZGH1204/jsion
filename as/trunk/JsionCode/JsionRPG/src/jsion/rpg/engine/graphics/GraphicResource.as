package jsion.rpg.engine.graphics
{
	import flash.display.BitmapData;

	public class GraphicResource extends GraphicInfo
	{
		public var bitmapData:BitmapData;
		
		public var bitmapDataMirror:BitmapData;
		
		public var bitmapDataDefault:BitmapData;
		
		protected var needMirror:Boolean;
		
		public function GraphicResource()
		{
		}
		
		
	}
}