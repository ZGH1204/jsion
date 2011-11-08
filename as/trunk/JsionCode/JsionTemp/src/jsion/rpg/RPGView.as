package jsion.rpg
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import jsion.rpg.emitters.BaseEmitter;
	import jsion.rpg.emitters.RPGEmitter;
	import jsion.utils.DisposeUtil;
	
	public class RPGView extends Sprite implements IDispose
	{
		protected var m_bmp:Bitmap;
		
		protected var m_emitter:BaseEmitter;
		
		public function RPGView()
		{
			super();
			
			initialize();
		}
		
		private function initialize():void
		{
			m_bmp = new Bitmap();
			addChild(m_bmp);
			
			m_emitter = new RPGEmitter();
			
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