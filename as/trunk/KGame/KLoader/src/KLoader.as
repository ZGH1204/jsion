package
{
	import flash.display.Sprite;
	
	[SWF(width="1250", height="650", frameRate="30")]
	public class KLoader extends Sprite
	{
		private var m_startuper:Startuper;
		
		public function KLoader()
		{
			m_startuper = new Startuper(stage);
			
			m_startuper.startup("config.xml");
		}
	}
}