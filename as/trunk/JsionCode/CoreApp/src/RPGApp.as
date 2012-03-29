package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import jsion.rpg.engine.RPGEngine;
	
	[SWF(width="1000", height="600", frameRate="30")]
	public class RPGApp extends Sprite
	{
		private var launcher:Launcher;
		
		
		private var rpg:RPGEngine;
		
		public function RPGApp()
		{
			launcher = new Launcher(stage);
			
			launcher.launch("config.xml", callback);
			
			addEventListener(MouseEvent.CLICK, __clickHandler);
		}
		
		private function __clickHandler(e:MouseEvent):void
		{
			if(hasEventListener(Event.ENTER_FRAME))
			{
				removeEventListener(Event.ENTER_FRAME, __enterFrameHandler);
			}
			else
			{
				addEventListener(Event.ENTER_FRAME, __enterFrameHandler);
			}
		}
		
		private function __enterFrameHandler(e:Event):void
		{
			var p:Point = rpg.game.centerPoint;
			
			p.x += 2;
			p.y += 1;
			
			rpg.game.centerPoint = p;
		}
		
		private function callback(config:XML):void
		{
			rpg = new RPGEngine(stage.stageWidth, stage.stageHeight);
			
			rpg.setMapID(1);
			
			rpg.start();
			
			addChild(rpg);
		}
	}
}