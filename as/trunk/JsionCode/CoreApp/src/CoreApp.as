package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.utils.ByteArray;
	
	import jsion.core.loader.BytesLoader;
	import jsion.core.loader.SwcLoader;
	import jsion.core.loader.LibLoader;
	import jsion.utils.AppDomainUtil;
	import jsion.utils.ByteArrayUtil;
	import jsion.utils.JUtil;
	
	[SWF(width="1250", height="650", frameRate="30")]
	public class CoreApp extends Sprite
	{
		public function CoreApp()
		{
			var loader:BytesLoader = new SwcLoader("Resources.swc");
			
			loader.loadAsync(callback);
		}
		
		private function callback(loader:BytesLoader, completed:Boolean):void
		{
			if(completed)
			{
				//trace(ByteArrayUtil.toHexDump("", loader.data as ByteArray, 0, int(loader.data.length)));
				
				trace("加载成功！");
				
				addChild(new Bitmap(AppDomainUtil.create("ButtonUpImgAsset", 0, 0) as BitmapData));
			}
		}
	}
}