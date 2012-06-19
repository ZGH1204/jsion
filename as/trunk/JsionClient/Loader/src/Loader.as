package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import jsion.startup.Startuper;
	
	[SWF(width="1250", height="650", frameRate="30")]
	public class Loader extends Sprite
	{
		private var m_startuper:Startuper;
		
		public function Loader()
		{
			if(stage)
			{
				initialize();
			}
			else 
			{
				addEventListener(Event.ADDED_TO_STAGE, onAddToStageHandler);
			}
		}
		
		private function onAddToStageHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddToStageHandler);
			
			initialize();
		}
		
		private function initialize():void
		{
			m_startuper = new Startuper(stage);
			
			m_startuper.startup("config.xml");
		}
	}
}