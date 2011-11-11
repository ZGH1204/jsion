package jsion.rpg.editor.centers
{
	import jsion.rpg.RPGGame;
	import jsion.rpg.RPGView;
	
	public class MapShower extends RPGView
	{
		public function MapShower(cameraWidth:int, cameraHeight:int)
		{
			super(cameraWidth, cameraHeight);
		}
		
		override protected function createGame(cameraWidth:int, cameraHeight:int):RPGGame
		{
			return new MapGame(cameraWidth, cameraHeight);
		}
		
		public function setCameraSize(w:int, h:int):void
		{
			m_game.setCameraSize(w, h);
			
			m_bmp.bitmapData = m_game.buffer;
		}
	}
}