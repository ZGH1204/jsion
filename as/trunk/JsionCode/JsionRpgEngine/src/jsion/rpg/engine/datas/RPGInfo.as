package jsion.rpg.engine.datas
{
	import flash.display.BitmapData;
	
	import jsion.IDispose;

	public class RPGInfo implements IDispose
	{
		public var mapInfo:MapInfo;
		
		public var smallOrLoopBmd:BitmapData;
		
		public function RPGInfo()
		{
		}
		
		public function dispose():void
		{
			mapInfo = null;
			smallOrLoopBmd = null;
		}
	}
}