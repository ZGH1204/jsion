package
{
	import flash.display.*;
	
	import org.Global;
	import org.cfg.*;

	public function JStartup(launcher:Launcher):void
	{
		Config.setup(launcher.config);
		
		Global.setup();
	}
}