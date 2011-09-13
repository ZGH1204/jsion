package
{
	import flash.display.*;
	
	import org.cfg.*;

	public function JStartup(launcher:Launcher):void
	{
		Config.setup(launcher.config);
	}
}