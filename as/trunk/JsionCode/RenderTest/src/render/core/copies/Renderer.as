package render.core.copies
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class Renderer extends Bitmap
	{
		private var m_bitmapData:BitmapData;
		
		public function Renderer(w:int, h:int)
		{
			m_bitmapData = new BitmapData(w, h, true, 0);
			
			bitmapData = m_bitmapData;
		}
	}
}