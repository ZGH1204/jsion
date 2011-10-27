package jsion.rpg.engine.gameobjects
{
	import flash.display.BitmapData;

	public class GraphicResources implements IDispose
	{
		public static const MIRROR:String = '_mirror';
		
		/**
		 * 位图
		 */ 
		public var bitmap:BitmapData;
		
		/**
		 * 镜像位图
		 */
		public var mirrorBitmapData:BitmapData;
		
		
		
		public function GraphicResources()
		{
		}
		
		public function dispose():void
		{
		}
	}
}