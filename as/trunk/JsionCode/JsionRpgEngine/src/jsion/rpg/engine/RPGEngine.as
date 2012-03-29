package jsion.rpg.engine
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	public class RPGEngine extends RPGSprite
	{
		protected var m_bitmap:Bitmap;
		
		protected var m_camera:Rectangle;
		
		protected var m_waitingLayer:Sprite;
		
		
		protected var m_game:RPGGame;
		
		
		public function RPGEngine(w:int, h:int)
		{
			super();
			
			m_camera = new Rectangle(0, 0, w, h);
			
			intialize();
		}
		
		private function intialize():void
		{
			m_game = new RPGGame(m_camera.width, m_camera.height);
			
			m_bitmap = new Bitmap(m_game.bitmapData);
			
			m_waitingLayer = new Sprite();
			
			
			
			
			addChild(m_bitmap);
			addChild(m_waitingLayer);
			
		}
		
		public function start():void
		{
			addEventListener(Event.ENTER_FRAME, __enterFrameHandler);
		}
		
		public function stop():void
		{
			removeEventListener(Event.ENTER_FRAME, __enterFrameHandler);
		}
		
		private function __enterFrameHandler(e:Event):void
		{
			m_game.render();
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
	}
}