package jsion.rpg.emitters
{
	import jsion.rpg.RPGGame;

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
			game.render();
		}
	}
}