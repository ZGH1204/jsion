package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	[SWF(width="1250", height="650", frameRate="30")]
	public class Demo3D extends Sprite
	{
		[Embed(source = "texture.jpg")]
		private var c:Class;
		
		private var bitmapData:BitmapData;
		
		public function Demo3D()
		{
			super();
			
			bitmapData = (new c as Bitmap).bitmapData;
		}
	}
}