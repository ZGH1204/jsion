package knightage.requests
{
	import jsion.loaders.XmlLoader;
	
	public class BaseRequest extends XmlLoader
	{
		public function BaseRequest(file:String)
		{
			super(file, Config.Request, false);
			
			cache = false;
			cacheInMemory = false;
			
			setURLVariables("rnd", Math.random());
		}
	}
}