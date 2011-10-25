package editor.showers
{
	import flash.display.Shape;
	
	import jsion.rpg.engine.games.WorldMap;

	public class BaseShower
	{
		protected var shower:MapShower;
		
		protected var map:WorldMap;
		
		public function BaseShower(shower:MapShower)
		{
			this.shower = shower;
			
			map = shower.game.worldMap;
			
			initialize();
		}
		
		protected function initialize():void
		{
		}
		
		public function update():void
		{
		}
		
		public function setVisible(value:Boolean):void
		{
		}
	}
}