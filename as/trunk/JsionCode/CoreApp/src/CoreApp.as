package
{
	import flash.display.Sprite;
	
	import jsion.core.ant.generateCompcDemo;
	
	[SWF(width="1250", height="650", frameRate="30")]
	public class CoreApp extends Sprite
	{
		private var launcher:Launcher;
		
		public function CoreApp()
		{
			launcher = new Launcher(stage);
			
			launcher.launch("config.xml");
			
//			trace(generateCompcDemo("ReleaseSLG", 
//				"C:\\Users\\Jsion\\Desktop\\CompilerDir", 
//				"F:\\SourceCode\\SLGClient", 
//				["F:\\SourceCode\\SLGClient\\SLGAssets\\libs", "F:\\SourceCode\\SLGClient\\SLGAssets\\uis"],
//				[{lib: "SLGCore", output: "SLGCore", sources: "F:\\SourceCode\\SLGClient\\SLGCore"}], 
//				"ref", 
//				"out",
//				"D:\\Program Files\\Adobe\\Adobe Flash Builder 4\\sdks\\4.0.0"));
		}
	}
}