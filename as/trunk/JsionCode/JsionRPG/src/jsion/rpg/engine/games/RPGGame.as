package jsion.rpg.engine.games
{
	import jsion.rpg.engine.datas.MapConfig;

	public class RPGGame extends BaseGame
	{
		public function RPGGame(w:int, h:int, mapConfig:MapConfig)
		{
			super(w, h, mapConfig);
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
	}
}