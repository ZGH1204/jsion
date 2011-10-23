package jsion.rpg.engine
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class EngineSprite extends Sprite implements IDispose
	{
		public function EngineSprite()
		{
			super();
			
			addEventListener(Event.ACTIVATE, __activateHandler);
			addEventListener(Event.DEACTIVATE, __deactivateHandler);
		}
		
		private function __activateHandler(e:Event):void
		{
			onActivate();
		}
		
		private function __deactivateHandler(e:Event):void
		{
			onDeactivate();
		}
		
		protected function onActivate():void
		{
			
		}
		
		protected function onDeactivate():void
		{
			
		}
		
		public function dispose():void
		{
			removeEventListener(Event.ACTIVATE, __activateHandler);
			removeEventListener(Event.DEACTIVATE, __deactivateHandler);
		}
	}
}