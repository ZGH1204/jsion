package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	import render.core.copies.BaseGame;
	import render.core.copies.ext.TestGame;
	
	[SWF(width="1250", height="650", frameRate="30")]
	public class RenderTest extends Sprite
	{
		private var m_game:TestGame;
		
		private var m_bmp:Bitmap;
		
		public function RenderTest()
		{
			addChild(new FPSState());
			
			m_bmp = new Bitmap();
			addChild(m_bmp);
			
			m_game = new TestGame();
			
			m_bmp.bitmapData = m_game.bitmapData;
			
			m_game.start();
			
			
			for(var i:int = 0; i < 1500; i++)
			{
				m_game.create();
				//m_game.create2(this);
			}
		}
	}
}