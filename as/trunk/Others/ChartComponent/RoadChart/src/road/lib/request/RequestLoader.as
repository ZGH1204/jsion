package road.lib.request
{
	import flash.net.URLVariables;
	
	import road.lib.loader.TextLoader;

	public class RequestLoader extends TextLoader
	{
		public function RequestLoader(path:String,params:Object = null)
		{
			super(path);
			
			var urlVars:URLVariables = new URLVariables();
			
			if(params)
			{
				for(var s:String in params)
				{
					urlVars[s] = params[s];
				}
			}
			
			urlVars["rnd"] = Math.random();
			_url.data = urlVars;
		}
		
		override protected function onCompleted():void
		{
			var xml:XML;
			try
			{
				xml = new XML(this.data);
			}
			catch(e:Error)
			{
				
			}
			if(xml)
			{
				onRequestReturn(xml);
			}
			super.onCompleted();
		}
		
		protected function onRequestReturn(xml:XML):void
		{
			
		}
	}
}