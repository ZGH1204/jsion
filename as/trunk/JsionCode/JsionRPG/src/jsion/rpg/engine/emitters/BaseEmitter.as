package jsion.rpg.engine.emitters
{
	import jsion.rpg.engine.games.BaseGame;

	public class BaseEmitter implements IDispose
	{
		protected var m_game:BaseGame;
		
		public function BaseEmitter(game:BaseGame)
		{
			m_game = game;
		}
		
		public function emitte():void
		{
			m_game.render();
		}
		
		public function dispose():void
		{
			
		}
	}
}