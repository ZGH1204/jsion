package jsion.debug
{
	import flash.text.StyleSheet;
	import flash.text.TextField;
	
	import jsion.core.loaders.TextLoader;
	import jsion.core.modules.BaseModule;
	import jsion.core.modules.ModuleInfo;

	public class DebugConsoleModule extends BaseModule
	{
		private var loader:TextLoader;
		
		public function DebugConsoleModule(info:ModuleInfo)
		{
			super(info);
		}
		
		override public function startup():void
		{
			loader = new TextLoader("style.css");
			loader.loadAsync(loadCallback);
		}
		
		private function loadCallback(l:TextLoader):void
		{
			var str:String = l.content as String;
			
			var txt:TextField = new TextField();
			var style:StyleSheet = new StyleSheet();
			
			style.parseCSS(str);
			
			txt.styleSheet = style;
			
			txt.htmlText = "<jsion>lkjsdflkjasdf</jsion>";
			
			StageRef.addChild(txt);
		}
		
		override public function stop():void
		{
			
		}
	}
}