package jsion.rpg.emitters
{
	import flash.utils.getTimer;
	
	import jsion.rpg.RPGGame;
	import jsion.rpg.RPGGlobal;

	public class RPGEmitter extends BaseEmitter
	{
		private var game:RPGGame;
		
		public function RPGEmitter(g:RPGGame)
		{
			game = g;
			super();
		}
		
		override public function emitte():void
		{
			RPGGlobal.TIMER = getTimer();
			game.render();
		}
	}
}