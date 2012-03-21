package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	[SWF(width="1250", height="650", frameRate="30")]
	public class RenderTest extends Sprite
	{
		[Embed("/assets/00000.png")]
		private var m_bmd0:Class;
		
		[Embed("/assets/00001.png")]
		private var m_bmd1:Class;
		
		[Embed("/assets/00002.png")]
		private var m_bmd2:Class;
		
		[Embed("/assets/00003.png")]
		private var m_bmd3:Class;
		
		[Embed("/assets/00004.png")]
		private var m_bmd4:Class;
		
		[Embed("/assets/00005.png")]
		private var m_bmd5:Class;
		
		[Embed("/assets/00006.png")]
		private var m_bmd6:Class;
		
		[Embed("/assets/00007.png")]
		private var m_bmd7:Class;
		
		[Embed("/assets/00008.png")]
		private var m_bmd8:Class;
		
		public function RenderTest()
		{
			var bmp:Bitmap = new m_bmd0();
			addChild(bmp);
		}
	}
}