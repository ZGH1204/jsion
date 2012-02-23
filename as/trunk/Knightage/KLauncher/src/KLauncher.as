package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	[SWF(width="1250", height="650")]
	public class KLauncher extends Sprite
	{
		private var launcher:Launcher;
		
		public function KLauncher()
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
			graphics.clear();
			
			graphics.beginFill(0x336699);
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			graphics.endFill();
			
			launcher = new Launcher(stage);
			
			launcher.launch("config.xml", startGame);
		}
		
		private function startGame(config:XML):void
		{
			if(launcher)
			{
				launcher.dispose();
				launcher = null;
			}
		}
	}
}