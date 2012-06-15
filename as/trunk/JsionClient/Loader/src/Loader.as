package
{
	import flash.display.Sprite;
	
	import jsion.startup.Startuper;
	
	[SWF(width="1250", height="650", frameRate="30")]
	public class Loader extends Sprite
	{
		private var m_startuper:Startuper;
		
		public function Loader()
		{
			m_startuper = new Startuper(stage);
			
			m_startuper.startup("config.xml");
		}
	}
}