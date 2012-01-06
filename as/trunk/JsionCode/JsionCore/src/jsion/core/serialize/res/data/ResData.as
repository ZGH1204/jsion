package jsion.core.serialize.res.data
{
	import flash.display.BitmapData;
	
	import jsion.HashMap;

	public class ResData
	{
		private var m_actions:HashMap;
		private var m_frameRate:uint;
		
		public function ResData()
		{
			m_actions = new HashMap();
			m_frameRate = 30;
		}
		
		public function addImage(bmd:BitmapData, action:int, dir:int):void
		{
			
		}
		
		public function setFrameRate(rate:uint):void
		{
			m_frameRate = rate;
		}
	}
}