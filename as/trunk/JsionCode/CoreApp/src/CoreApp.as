package
{
	import flash.display.Sprite;
	
	[SWF(width="900", height="580", frameRate="30")]
	public class CoreApp extends Sprite
	{
		private var launcher:Launcher;
		
		public function CoreApp()
		{
			launcher = new Launcher(stage);
			
			launcher.launch("config.xml");
		}
	}
}