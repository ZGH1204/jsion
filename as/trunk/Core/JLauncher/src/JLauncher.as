package
{
	import flash.display.Sprite;
	
	[SWF(width="900", height="600", frameRate="30")]
	public class JLauncher extends Sprite
	{
		private var _launcher:Launcher;
		
		public function JLauncher()
		{
			_launcher = new Launcher(this, "config.xml", JStartup);
			
			_launcher.launch();
		}
	}
}