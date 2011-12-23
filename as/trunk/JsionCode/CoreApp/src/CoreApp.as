package
{
	import flash.display.Sprite;
	
	import jsion.components.Slider;
	import jsion.components.ScrollBar;
	import jsion.comps.events.UIEvent;
	import jsion.core.ant.generateCompcDemo;
	
	[SWF(width="1250", height="650", frameRate="30")]
	public class CoreApp extends Sprite
	{
		private var launcher:Launcher;
		
		public function CoreApp()
		{
			launcher = new Launcher(stage);
			
			launcher.launch("config.xml");
			
//			var slider:Slider = new Slider(Slider.VERTICAL);
//			
//			slider.move(10, 100);
//			
//			slider.showRule = true;
//			slider.ruleCount = 5;
////			slider.ruleOffset = -8;
////			slider.barOffset = 8;
//			slider.setBarStyle(Slider.UP_IMG, new SliderBarAsset());
//			slider.height = 100;
//			slider.addEventListener(UIEvent.CHANGE, __changeHandler);
//			
//			addChild(slider);
			
			var bar:ScrollBar = new ScrollBar(ScrollBar.VERTICAL);
			
			bar.setUpOrLeftStyle(ScrollBar.UP_IMG, new ScrollBarUpBtnAsset());
			bar.setDownOrRightStyle(ScrollBar.UP_IMG, new ScrollBarUpBtnAsset());
			bar.setBarStyle(ScrollBar.UP_IMG, new ScrollBarThumbAsset());
			
//			bar.viewSize = 1000;
//			bar.scrollSize = 300;
			
			bar.addEventListener(UIEvent.CHANGE, __changeHandler);
			
			addChild(bar);
			
//			trace(generateCompcDemo("ReleaseSLG", 
//				"C:\\Users\\Jsion\\Desktop\\CompilerDir", 
//				"F:\\SourceCode\\SLGClient", 
//				["F:\\SourceCode\\SLGClient\\SLGAssets\\libs", "F:\\SourceCode\\SLGClient\\SLGAssets\\uis"],
//				[{lib: "SLGCore", output: "SLGCore", sources: "F:\\SourceCode\\SLGClient\\SLGCore"}], 
//				"ref", 
//				"out",
//				"D:\\Program Files\\Adobe\\Adobe Flash Builder 4\\sdks\\4.0.0"));
		}
		
//		private function __changeHandler(e:UIEvent):void
//		{
//			trace(Slider(e.currentTarget).sliderValue.toFixed(2));
//		}
		
		private function __changeHandler(e:UIEvent):void
		{
			trace(ScrollBar(e.currentTarget).scrollValue.toFixed(2));
		}
	}
}