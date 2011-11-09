package jsion.rpg
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import jsion.core.quadtree.QTree;
	import jsion.rpg.emitters.BaseEmitter;
	import jsion.rpg.emitters.RPGEmitter;
	import jsion.utils.DisposeUtil;
	
	public class RPGView extends Sprite implements IDispose
	{
		protected var m_bmp:Bitmap;
		
		
		protected var m_game:RPGGame;
		
		protected var m_emitter:BaseEmitter;
		
		
		
		public function RPGView(cameraWidth:int, cameraHeight:int)
		{
			super();
			
			m_game = new RPGGame(cameraWidth, cameraHeight);
			
			m_emitter = new RPGEmitter(m_game);
			
			m_bmp = new Bitmap(m_game.buffer);
			addChild(m_bmp);
			
			addEventListener(Event.ENTER_FRAME, __enterFrameHandler);
		}
		
		private function __enterFrameHandler(e:Event):void
		{
			m_emitter.emitte();
		}
		
		public function dispose():void
		{
			removeEventListener(Event.ENTER_FRAME, __enterFrameHandler);
			
			DisposeUtil.free(m_bmp);
			m_bmp = null;
		}
	}
}