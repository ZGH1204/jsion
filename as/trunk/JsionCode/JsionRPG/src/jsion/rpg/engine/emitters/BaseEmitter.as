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
			m_game.buffer.lock();
			
			m_game.render();
			
			m_game.buffer.unlock();
		}
		
		public function dispose():void
		{
			
		}
	}
}